module "cloudsql_scheduler" {
  source               = "./modules/cloudsql-scheduler"
  project_id           = var.project_id
  region               = var.region
  scheduler_sa_name    = var.scheduler_sa_name
  instances            = var.instances
}
