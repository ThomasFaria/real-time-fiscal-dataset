get_ECB_vintage <- function() {
  current_date <- Sys.Date()
  month <- lubridate::month(current_date)
  year <- as.character(lubridate::year(current_date))
  if (month %in% c(1,2)) {
    vintage <- paste0("W", substr(year, 3, 4))
  } else if (month %in% c(4,5)) {
    vintage <- paste0("G", substr(year, 3, 4))
  } else if (month %in% c(7,8)) {
    vintage <- paste0("S", substr(year, 3, 4))
  } else if (month %in% c(10,11)) {
    vintage <- paste0("A", substr(year, 3, 4))
  }
  return(vintage)
}

get_dimensions <- function(dataset, data_infos, env) {
  sublist <- Filter(function(x) x$Database == dataset, data_infos)

  splitted_codes <- lapply(sublist, function(x) {
    splitted_code <- strsplit(x$Series_code, ".", fixed = TRUE)[[1]]
  })
  splitted_codes <- as.matrix(do.call(cbind, splitted_codes))

  dimensions <- split(as.vector(splitted_codes), row(splitted_codes))
  names(dimensions) <- env$Data_structure[[dataset]]

  if (dataset == "GFS") {
    dimensions$REF_AREA <- env$Countries
  } else if (dataset == "namq_10_gdp") {
    dimensions$geo <- env$Countries
  }

  codes <- as.vector(sapply(sublist, function(x) {
    splitted_code <- x$Series_code
  }))

  return(list("Dim" = dimensions, "Codes" = codes))
}

get_ECB_data <- function(dataset, data_infos, environement) {
  dimensions <- get_dimensions(dataset, data_infos, environement)

  data <- rdbnomics::rdb(
    provider_code = "ECB",
    dataset_code = dataset,
    dimensions = dimensions$Dim
  )[
    , .(
      dataset_code, series_code, indexed_at, period, STO,
      `Stocks, Transactions, Other Flows`,
      `Reference area`, REF_AREA, value
    )
  ][grepl(paste0(dimensions$Codes, collapse = "|"), series_code)]

  data.table::setnames(data, c("dataset_code", "series_code", "indexed_at", "period", "REF_AREA", "Reference area", "Stocks, Transactions, Other Flows", "value"),
    c("Database", "Series_code", "Snapshot_date", "Date", "Country_code", "Country_long", "Name", "Value"),
    skip_absent = TRUE
  )

  sublist <- Filter(function(x) x$Database == dataset, data_infos)

  join_dt <- data.table::data.table(do.call(rbind, lapply(sublist, data.frame, stringsAsFactors = FALSE)))

  data <- merge(data, join_dt[, .(STO, Variable_code, Variable_long)], by = "STO")

  vintage <- get_ECB_vintage()
  data[, ECB_vintage := vintage]
  return(data[, .(
    Database, Series_code, Snapshot_date, ECB_vintage, Country_code, Country_long,
    STO, Name, Variable_code, Variable_long, Date, Value
  )])
}

get_Eurostat_data <- function(dataset, data_infos, environement) {
  dimensions <- get_dimensions(dataset, data_infos, environement)

  data <- rdbnomics::rdb(
    provider_code = "Eurostat",
    dataset_code = dataset,
    dimensions = dimensions$Dim
  )[
    , .(
      dataset_code, series_code, indexed_at, period, na_item,
      `National accounts indicator (ESA 2010)`,
      `Geopolitical entity (reporting)`, geo, value
    )
  ][grepl(paste0(dimensions$Codes, collapse = "|"), series_code)]

  data.table::setnames(data,
    c("dataset_code", "series_code", "indexed_at", "period", "geo", "Geopolitical entity (reporting)", "National accounts indicator (ESA 2010)", "na_item", "value"),
    c("Database", "Series_code", "Snapshot_date", "Date", "Country_code", "Country_long", "Name", "STO", "Value"),
    skip_absent = TRUE
  )

  sublist <- Filter(function(x) x$Database == dataset, data_infos)

  join_dt <- data.table::data.table(do.call(rbind, lapply(sublist, data.frame, stringsAsFactors = FALSE)))

  data <- merge(data, join_dt[, .(STO, Variable_code, Variable_long)], by = "STO")

  vintage <- get_ECB_vintage()
  data[, ECB_vintage := vintage]
  return(data[, .(
    Database, Series_code, Snapshot_date, ECB_vintage, Country_code, Country_long,
    STO, Name, Variable_code, Variable_long, Date, Value
  )])
}

get_RTDB <- function(file) {
  data <- data.table::data.table(arrow::read_parquet(file))
  return(data)
}

append_dataset <- function(list_data) {
  new_db <- data.table::rbindlist(list_data, use.names = TRUE)
  return(new_db)
}

get_last_available_quarter <- function() {
  vintage <- get_ECB_vintage()
  letter <- substr(vintage, 1, 1)
  year <- as.double(substr(vintage, 2, 3))

  if (letter == "W") {
    date <- as.Date(paste0("20", year - 1, "-", "07-01"))
  } else if (letter == "G") {
    date <- as.Date(paste0("20", year - 1, "-", "10-01"))
  } else if (letter == "S") {
    date <- as.Date(paste0("20", year, "-", "01-01"))
  } else if (letter == "A") {
    date <- as.Date(paste0("20", year, "-", "04-01"))
  }
  return(date)
}

check_completeness <- function(dataset, data_retrieved, data_infos) {
  sublist <- Filter(function(x) x$Database == dataset, data_infos)
  last_date <- get_last_available_quarter()
  missing_summary <- data_retrieved[Date == last_date, .(N = sum(!is.na(Value))), by = Country_code][(N != length(sublist))]

  if (nrow(missing_summary) != 0) {
    print(missing_summary)
    stop(
      "Data for ", last_date, " is not available for these countries : ",
      paste(missing_summary[, Country_code], collapse = ", "), "."
    )
  }
  return(missing_summary)
}

remove_duplicated <- function(data) {
  idx_duplicated <- duplicated(data)
  if (any(idx_duplicated)) {
    data <- data[!idx_duplicated,]
    warning("Some rows have been removed due to duplication.")
  }
  return(data)
}

save_archives <- function() {
  last_date <- get_last_available_quarter()
  filepath <- paste0("QGFS/archives/", last_date, "/real-time-fiscal-database.parquet")

  aws.s3::put_object(
    file = "real-time-fiscal-database.parquet",
    bucket = "tfaria", object = filepath,
    region = ""
  )
  return(filepath)
}

save_updated_database <- function(data) {
  arrow::write_csv_arrow(data, "real-time-fiscal-database-updated.csv")
  arrow::write_parquet(data, "real-time-fiscal-database-updated.parquet")

  filepath <- paste0("public/real-time-fiscal-database")

  aws.s3::put_object(
    file = "real-time-fiscal-database-updated.csv",
    bucket = "tfaria", object = paste0(filepath, ".csv"),
    region = ""
  )

  aws.s3::put_object(
    file = "real-time-fiscal-database-updated.parquet",
    bucket = "tfaria", object = paste0(filepath, ".parquet"),
    region = ""
  )
  return(paste0(filepath, ".parquet"))
}
