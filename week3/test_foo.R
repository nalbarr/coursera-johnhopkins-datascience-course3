# test_foo.R

library(testthat)

source("./foo.R")

test_that("foo returns a string", {
  s <- foo("stuff")
  expect_that(s, is_a("character") )
})

test_that("foo returns a string as 'stuff'", {
  s <- foo("stuff")
  expect_that(s, equals("stuff") )
})