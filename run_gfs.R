library(targets)

tar_option_set(
  packages = c("tarchetypes"),
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
    name = environment,
    command = "environment.yaml",
    format = "file"
  ),
  tar_target(
    name = data_info,
    command = yaml::read_yaml(data_info_file),
    format = "rds"
  ),
  tar_target(
    name = env,
    command = yaml::read_yaml(environment),
    format = "rds"
  ),
  tarchetypes::tar_download(
    name = file,
    urls = c("https://minio.lab.sspcloud.fr/tfaria/public/real-time-fiscal-database.parquet"),
    paths = "real-time-fiscal-database.parquet"
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
    name = missing_data,
    command = check_completeness("GFS", data_gfs, data_info),
  ),
  tar_target(
    name = updated_db,
    command = append_dataset(list(RTDB, data_gfs))
  ),
  tar_target(
    name = archive,
    command = save_archives(),
    format = "file"
  ),
  tar_target(
    name = data_s3,
    command = save_updated_database(updated_db),
    format = "file"
  )
)
