# Google Cloud Plaform 3tier application

### Prerequisities:
	
- Login to your Google Cloud Console
- Select Billing under hamburger menu
- Create a __Billing Account__ For ex: in this project we created ```Team3_Billing_Account```
- Go to GCP Dashboard(under hamburger menu) and create a project
- Note `Project name` and `Project ID`

### IAM (Identity and Access Management)
> GCP IAM service manages access controls for Google resources
1. Go to IAM service and click `ADD`
2. Enter one or more users by using users' email addresses
3. Assign roles for each users to grant them access to your resources. Keep in mind, multip roles are allowed
		Here are some roles examples we used for this project:
		
- *Actions Admin*  - Access to edit and deploy an action
- *Editor*  - View, create, update, and delete most Google Cloud resources. (BE CAREFUL for this role)
- *Owner* - Full access to most Google Cloud resources


### Github

1. Go to Github and create a repo for your project, dont forget to add `.gitignore` and `README.md` files
2. This is group project, so add your collaborators into your project with their github names
3. After adding them as collaborator, users will be able to add their SSH public keys to github successfully
4. Users will be able to clone the project into their locals with `git clone` command

### Google Cloud Shell
1. Activate Google Cloud Shell (Shell icon is located in from GCP header section)
2. From Cloud Shell terminal clone the project to your local
- copy project URL (ssh) from github
- from your local execute `git clone REPO_URL`
- check the logs and make sure it's cloned properly

 ### VPC module
 > In this project, we used global VPC, because it provided us managed and global virtual network for all of our Gcloud resources through subnets. 

Steps:
 1. Create `vpc.tf` file in folder with `.gitignore` and `README.md` files
 2. Use `google_compute_network` resource to create the vpc
 ```
 resource "google_compute_network" "globalvpc" {
	name = "team3-vpc"
	auto_create_subnetworks = "true"
	routing_mode = "GLOBAL"
}
```
  3. Open integrated terminal for this folder 
  4. **DO NOT FORGET** to set the project first, otherwise your resources won't be created under your project in GCP
     
     Command for setting the project:
     			`gcloud config set project [PROJECT_ID]`
   5. Run `terraform init` command to initialize it
   6. Run `terraform plan` and see if you have any syntax error
   7. Run `terraform apply` to apply your changes
   8. Go to Google Console and check if your VPC is created under the name of `team3-vpc`
   	
	Note: there is also Default VPC in GCP. Please find your newly created VPC
	
   ### Database
> Google Cloud SQL is managed database service and it allows us to run MySQL, PosgreSQL on GCloud.

 1. In Cloud Shell under your repo folder, create a folder DB and add terraform files in it - `dbinstance.tf`, `variables.tf` and `provider.tf`
 2. In `dbinstance.tf` add your resources to create your database instance. Use `google_sql_database_instance` resource for this:
 
	```
	resource "google_sql_database_instance" "instance" {
	name = var.config["name"]
	region = var.config["region"]
	database_version = var.config["database_version"]
	settings {
		tier = var.config["tier"]
	}
	deletion_protection = var.config["deletion_protection"]}

  3. In `dbinstance.tf` file add your resource to create your database inside db instance
  
	resource "google_sql_database" "database" {
	name = var.config["name"]
	instance = google_sql_database_instance.instance.name
}
	
  3. In variables.tf add your variables to make your resources more dynamic
  4. Run `terraform init`, `terraform apply` to apply your changes
  5. Check Gcloud and make sure your resources are created under `team3-db-instance`
  6. In Google Console, you will be able to find your db instance's `Public IP address` and also `Connection name`
  7. From SQL service, add a user to your database instance 
  8. You can connect to your db instance from Cloud Shell by using `gcloud sql connect team3-db-instance --user=mammadova --quiet` command
  9. Connect to your database instance, use `show databases;` query and make sure your db is created. *this db will be used for wordpress connection*
  10. If you see your db inside your db instance, you should be good. Move on 
	
	
   ### Autoscaling
 > For handling increasings in traffic dynamically we used Autoscaling. It's adding/reducing capacity.

  1. Create `asg.tf` file and add `google_compute_autoscaler` resource inside the file. Use `gcloud compute images list` command to list of available images in GCloud. For ex: we used `centos-cloud/centos-7`.  [PROJECT/FAMILY]
    
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
	}}

     
  2.  Add `google_compute_instance_template` resource in `asg.tf` file. No matter how many instances are in your instance group, they will be created from this template. Use `gcloud compute machine-types list` command to list all available machine types in GCloud.  For ex, we used: 

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
	}}
	
3. Also add your `google_compute_instance_group_manager`, `google_compute_target_pool`, and `google_compute_firewall` resource in asg.tf file as well for handling firewall and targets groups.
4. Add `variables.tf` file inside your ASG folder. Variables file will allow you to have your scripts more dynamic. Instead of hardcoding the data inside your resources, `variables.tf` file will give you opportunity to keep your data inside it and fetch from another file as long as the files share same root.
5. Add `startup.sh` file for bootstrapping. It means whatever command like you in this file, it will be launching during the instance provisioning. Please see `metadata_startup_script = file("startup.sh")` line under `google_compute_instance_template` resource.
In our case, here is our script to install wordpress:
```
WORDPRESS_DB_HOST="HOST_IP"
WORDPRESS_DB_NAME="team3db"
WORDPRESS_DB_USER="mammadova"
WORDPRESS_DB_PASSWORD="DB_PASSWORD"
sudo yum install httpd wget unzip epel-release mysql -y
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-php56   [Install PHP 5.6]
sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xf latest.tar.gz -C /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo getenforce
sudo sed ‘s/SELINUX=permissive/SELINUX=enforcing/g’ /etc/sysconfig/selinux -i
sudo setenforce 0
sudo chown -R apache:apache /var/www/html/
sudo systemctl start httpd
sudo systemctl enable httpd
```
6. **DO NOT FORGET** to set the project first, otherwise your resources won't be created under your project in GCP
7. Run `terraform init`, `terraform apply` commands to create the services in GCP
8. Go Gcloud and check if resources are created properly
9. Use public IP for the instance and see if you are able to load the wordpress
10. Use `mysql -u mammadova -h 35.196.102.47 -p team3db` command to connect from your VM machine to your database instance


At this point, your wordpress should be UP and RUNNING!!! 
Note: Go to wordpress backend and customize your web page : )
     
  
	


																	






