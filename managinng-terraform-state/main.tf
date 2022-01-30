provider "google" {
    project = "qwiklabs-gcp-00-702a2f383bcd"
    region = "us-central-1"
}
// create resource
resource "google_storage_bucket" "test-bucket-for-state" {
    name = "qwiklabs-gcp-00-702a2f383bcd"
    location = "US"
    uniform_bucket_level_access = true
    force_destroy = true
}

// add local backend, it's stores state on the local filesystem, locks that state using system APIs, and performs operations locally.
// local backend triggered when "terraform init" and result after "terraform apply"
terraform {
    // local backend 
    /*
    backend "local" {
        path = "terraform/state/terraform.tfstate"
    }
    */
    // cloud backend 
    // run with: // terraform init -migrate-state
    backend "gcs" {
        bucket = "qwiklabs-gcp-00-702a2f383bcd"
        prefix = "terraform/state"
    }
}




var axios = require('axios');


axios({
    method: 'get',
    url: 'http://web-keraton.arisukarno.xyz:8055/items/post?fields=image_post'
    // responseType: 'stream'
  })
    .then(function (response) {
      response.data.data.map((item) => {
          let imageLink =  `http://web-keraton.arisukarno.xyz:8055/assets/${item.image_post}`
          console.log(imageLink);
      })
});