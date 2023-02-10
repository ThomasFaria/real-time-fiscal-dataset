library(targets)

tar_option_set(
  packages = c("tarchetypes", "styler", "visNetwork"),
  format = "parquet",
  memory = "transient",
  garbage_collection = TRUE
)

tar_source(files = "R")
options(timeout = 5 * 60)

list(
  tar_target(
    name = data_info_file,
    command = "data.yaml",
    format = "file"
  ),
  tar_target(
    name = env,
    command = "environment.yaml",
    format = "file"
  ),
  tar_target(
    name = data_info,
    command = yaml::read_yaml(data_info_file),
    format = "rds"
  ),
  tar_target(
    name = environment,
    command = yaml::read_yaml(env),
    format = "rds"
  ),
  tarchetypes::tar_download(
    name = file,
    urls = c("https://minio.lab.sspcloud.fr/tfaria/public/real-time-fiscal-database.csv"),
    paths = "real-time-fiscal-database.csv"
  ),
  tar_target(
    name = RTDB,
    command = get_RTDB(file),
  ),
  tar_target(
    name = data_gfs,
    command = get_ECB_data("GFS", data_info, env),
  ),
  tar_target(
    name = data_mna,
    command = get_ECB_data("MNA", data_info, env),
  ),
  tar_target(
    name = update_db,
    command = append_dataset(list(RTDB, data_gfs, data_mna))
  )
)
