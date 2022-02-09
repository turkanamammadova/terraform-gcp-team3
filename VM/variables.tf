variable "vm_config" {
	type = map
	default = {
		region = "us-east1"
		zone = "us-east1-c"
		instance_name = "team3-instance"
		machine_type = "n1-standard-1"
		image = "centos-cloud/centos-7"
		firewall_name = "fw-allow-http"
		network_tags = "web"
	}
}

variable "labels" {
	type = map(any)
	default = {
		env = "stage"
		team = "team3"
        name = "team3vm"
        owner = "mammmadova"
	}
}