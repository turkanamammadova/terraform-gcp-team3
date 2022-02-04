provider "google" {
	region = var.config["region"]
}

resource "google_sql_database" "database" {
	name = var.config["name"]
	instance = google_sql_database_instance.instance.name
}


resource "google_sql_database_instance" "instance" {
	name = var.config["name"]
	region = var.config["region"]
	database_version = var.config["database_version"]
	settings {
		tier = var.config["tier"]
	}
	deletion_protection = var.config["deletion_protection"]
}
variable "config" {
	type = map(any)
	default = {
		name = "my-database-instance"
		region = "us-central1"
		tier = "db-f1-micro"
		deletion_protection = "false"
		database_version = "MYSQL_5_6" #MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB
	}
}
