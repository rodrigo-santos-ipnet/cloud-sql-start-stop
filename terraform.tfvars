project_id = "playground-s-11-4d17c65a"
region     = "us-central1"

instances = {
  "test-instance-1" = {
    start_frequency = "0 8 * * MON-FRI"
    stop_frequency  = "0 20 * * MON-FRI"
  }

  "test-instance-2" = {
    start_frequency = "0 7 * * MON-FRI"
    stop_frequency  = "0 19 * * MON-FRI"
  }

  "test-instance-3" = {} # usa os valores padrão
}
