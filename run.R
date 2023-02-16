Sys.setenv(TAR_PROJECT = "GFS")
targets::tar_make()

Sys.setenv(TAR_PROJECT = "MNA")
targets::tar_make()


arrow::write_csv_arrow(real_time_fiscal_database |>
                         dplyr::rename(Name = "Stocks, Transactions, Other Flows"),
                       "realtime_fiscal_database.csv")
