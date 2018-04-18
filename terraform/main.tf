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

  // boot disk
  disk {
    source_image = "cos-cloud/cos-stable"
  }

  network_interface {
    network = "default"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  base_instance_name = "tf-server"
  zone               = "us-central1-a"
  target_size        = "2"
}
