library(haven)
library(tidyverse)
library(magrittr)
setwd("/Users/hsuwei/Desktop/try/HLM")
l1 <- read_sav("newhwlevel1.sav")
l2 <- read_sav("newhwlevel2.sav")


mydata <- left_join(l1, l2, by = "schoolid") %>%
  mutate(studentid = pupilNR_new, score = langPOST, IQ = IQ_verb)

library(nlme)
library(sjPlot)
library(sjmisc)
library(lme4)

model1 <- lm(score ~ ses + IQ + sex, data = mydata)
summary(model1)

model2 <- lme(fixed = score ~ ses + IQ + sex, random = ~1|schoolid, data = mydata)
summary(model2)

model2.1 <- lmer(score ~ ses + IQ + sex + (1|schoolid), data = mydata)
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

