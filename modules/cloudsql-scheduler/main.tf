terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Service Account
resource "google_service_account" "scheduler_sa" {
  account_id   = var.scheduler_sa_name
  display_name = "Cloud Scheduler SQL Automation SA"
}

# Grant IAM Role to Service Account
resource "google_project_iam_member" "sql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.scheduler_sa.email}"
}

# Job definitions: start/stop for each instance
locals {
  jobs = flatten([
    for instance_name, config in var.instances : [
      {
        name      = "${instance_name}-start"
        instance  = instance_name
        frequency = config.start_frequency
        policy    = "ALWAYS"
      },
      {
        name      = "${instance_name}-stop"
        instance  = instance_name
        frequency = config.stop_frequency
        policy    = "NEVER"
      }
    ]
  ])
}

resource "google_cloud_scheduler_job" "sql_scheduler" {
  for_each = { for job in local.jobs : job.name => job }

  name     = "sql-${each.value.name}-job"
  region   = var.region
  schedule = each.value.frequency
  time_zone = "America/Sao_Paulo"

  http_target {
    http_method = "PATCH"
    uri         = "https://sqladmin.googleapis.com/sql/v1beta4/projects/${var.project_id}/instances/${each.value.instance}"

    oidc_token {
      service_account_email = google_service_account.scheduler_sa.email
    }

    headers = {
      Content-Type = "application/json"
    }

    body = base64encode(jsonencode({
      settings = {
        activationPolicy = each.value.policy
      }
    }))
  }
}

output "service_account_email" {
  value = google_service_account.scheduler_sa.email
}

output "scheduler_jobs" {
  value = [for job in google_cloud_scheduler_job.sql_scheduler : job.name]
} 
