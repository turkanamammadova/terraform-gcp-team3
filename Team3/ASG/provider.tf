# provider "google" {
# 	region = var.vpc_config["region"]
# 	zone = var.vpc_config["zone"]
# }

provider "google" {
   region = var.vm_config["region"]
	zone = var.vm_config["zone"]
}