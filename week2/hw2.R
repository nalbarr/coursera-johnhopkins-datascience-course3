# hw2.R

# hw2.1
library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github",
  key = "025e4db517dd7fe31c0f",
  secret = "c67d2b4c1621213690233d4af6fc9b551a47b6c9")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)
# 2013-11-07T13:25:07Z

# hw2.2
acs <- read.csv(url("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"))

install.packages("sqldf")
library(sqldf)

sqldf("select pwgtp1 from acs where AGEP <50")
# sqldf("select pwgtp1 from acs where AGEP < 50")

# hw2.3
sqldf("select distinct AGEP from acs")

# hw2.4
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
html2 <- readLines(con)
nchars <- ""
for (i in c(10, 20, 30, 100)) {
  nchars <- paste(nchars, nchar(html2[i]))
}
print(nchars)
#[1] " 45 31 7 25"
close(con)

# hw2.5
# http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for

con <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
for2 <- readLines(con)
length(for2)
col4sum <- 0
for (i in 5:length(for2)) {
  x <-as.numeric(substr(for2[i], 29, 32))
  #print(x)
  col4sum <- col4sum + x
}
print(col4sum)
# [1] 32426.7

