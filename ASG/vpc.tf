resource "google_compute_network" "globalvpc" {
	name = "team3-vpc"
	auto_create_subnetworks = "true"
	routing_mode = "GLOBAL"
}