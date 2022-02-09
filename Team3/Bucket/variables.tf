variable "bucket_config" {
	type = map(any)
	default = {
		region = "us-east1"
		zone = "us-east1-c"
		bucket_location = "US"
	}
}