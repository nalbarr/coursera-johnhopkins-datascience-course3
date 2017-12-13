library(combinat)

nums <- factor(c("One", "Two", "Three"))
factors <- factor(nums)
factors[1]
levels2 <- levels(nums)

col <- factor(c("Red", "Green"))
own <- factor(c("English", "Swedish"))

col_p <- permn(levels(col))
own_p <- permn(levels(col))