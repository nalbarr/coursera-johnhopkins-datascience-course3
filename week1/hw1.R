# hw1.R

setInternet2(true)
install.packages("data.table")
install.packages("xlsx")
install.packages("XML")

library(data.table)
library(dplyr)
library(xlsx)
library(XML)

# hw1.1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv")
csv <- read.csv("acs.csv")
dt <- data.table(csv)
View(dt)
n <- count(filter(dt, VAL==24))
print(n)
# n
# (int)
# 1    53

dt[, .N, VAL==24]
# VAL    N
# 1: FALSE 4367
# 2:    NA 2076
# 3:  TRUE   53

# hw1.2
dt2 <- select(dt, FES)
# Each tidy data table contains information about only one type of observation. 

# hw1.3
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "dat.xlsx", mode="wb") 

rows <- 18:23
cols <- 7:15
dat <- read.xlsx("dat.xlsx", 1, colIndex=cols, rowIndex=rows)
sum(dat$Zip*dat$Ext, na.rm=T)
#[1] 36534720

# hw1.4

# does not work
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "restaurants.xml")

# works
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "restaurants.xml")
doc <- xmlInternalTreeParse("restaurants.xml")
rootNode <- xmlRoot(doc)
names(rootNode)
# names(rootNode[[1]])
names(rootNode[[1]][[1]])
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
table(zipcode == 21231)
# FALSE  TRUE 
# 1200   127 

# hw1.5

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv","ss06pid.csv")
DT <- fread("ss06pid.csv")

runf <- function(f, n) {
  for (i in 1:n) {
    f
  }
}

f <- mean(DT$pwgtp15,by=DT$SEX)
system.time(runf(f, 1000))

f <- tapply(DT$pwgtp15,DT$SEX,mean)
system.time(runf(f, 1000))

f <- DT[,mean(pwgtp15), by=SEX]
system.time(runf(f, 1000))

f <- tapply(DT$pwgtp15,DT$SEX,mean)
system.time(runf(f, 1000))

f <- mean(DT$pwgtp15,by=DT$SEX)
system.time(runf(f, 1000))

system.time(runf(f, 1000))

# incorrect submission #1
#mean(DT$pwgtp15,by=DT$SEX)

# correct submission #2
# review lecture #1 - discussed data.table package and optimized operations on
# pass functions that can be applied
#DT[,mean(pwgtp15), by=SEX]

# works
# i.e. https://github.com/benjamin-chan/GettingAndCleaningData/blob/master/Quiz1/quiz1.Rmd
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
f <- file.path(getwd(), "ss06pid.csv")
download.file(url, f)
DT <- fread(f)
check <- function (y, t) {
  message(sprintf("Elapsed time: %.10f", t[3]))
  print(y)
}
t <- system.time(y <- sapply(split(DT$pwgtp15,DT$SEX),mean))
check(y, t)
t <- system.time(y <- mean(DT$pwgtp15,by=DT$SEX))
check(y, t)
t <- system.time(y <- DT[,mean(pwgtp15),by=SEX])
check(y, t)
t <- system.time(y <- rowMeans(DT)[DT$SEX==1]) + system.time(rowMeans(DT)[DT$SEX==2])
check(y, t)
t <- system.time(y <- mean(DT[DT$SEX==1,]$pwgtp15)) + system.time(mean(DT[DT$SEX==2,]$pwgtp15))
check(y, t)
t <- system.time(y <- tapply(DT$pwgtp15,DT$SEX,mean))
check(y, t)
