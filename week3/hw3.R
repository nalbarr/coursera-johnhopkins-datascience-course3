# hw3.R

setInternet2(TRUE)

install.packages("httr")
install.packages("data.table")
install.packages("jpeg")

library(httr)
library(data.table)
library(jpeg)

setwd("C:/workspace-data-cleaning/hw3")

# hw3.1
### NAA. 
### - use download file instead of read.csv directly
### - 

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#csv <- read.csv(url("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"))
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "hw3.csv")
csv <- read.csv("hw3.csv")
dt <- data.table(csv)

### does not work
# Create a logical vector that identifies the:
# - households on greater than 10 acres 
# - who sold more than $10,000 worth of agriculture products.
#df2 <- select(df1, RT, TYPE, ACR, AGS)
#agricultureLogical <- filter(df2, RT=="H", TYPE==1, ACR==3, AGS==6)
#which(agricultureLogical)
#close(csv)

### works
agricultureLogical <- dt$ACR == 3 & dt$AGS == 6
which(agricultureLogical)[1:3]
#[1] 125 238 262
    
# hw3.2
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "jeff.jpg", mode = "wb")
img <- readJPEG("jeff.jpg", native=TRUE)
quantile(img, probs = c(0.3, 0.8))
#30%       80% 
#  -15259150 -10575416

# hw3.3

# does not work
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "fedstats_country.csv")
gdp < read.csv("gdp.csv")
fedstats <- read.csv("fedstats.country.csv")

# works
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f)
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
sum(!is.na(unique(dt$rankingGDP)))
# [1] 189

dt[order(rankingGDP, decreasing = TRUE), list(CountryCode, Long.Name.x, Long.Name.y, 
                                              rankingGDP, gdp)][13]
#CountryCode         Long.Name.x         Long.Name.y rankingGDP   gdp
#1:         KNA St. Kitts and Nevis St. Kitts and Nevis        178  767 

# hw3.4
dt[, mean(rankingGDP, na.rm = TRUE), by = Income.Group]
# Income.Group        V1
# 1: High income: nonOECD  91.91304
# 2:           Low income 133.72973
# 3:  Lower middle income 107.70370
# 4:  Upper middle income  92.13333
# 5:    High income: OECD  32.96667
# 6:                   NA 131.00000
# 7:                            NaN

# hw3.5
breaks <- quantile(dt$rankingGDP, probs = seq(0, 1, 0.2), na.rm = TRUE)
dt$quantileGDP <- cut(dt$rankingGDP, breaks = breaks)
dt[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]
