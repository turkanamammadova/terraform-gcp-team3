# resource "google_compute_instance" "vm_instance" {
# 	name = var.vm_config["instance_name"]
# 	machine_type = var.vm_config["machine_type"]
# 	boot_disk {
# 		initialize_params {
# 			image = var.vm_config["image"]
# 		}
# 	}
# 	network_interface {
# 		network = google_compute_network.globalvpc.self_link
# 		access_config {
# 		}
# 	}
# 	labels = var.labels
# 	tags = [var.vm_config["network_tags"]]
#     metadata_startup_script = file("startup.sh")
# 	metadata = {
# 		ssh-keys = "centos7:${file("~/.ssh/id_rsa.pub")}"
#     }
# }

# resource "google_compute_firewall" "allow-http" {
# 	name = var.vm_config["firewall_name"]
# 	network = google_compute_network.globalvpc.self_link
   
# 	allow {
# 		protocol = "tcp"
# 		ports = ["80","22"]
# 	}
# 	source_tags = [var.vm_config["network_tags"]]
#     source_ranges = [ "0.0.0.0/0" ]
# }