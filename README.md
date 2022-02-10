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
3. Inside your project

																	






