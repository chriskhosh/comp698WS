terraform {
 backend "gcs" {
   project = "comp698-cek1020"
   bucket  = "comp698-cek1020-terraform-state"
   prefix  = "terraform-state"
 }
}
provider "google" {
  region = "us-central1"
  project = "comp698-cek1020"
}
resource "google_storage_bucket" "image-store" {
  project  = "comp698-cek1020"
  name     = "bucket-two"
  location = "us-central1"
}
resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "instancetemplate-"
  machine_type = "f1-micro"
  region       = "us-central1"

  tags = ["http-server"]

  // boot disk
  disk {
    source_image = "cos-cloud/cos-stable"
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write"
    ]
  }

  metadata {
    gce-container-declaration = <<EOF
    spec:
    containers:
    - image: 'gcr.io/comp698-cek1020/github-chriskhosh-comp698ws:23ea50cb9a9ed740c64090317736cd11ba949fc9'
      name: service-container
      stdin: false
      tty: false
      restartPolicy: Always
    EOF
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  base_instance_name = "tf-server"
  zone               = "us-central1-a"
  target_size        = "2"
}
