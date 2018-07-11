library(haven)
library(tidyverse)
library(magrittr)
library(nlme)
library(sjPlot)
library(sjmisc)

setwd("/Users/hsuwei/Desktop/try/HLM")
mydata <- read_sav("newhwlevel1.sav")


# 資料探勘 --------------------------------------------------------------------

pacman::p_load(DataExplorer)

plot_density(mydata)
## `iq` 需要中心化、`ses` 已處理

## 中心化
mydata %<>%
  mutate(iq.lm = scale(iq, scale = F)) #`scale` argument 會進行標準化

# 分析 ----------------------------------------------------------------------

model1 <- lm(score ~ ses + iq.lm + sex, data = mydata)
summary(model1)



model2 <- lmer(score ~ ses + IQ + sex + (1|schoolid), data = mydata)
summary(model2.1)

sjt.lm(model2.1, p.kr = FALSE)

model3 <- lme(fixed = score ~ ses + IQ + sex, random = ~ 1 + sch_ses_mean + sch_iqv_mean|schoolid, data = mydata,
              control = lmeControl(opt = 'optim'))
summary(model3)

model5.1 <- lmer(score ~ ses + IQ + sex + sch_ses_mean + sch_iqv_mean + (1|schoolid), data = mydata)

sjt.lm(model2.1, model5.1, p.kr = FALSE, show.icc = T, group.pred = TRUE)


model6.1 <- lmer(score ~ ses + IQ + sex + (ses + IQ + sex | schoolid), data = mydata)
model6.2 <- lmer(score ~ ses + IQ + sex + sch_ses_mean + sch_iqv_mean + (ses + IQ + sex)*sch_ses_mean +
                   (ses + IQ + sex)*sch_iqv_mean + (ses + IQ + sex | schoolid), data = mydata)

sjt.lm(model6.1, model6.2, p.kr = FALSE, show.icc = T, group.pred = TRUE)

sjt.lm