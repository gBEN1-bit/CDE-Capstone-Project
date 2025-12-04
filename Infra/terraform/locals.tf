locals {
  general = {
    Environment = "Production"
    Team        = "Data_Engineering"
    managed_by  = "Terraform"
    project     = "coretelecoms-cx"
  }

  airflow_service = {
    Name = "Airflow"
  }
}



