data google_compute_zones "zones" {}

resource google_compute_instance "server" {
  machine_type = "n1-standard-1"
  name         = "terragoat-${var.environment}-machine"
  zone         = data.google_compute_zones.zones.names[0]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    auto_delete = true
  }
  network_interface {
    subnetwork = google_compute_subnetwork.public-subnetwork.name
    access_config {}
  }
  can_ip_forward = true

  metadata = {
    block-project-ssh-keys = false
    enable-oslogin         = false
    serial-port-enable     = true
  }
  labels = {
    yor_trace            = "c8fdf2cf-a6fe-4544-abcb-323f163c2705"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform__gcp__instances_tf"
    git_last_modified_at = "2021-05-02-10-06-10"
    git_last_modified_by = "nimrodkor"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "server"
  }
}

resource google_compute_disk "unencrypted_disk" {
  name = "terragoat-${var.environment}-disk"
  labels = {
    yor_trace            = "d63e7ab3-633d-4588-9ce9-c21d282e54aa"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform__gcp__instances_tf"
    git_last_modified_at = "2021-05-02-10-06-10"
    git_last_modified_by = "nimrodkor"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "unencrypted_disk"
  }
}