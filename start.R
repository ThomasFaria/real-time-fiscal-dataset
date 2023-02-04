install.packages("rdbnomics")


df <- ?rdbnomics::rdb("AMECO", "ZUTN", dimensions = list(geo = c("ea19", "dnk")))

w<-rdbnomics::rdb(ids = "ECB/GFS/Q.N.FR.W0.S13.S1.P.C.OTR._Z._Z._Z.XDC._Z.S.V.N._T")

df <- df[!is.na(value))]

code_1 <- "Q.N.cc.W0.S13.S1.P.C.OTR._Z._Z._Z.XDC._Z.S.V.N._T"
code_2 <- "Q.N.cc.W0.S13.S1.N.C.D5._Z._Z._Z.XDC._Z.S.V.N._T"

dims_ <- strsplit(c(code_1, code_2), ".", fixed = TRUE)
dims <- strsplit(code_1, ".", fixed = TRUE)[[1]]
dims1 <- dims_[[2]]

concepts <- c("FREQ", "ADJUSTMENT", "REF_AREA", "COUNTERPART_AREA", "REF_SECTOR", "COUNTERPART_SECTOR", "CONSOLIDATION",
              "ACCOUNTING_ENTRY", "STO", "INSTR_ASSET", "MATURITY", "EXPENDITURE", "UNIT_MEASURE", "CURRENCY_DENOM",
              "VALUATION", "PRICES", "TRANSFORMATION", "CUST_BREAKDOWN")

dimensions <- setNames(as.list(dims), concepts)
dimensions$REF_AREA <- c("FR")

dimensions1 <- setNames(as.list(dims1), concepts)
dimensions1$REF_AREA <- c("FR")

test <- Map(c, dimensions, dimensions1)


dimensions$REF_AREA <- c("FR")

w<-rdbnomics::rdb(provider_code = "ECB",
                  dataset_code = "GFS",
                  dimensions = test)[
                    , .(dataset_code, indexed_at, period, STO, 
                        `Stocks, Transactions, Other Flows`,
                        `Reference area`, REF_AREA, value)
                  ]


ww<-rdbnomics::rdb(provider_code = "ECB",
                  dataset_code = "GFS",
                  mask = c("Q.N.W0.S13.S1.P.C.OTR._Z._Z._Z.XDC._Z.S.V.N._T")
)[
  , .(dataset_code, indexed_at, period, STO, 
      `Stocks, Transactions, Other Flows`,
      `Reference area`, REF_AREA, value)
]


data.table::setnames(w, c("dataset_code", "indexed_at", "period", "REF_AREA", "Reference area", "value"), 
                        c("Database", "Snapshot_date", "Date", "Country_code", "Country_long", "Value"),
                     skip_absent = TRUE
)

               

"https://minio.lab.sspcloud.fr/tfaria/public/RealTimeDatabase.csv"

get_RTDB <- function(file) {
  data <- data.table::data.table(arrow::read_csv_arrow(file))
  return(data)
}

a <- get_RTDB("https://minio.lab.sspcloud.fr/tfaria/public/RealTimeDatabase.csv")

data_infos <- yaml::read_yaml("data.yaml")
environment <- yaml::read_yaml("environment.yaml")

sublist <- Filter(function(x) x$Database == "GFS", yaml::read_yaml("data.yaml"))

lapply(sublist, function(x) {
  
  return(ww)
})


dattta <- lapply(sublist, function(x) {
  splitted_code <- strsplit(x$Code, ".", fixed = TRUE)[[1]]

})
dimensions <- setNames(as.list(splitted_code), environment$Data_structure$GFS)

test <- Map(c, dattta)
a<- unlist(dattta, recursive = FALSE)
do.call(c, dattta)
