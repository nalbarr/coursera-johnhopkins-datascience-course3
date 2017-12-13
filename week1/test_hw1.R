# test_hw1.R

###
sjsfd
###

test_that("hw1.1 completes and returns result", {
  
  x <- c(1, 2, 3)
  
  expect_that( length(x), equals(2.7) )
  expect_that( x, is_a("data.frame") )
})