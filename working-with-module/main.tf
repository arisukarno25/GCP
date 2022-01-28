// when error (e.g. An argument named "uniform_bucket_level_access" is not expected here.) update : terraform init -upgrade
module "gcs-static-website-bucket" {
    source = "./modules/gcs-static-website-bucket" 
    name = var.name 
    project_id = var.project_id
    location = "us-east1"
    lifecycle_rule = [{
        action = {
            type = "Delete"
        }
        condition = {
            age = 365
            with_state = "ANY"
        }
    }]
}