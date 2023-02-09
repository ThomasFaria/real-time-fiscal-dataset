install.packages("rdbnomics")

concepts <- c("FREQ", "ADJUSTMENT", "REF_AREA", "COUNTERPART_AREA", "REF_SECTOR", "COUNTERPART_SECTOR", "CONSOLIDATION",
              "ACCOUNTING_ENTRY", "STO", "INSTR_ASSET", "MATURITY", "EXPENDITURE", "UNIT_MEASURE", "CURRENCY_DENOM",
              "VALUATION", "PRICES", "TRANSFORMATION", "CUST_BREAKDOWN")

data_infos <- yaml::read_yaml("data.yaml")
environment <- yaml::read_yaml("environment.yaml")

sublist <- Filter(function(x) x$Database == "GFS", yaml::read_yaml("data.yaml"))

splitted_codes <- lapply(sublist, function(x) {
  splitted_code <- strsplit(x$Code, ".", fixed = TRUE)[[1]]
})

codes <- as.vector(sapply(sublist, function(x) {splitted_code <- x$Code}))


splitted_codes<-as.matrix(do.call(cbind, splitted_codes))

dimensions <- split(as.vector(splitted_codes), row(splitted_codes))
names(dimensions) <- concepts
dimensions$REF_AREA <- environment$Countries

w<-rdbnomics::rdb(provider_code = "ECB",
                  dataset_code = "GFS",
                  dimensions = dimensions)[
                    , .(dataset_code, series_code, indexed_at, period, STO, 
                        `Stocks, Transactions, Other Flows`,
                        `Reference area`, REF_AREA, value)
                  ][grepl(paste0(codes, collapse = "|"), series_code)]


data.table::setnames(w, c("dataset_code", "series_code", "indexed_at", "period", "REF_AREA", "Reference area", "value"), 
                        c("Database", "Series_code", "Snapshot_date", "Date", "Country_code", "Country_long", "Value"),
                     skip_absent = TRUE
)

               

"https://minio.lab.sspcloud.fr/tfaria/public/RealTimeDatabase.csv"

get_RTDB <- function(file) {
  data <- data.table::data.table(arrow::read_csv_arrow(file))
  return(data)
}

a <- get_RTDB("https://minio.lab.sspcloud.fr/tfaria/public/RealTimeDatabase.csv")


  
