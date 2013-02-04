context("tsd_get")

content <- "
myservice.latency.avg 1288900000 42 reqtype=foo host=baz
myservice.latency.avg 1288900001 51 reqtype=bar host=bap
"

test_that("parse example content returned by TSD", {
    tags <- c("reqtype", "host")
    parsed <- deserialize_content(content, tags=tags)
    expect_true(is.data.frame(parsed))
    expect_equal(names(parsed)[1:3], c("metric", "timestamp", "value"))
    expect_equal(names(parsed)[4:ncol(parsed)], tags)
    expect_true(is(parsed$timestamp, "POSIXct"))
    expect_equal(attr(parsed$timestamp, "tzone"), Sys.timezone())
    expect_equal(as.numeric(parsed$timestamp), c(1288900000, 1288900001))
    expect_equal(parsed$value, c(42, 51))
    expect_equal(as.character(parsed$reqtype), c("foo", "bar"))
    expect_equal(as.character(parsed$host), c("baz", "bap"))
})