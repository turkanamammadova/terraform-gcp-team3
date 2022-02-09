variable "config" {
	type = map(any)
	default = {
		name = "team3-db-instance"
		region = "us-east1"
		tier = "db-f1-micro"
		deletion_protection = "false"
		database_version = "MYSQL_5_6"
	}
}
