resource "google_compute_network" "vpc" {
	name = "globalvpc"
	auto_create_subnetworks = "true"
	routing_mode = "GLOBAL"
}

variable "vpc_config" {
	type = map(any)
	default = {
		vpc_name = "vpc"
		region = "us-central1"
		zone = "us-central1-c"
	}
}