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