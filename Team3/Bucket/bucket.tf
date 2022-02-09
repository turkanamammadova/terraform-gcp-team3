resource "random_string" "random" {
	length = 15
	special = false
	upper = false
}

resource "google_storage_bucket" "bucket" {
	name = "bucket-terraform-${random_string.random.result}"
	location = var.bucket_config["bucket_location"]
	force_destroy = true
}