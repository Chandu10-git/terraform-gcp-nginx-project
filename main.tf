provider "google" {
  project      = "project-34e4a3f5-bf8e-4879-94c"
  region       = "us-central1"
}

resource "google_compute_instance" "terraform_vm" {
  name         = "chandutf-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["terraform", "demo"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update
    apt install nginx -y
    systemctl start nginx
    systemctl enable nginx
  EOF

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["terraform"]
}

output "vm_ip" {
  value = google_compute_instance.terraform_vm.network_interface[0].access_config[0].nat_ip
}