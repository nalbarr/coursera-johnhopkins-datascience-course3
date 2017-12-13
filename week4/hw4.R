# hw4

library(httr)

# hw4.1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- "ss06hid.csv"
download.file(url, f, method="curl")
csv <- read.csv(f)
names <-names(csv)

# imperative
# i.e., loop but need loop counter
splits <- list(1:length(names))
for (i in 1:length(names)) {
  splits[i] = strsplit(names[i], "wgtp")
}
splits[123]
# [1] ""   "15"

# dsl
# i.e., library api handles high kinded types
splits <- strsplit(names, "wgtp")
splits[123]
# [1] ""   "15"

# functional, 
# i.e., pass lambda
splits <- lapply(names, function(x) strsplit(x,"wgtp"))
splits[123]
# [1] ""   "15"

# hw4.2
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- "gdp.csv"
download.file(url, f, method="curl")
csv <- read.csv(f)

# imperative
# # does not work
# gdps <- list(length(csv$X.3))
# n <- 0
# total <- 0
# for (i in 1:length(csv$X.3)) {
#   s <- csv$X.3[i]
#   print(s)
#   if (!is.na(s)) {
#     sub <- sub(",", "", s)
#     gdp <- as.numeric(sub)
#     n <- n + 1
#     total <- total + 1
#   }
# }
# n
# total
# avg <- total / n
# avg

# works
gdps <- csv$X.3[grepl(",", csv$X.3)]
gdps2 <- as.numeric(gsub(",", "", gdps))
mean(gdps2)
#[1] 1577387 - wrong !!!

# https://github.com/benjamin-chan/GettingAndCleaningData/blob/master/Quiz4/quiz4.md
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215, stringsAsFactors = FALSE))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))
gdp <- as.numeric(gsub(",", "", dtGDP$gdp))
mean(gdp, na.rm = TRUE)
## [1] 377652

# hw4.3
grep("^United", csv$X.2)
# [1]  5 10 36

# hw4.4
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f1 <- "gdp.csv"
download.file(url1, f, method="curl")
csv <- read.csv(f1)

#https://github.com/benjamin-chan/GettingAndCleaningData/blob/master/Quiz4/quiz4.md
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f2 <- "edstats.csv"
download.file(url, f2, method="curl")
csv2 <- read.csv(f)

##                isJune
## isFiscalYearEnd FALSE TRUE
##           FALSE   203    3
##           TRUE     19   13

#
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
isFiscalYearEnd <- grepl("fiscal year end", tolower(dt$Special.Notes))
isJune <- grepl("june", tolower(dt$Special.Notes))
table(isFiscalYearEnd, isJune)
# 13

# hw4.5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))

##       
##        Friday Monday Thursday Tuesday Wednesday  Sum
##   2007     51     48       51      50        51  251
##   2008     50     48       50      52        53  253
##   2009     49     48       51      52        52  252
##   2010     50     47       51      52        52  252
##   2011     51     46       51      52        52  252
##   2012     51     47       51      50        51  250
##   2013     51     48       50      52        51  252
##   2014     15     14       16      16        16   77
##   Sum     368    346      371     376       378 1839

# 250, 47

