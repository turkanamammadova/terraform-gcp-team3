resource "google_compute_target_pool" "default-target" {
	region = var.asg_config["region"]
	name = var.asg_config["target-pool-name"]
}


resource "google_compute_autoscaler" "asg" {
	zone = var.asg_config["zone"]
	name = var.asg_config["autoscaler"]
	target = google_compute_instance_group_manager.gmanager.id
	autoscaling_policy {
		max_replicas = var.asg_config["max_replicas"]
		min_replicas = var.asg_config["min_replicas"]
		cooldown_period = var.asg_config["cooldown_period"]
	cpu_utilization {
		target = var.asg_config["target"]
		}
	}
}


resource "google_compute_instance_group_manager" "gmanager" {
	zone = var.asg_config["zone"]
	name = var.asg_config["instance_group_manager_name"]
	version {
		instance_template = google_compute_instance_template.team3-template.id
		name = "primary"
	}
	target_pools = [google_compute_target_pool.default-target.self_link]
		base_instance_name = "team3-base-instance"
	}


resource "google_compute_instance_template" "team3-template" {
	name = var.asg_config["instance_template_name"]
	machine_type = var.asg_config["machine_type"]
	can_ip_forward = false
    metadata_startup_script = file("startup.sh")
    metadata = {
		ssh-keys = "centos7:${file("~/.ssh/id_rsa.pub")}"
    }
	disk {
		source_image = var.asg_config["source_image"]
	}
	network_interface {
		network = google_compute_network.globalvpc.self_link
		access_config {
		}
	}
}

resource "google_compute_firewall" "allow-http" {
	name = var.asg_config["firewall_name"]
	network = google_compute_network.globalvpc.self_link
   
    allow {
        protocol = "icmp"
    }

	allow {
		protocol = "tcp"
		ports = ["80","22"]
	}
	source_tags = [var.asg_config["network_tags"]]
    source_ranges = [ "0.0.0.0/0" ]
}