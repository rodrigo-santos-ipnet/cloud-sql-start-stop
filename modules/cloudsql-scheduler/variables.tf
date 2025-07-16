variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "Region for Cloud Scheduler"
}

variable "scheduler_sa_name" {
  type        = string
  description = "Service Account name used by Cloud Scheduler"
  default     = "cloud-scheduler-sql"
}

variable "instances" {
  type = map(object({
    start_frequency = optional(string, "0 8 * * MON-FRI")
    stop_frequency  = optional(string, "0 20 * * MON-FRI")
  }))
  description = "Map of instance names with optional start/stop cron frequencies"
}
