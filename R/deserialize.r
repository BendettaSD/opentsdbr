deserialize_tags <- function(tag_strings, tags) { 
    require(stringr)
    tag_keys <- names(tags)
    pattern_for <- function(key) str_c(key, "=([^ ]+)", collapse="")
    tag_matrix <- sapply(tag_keys, function(key) str_match(tag_strings, pattern_for(key))[,-1])
    as.data.frame(tag_matrix)
}

deserialize_metrics <- function(records) {
    require(lubridate)
    with_utc <- data.frame(
        metric = records[,1],
        timestamp = Timestamp(as.numeric(records[,2])),
        value = as.numeric(records[,3])
    )
    transform(with_utc, timestamp=with_tz(timestamp, Sys.timezone()))
}

deserialize_records <- function(records, tags) {
    require(stringr)
    metric_data <- deserialize_metrics(records[,1:3])
    if (missing(tags)) {
        return(metric_data)
    } else {
        tag_strings <- apply(records[,-(1:3)], 1, str_c, collapse=" ")
        tag_data <- deserialize_tags(tag_strings, tags)
        message(tag_strings)
        return(cbind(metric_data, tag_data))
    }
}

deserialize_content <- function(content, tags) {
    require(stringr)
    # cleaned <- str_trim(content)
    # lines <- readLines(textConnection(cleaned))
    # records <- str_split_fixed(lines, " ", n=4)
    records <- read.table(textConnection(content))
    deserialize_records(records, tags=tags)
}