terraform {
 backend "gcs" {
   project = "comp698-cek1020"
   bucket  = "comp698-cek1020-terraform-state"
   prefix  = "terraform-state"
 }
}
provider "google" {
  region = "us-central1"
}
resource "google_compute_instance_template" "instance_template" {
  name = "instance_template"

  name_prefix  = "tf-server"
  machine_type = "n1-standard-1"
  region       = "us-central1"
  disk {
    source_image = "cos-stable"
  }
}
resource "google_compute_instance_group_manager" "group_manager" {
  name = "group_manager"

  base_instance_name = "tf-server"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  update_strategy    = "NONE"
  zone               = "us-central1-a"
}
