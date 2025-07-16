variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "scheduler_sa_name" {
  type    = string
  default = "cloud-scheduler-sql"
}

variable "instances" {
  type = map(object({
    start_frequency = optional(string, "0 8 * * MON-FRI")
    stop_frequency  = optional(string, "0 20 * * MON-FRI")
  }))
}
