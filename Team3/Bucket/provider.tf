provider "google" {
	region = var.bucket_config["region"]
	zone = var.bucket_config["zone"]
}
