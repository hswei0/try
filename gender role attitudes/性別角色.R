setwd('/Users/hsuwei/Desktop/0603Q2')
library(haven)
t2012 <- read_dta('tscs2012q2.dta',encoding = 'BIG5')
a <- list(t2012[,c(e1a:e1e)])

#變項的描述統計
library(Hmisc) ; library(dplyr) ; library(gdata)
des <- list()
for (i in 1:5){
  var <- paste0('e',i,'[a-z]$')
  t2012 %>%
  select(matches(var)) %>% 
  na_if(94) %>%
  na_if(97) %>%
  na_if(98) %>%
    describe() %>%
   c (a,.) ->des
}
  
describe(t2012$a1)

t2012 %>%
  rename(gender = a1) %>%
  mutate(gender = factor(gender)) %>%
  mutate(age = 2012-1911-a2y) ->t2012
  
library(dplyr)
describe(t2012$b1)
t2012 %<>%
  mutate(educ = 0)
t2012$educ <- as.numeric(t2012$b1)

library(car)
t2012$educ <-recode(t2012$educ,'1:5 = 1 ; 6:9 = 2 ; 10:19 = 3 ;
20:21 =4 ; 22 = NA ') 

t2012$educ <- factor(t2012$educ,
       levels=c(1:4),
       label=c('國中以下','高中職','大專','研究所')
       ) 
describe(t2012$educ)

install.packages('psych')
