context('timestamps')

local_tz <- "America/Los_Angeles"
Sys.setenv(TZ=local_tz)

from_epoch <- as.POSIXct(1359762161, tz="UTC", origin="1970-01-01")
from_isodate <- ISOdate(2013, 02, 01, 15, 42, 41, tz=local_tz)
from_strptime <- as.POSIXct(strptime("2013-02-01 15:42:41", format_naive, tz=local_tz))

z <- 1359762161

test_that("create Timestamp from numeric", {
    t1 <- Timestamp(z)
    expect_equal(as.numeric(t1), z)
    expect_equal(attr(t1, "tzone"), "UTC")
})

test_that("convert Timestamp to numeric", {
    t1 <- Timestamp(z)
    expect_equivalent(as.numeric(t1), as.numeric(from_epoch))
    expect_equivalent(as.numeric(t1), as.numeric(from_isodate))
    expect_equivalent(as.numeric(t1), as.numeric(from_strptime))
})

test_that("format Timestamp created from numeric", {
    t1 <- Timestamp(z)
    expect_equal(format(t1), "2013-02-01 15:42:41 PST")
    expect_equal(format(t1, tz="UTC"), "2013-02-01 23:42:41 UTC")
    expect_equal(format_iso8601(t1), "2013-02-01T15:42:41-0800")
    expect_equal(format_iso8601(t1, tz="UTC"), "2013-02-01T23:42:41+0000")
    expect_equal(format_tsdb(t1), "2013/02/01-15:42:41")
})

test_that("format Timestamp created from ISOdate() result", {
    t1 <- Timestamp(z)
    t2 <- Timestamp(from_isodate)
    expect_equal(attr(t2, "tzone"), local_tz)
    expect_equal(format(t2), format(t1))
    expect_equal(format(t2, tz="UTC"), format(t1, tz="UTC"))
    expect_equal(format_iso8601(t2), format_iso8601(t1))
})

test_that("format Timestamp created from strptime() result", {
    t2 <- Timestamp(from_isodate)
    t3 <- Timestamp(from_strptime)
    expect_equal(attr(t3, "tzone"), local_tz)
    expect_equal(format(t3), format(t2))
    expect_equal(format(t3, tz="UTC"), format(t2, tz="UTC"))
    expect_equal(format_iso8601(t3), format_iso8601(t2))
})

test_that("format Timestamp created from character", {
    expect_warning(t4 <- Timestamp("2013/02/01-15:42:41"), "No timezone given")
    expect_warning(t4 <- Timestamp("2013/02/01-15:42:41"), local_tz)
    expect_equal(attr(t4, "tzone"), local_tz)
})
