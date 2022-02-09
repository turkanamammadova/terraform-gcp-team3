# GCP_Project_Team3
Terraform Google Cloud Engine - 3tier

Provision Instructions:

**For DB instance**: 

```
resource "google_sql_database_instance" "instance" {
	name = var.config["name"]
	region = var.config["region"]
	database_version = var.config["database_version"]
	settings {
		tier = var.config["tier"]
	}
	deletion_protection = var.config["deletion_protection"]
}
```

For DB:

```
resource "google_sql_database" "database" {
	name = var.config["name"]
	instance = google_sql_database_instance.instance.name
}
```

Following environment variables are used for configuring Wordpress instance

```
WORDPRESS_DB_HOST="35.196.102.47"
WORDPRESS_DB_NAME="team3db"
WORDPRESS_DB_USER="mammadova"
WORDPRESS_DB_PASSWORD="XKns7hUPD89lbbM0LR8CMOOqS"
```
