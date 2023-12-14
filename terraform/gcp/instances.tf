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
    yor_trace            = "a6a1306b-b594-49f7-8d26-884fae914f04"
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
    yor_trace            = "fa057f0a-c45d-4d1d-8873-5b86a8824cf2"
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