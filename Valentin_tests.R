complete <- read.csv("~/Cours/TD AudeAxel/complete.csv")
scrubbed <- read.csv("~/Cours/TD AudeAxel/scrubbed.csv")

summary(complete)
class(complete)
complete$comments[5]

Test=na.omit(complete)
library(FactoMineR)

?MFA

Test2=Test[,c("shape", "duration..seconds.", "latitude")]
Test2$duration..seconds.=as.numeric(Test2$duration..seconds.)

MFA(Test2, c(1,1,1), type=c("n", "c", "c"))
class(Test2$duration..seconds.)

# plotluck

library(plotluck)

unique(complete$datetime)
A="10/1/1983 21:00"
B=as.Date(A, format="%m/%d/%Y %H:%M")
Test=complete[1:50,]
as.POSIXct(complete$datetime, format="%m/%d/%Y %H:%M")

complete[55290:55300,]
