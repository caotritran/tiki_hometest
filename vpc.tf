resource "google_compute_network" "vpc_sg" {
  project                 = var.project
  name                    = "vpc-sg"
  auto_create_subnetworks = false
}

resource "google_compute_router" "vpc_router" {
  name = "r1-router"

  project = var.project
  region  = var.region
  network = google_compute_network.vpc_sg.self_link
}

##public subnet
resource "google_compute_subnetwork" "sub-public" {
  name                     = "sub-public"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.vpc_sg.self_link
  private_ip_google_access = true
  ip_cidr_range            = "172.16.1.0/24"
}

##private subnet
resource "google_compute_subnetwork" "priv-subnet" {
  name                     = "priv-subnet"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.vpc_sg.self_link
  private_ip_google_access = true
  ip_cidr_range            = "172.16.2.0/24"
}

resource "google_compute_router_nat" "vpc_nat" {
  name                               = "sub-priv-nat"
  project                            = var.project
  region                             = var.region
  router                             = google_compute_router.vpc_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.priv-subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}