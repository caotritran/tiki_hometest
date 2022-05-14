resource "google_compute_instance" "vm-1" {
  name         = "sg-echoserver-1"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"
  allow_stopping_for_update = true

  tags = ["staging"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #  interface = "NVME"
  #}

  network_interface {
    #network = "default"
    #network = google_compute_network.vpc_sg.name
    subnetwork = google_compute_subnetwork.sub-public.name

    access_config {
      // Ephemeral public IP
    }
  }
  depends_on = [
    google_compute_firewall.allow-ssh,
    google_compute_firewall.allow-web
  ]

  # Defining what service account should be used for creating the VM
  service_account {
  #  email  = var.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.pubkey)}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = file(var.private_key)
      host        = self.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    command = <<EOF
echo "${google_compute_instance.vm-1.name} ansible_host=${self.network_interface.0.access_config.0.nat_ip}" > ansible/hosts \
&& ansible-playbook -i ansible/hosts --private-key ${var.private_key} ansible/main.yml
EOF
  }

  #metadata_startup_script = <<SCRIPT
  #  sudo yum -y update
  #SCRIPT

}