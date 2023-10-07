# Week 2 – Connecting TerraHouse to TerraTowns

## Table of Contents

- [Working with Ruby](Working-with-Ruby)
- [Setting Up Terratowns Mock Web Server](Setting-Up-Terratowns-Mock-Web-Server)
- [CRUD](CRUD)
- [Setting Up Custom Terraform Provider Skeleton](Setting-Up-Custom-Terraform-Provider-Skeleton)
- [Deploying to Terratowns and Multi-Home Refactor](Deploying-to-Terratowns-and-Multi-Home-Refactor)

## Working with Ruby

### Bundler

Bundler is a package manager for ruby.
It is the primary way to install ruby packages (known as gems) for ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A ```Gemfile.lock``` will be created to lock down the gem versions used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/


## Setting Up Terratowns Mock Web Server

#### Download Terratown mock server into our repo

``` git clone https://github.com/ExamProCo/terratowns_mock_server```

#### Update Gitpod Configuration:

Copy the contents of terratown_mock_server/gitpod.yml and paste them into the gitpod.yml file located in the root directory.
Delete the now empty gitpod.yml file from its original location.

#### Rename and Relocate Bin Directory:

Rename the existing ```bin``` directory inside ```terratown_mock_server``` to ```terratowns.```
Move the renamed ```terratowns``` directory to the root level ```bin``` directory.

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.


## CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for **Create, Read, Update, and Delete**.

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete


Create a new folder [terratowns](https://github.com/Sksanth/terraform-beginner-bootcamp-2023/tree/main/bin/terratowns) under bin dir and CRUD files inside the folder

Set permissions for the CRUD files 
```
chmod u+x bin/terratowns/*
```

And execute the commands
```
./bin/terratowns/create
./bin/terratowns/read uuid
./bin/terratowns/update uuid
```

## Setting Up Custom Terraform Provider Skeleton

### Create Directory Structure:

- Create a new folder named ```terraform-provider-terratowns``` in the root directory.
- Add ```main.go``` File: Inside ```terraform-provider-terratowns```, create a new file named ```main.go```.

### Initialize Module and Dependencies:

Navigate to ```terraform-provider-terratowns```. <br>
Create a ```terraformrc``` file.<br>
Create a ```go.mod``` file with the following content:

```go
module github.com/ExamProCo/terraform-provider-terratowns

go 1.20

replace github.com/ExamProCo/terraform-provider-terratowns => /workspace/terraform-beginner-bootcamp-2023/terraform-provider-terratowns
```

#### Build Custom Provider:

Run the command:

```bash
go get github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema
go get github.com/hashicorp/terraform-plugin-sdk/v2/plugin
go build -o terraform-provider-terratowns_v1.0.0
```
- Verify the binary file terraform-provider-terratowns_v1.0.0 is created.

### Configuration and Modification:

- Modify ```main.tf``` and ```outputs.tf``` files as needed.
- Update Gitpod Configuration:

Update gitpod.yml with the line ```TF_LOG: DEBUG```.

Run the command:
```bash
export TF_LOG=DEBUG
```

### Build Provider Script:

In the ```bin``` directory, create a script named ```build_provider```.
Set executable permissions:
```bash
chmod u+x ./bin/build_provider
```
Execute the script (Ensure you are in the parent directory ```terraform-provider-terratowns```):
```bash
./bin/build_provider
```

## Deploying to Terratowns and Multi-Home Refactor
### Configure Terraform Cloud Execution

In Terraform Cloud, change the execution from Remote to Local at the project level.

<img src="https://github.com/Sksanth/aws-bc/assets/102387885/a7c6ee96-ce47-428d-a46d-f4a5114b50c0" width=50% height=50%>


- Update Terraform Files

Add required modules and resources to ```main.tf```. <br>
Update ```variable.tf``` and ```outputs.tf files```.<br>
Modify ```modules/terrahouse_aws/resource-cdn.tf```, ```modules/terrahouse_aws/resource-storage.tf```, and ```modules/terrahouse_aws/variables.tf``` files accordingly.

- Update Terraform Variables

Update the following values in ```terraform.tfvars.example``` and ```terraform.tfvars``` files:

```hcl
terratowns_endpoint="https://terratowns.cloud/api"
```

- Set the Terraform variable ```TF_VAR_terratowns_access_token```

```bash
export TF_VAR_terratowns_access_token="xxxxx444555xxxxyyyy-55666wccv"
gp env TF_VAR_terratowns_access_token="xxxxx444555xxxxyyyy-55666wccv"
```

- Set the Terraform variable ```TF_VAR_teacherseat_user_uuid```

```bash
export TF_VAR_teacherseat_user_uuid="9f9gij49d-9ej9h49-9dk39d-999cccx9is"
gp env TF_VAR_teacherseat_user_uuid="9f9gij49d-9ej9h49-9dk39d-999cccx9is"
```

### Run the Deployment

Execute the following commands:
```bash
./bin/build_provider
terraform init
terraform plan
terraform apply
```

These steps will configure Terraform Cloud execution, update the necessary files, set the required variables, and deploy the changes to Terratowns with the multi-home refactor.

- First town
  
<img src="https://github.com/Sksanth/aws-bc/assets/102387885/838af33c-bf2e-406d-9398-ee7e5e973d17" width=30% height=20%>

- Second town

<img src="https://github.com/Sksanth/aws-bc/assets/102387885/5417c7cb-348f-401f-8305-92cc99bd056c" width=30% height=25%>