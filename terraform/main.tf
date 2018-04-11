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
resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "instance_template-"
  machine_type = "n1-standard-1"
  region       = "us-central1"

  // boot disk
  disk {
    source_image = "cos-stable"
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
  target_size        = "1"
}
