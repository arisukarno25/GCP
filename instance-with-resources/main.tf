// terraform {} is to define provider, version etc
terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
        }
    }
}

// create vpc network 
provider "google" {
    version = "3.5.0"
    project = "qwiklabs-gcp-04-e13de4b19595"
    region = "us-central1"
    zone = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
    name = "terraform-network"
}

// create instance 
resource "google_compute_instance" "vm_instance" {
    name = "terraform-instance"
    machine_type = "f1-micro"
    tags = ["web", "dev"]
    // add provisioner, it will be execute when creating
    provisioner "local-exec" {
        command = "echo ${google_compute_instance.vm_instance.name}: ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip}
    }
    boot_disk {
        initialize_params {
            // destructive (provider replace the existing resource)
            // image = "debian-cloud/debian-9"
            image = "cos-cloud/cos-stable"
        }
    }

network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
        nat_ip = google_compute_address.vm_static_ip.address
        }
    }
}

// add static ip address | ip static have to created before vm created. Running with: terraform apply "static_ip"
resource "google_compute_address" "vm_static_ip" {
    name = "terraform-static-ip"
}

/* 
Saving the plan, it can be used in the future: terraform plan -out static_ip
Run: terraform apply "static_ip" -> create ip first
google_compute_address.vm_static_ip.address creates an implicit dependency on the google_compute_address named vm_static_ip
*/

// create storage bucket 
resource "google_storage_bucket" "example_bucket" {
    name = "qwiklabs-gcp-04-e13de4b19595-bucket"
    location = "US"
    website {
        main_page_suffix = "index.html"
        not_found_page = "404.html"
    }
}

// create new instance that use the bucket 
resource "google_compute_instance" "example_instance" {
    # Tells Terraform that this VM instance must be created only after the storage bucket has been created.
    depends_on = [google_storage_bucket.example_bucket]
    name = "terraform-instance-2"
    machine_type = "f1-micro"
    boot_disk {
        initialize_params {
            image = "cos-cloud/cos-stable"
        }
    }
    network_interface {
        network = google_compute_network.vpc_network.self_link
        access_config {
            
        }
    }
}

// run: "terraform taint google_compute_instance.vm_instance" to tell Terraform to recreate the instance