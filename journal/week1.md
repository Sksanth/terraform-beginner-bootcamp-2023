# Week 1 — Building TerraHouse Static Website

## Table of Contents
 - [Root Module](Root-Module)
 - [Terraform Variables](Terraform-Variables)
     - [Order of Terraform Variable ](Order-of-Terraform-Variable )
 - [Terraform Import and Configuration Drift](Terraform-Import-and-Configuration-Drift)
 - [Terraform Module](Terraform-Module)
 - [Static Website Hosting](Static-Website-Hosting)
 - [CDN Implementation](CDN-Implementation)
 - [Issue: Invalid Path for html files](Issue-Invalid-Path-for-html-files)
   
## Root Module
The root module serves as an entry point for our Terraform configuration. Any ```".tf"``` files in the root considered as a root module. Terraform evaluates the configuration files in the root module. The root module can call other modules and pass input variables to them.
```
PROJECT_ROOT
│
├── main.tf                 # Main Terraform configuration file, 
├── variables.tf            # Define input variables.
├── terraform.tfvars        # Store variable values (should be added to .gitignore).
├── providers.tf            # Define required providers and their configurations.
├── outputs.tf              # Define outputs from the Terraform modules.
└── README.md               # Documentation about the Terraform project.
```

[Standard Module Structure of Terraform](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Variables
There are two main types of variables in Terraform <br>
-	**Terraform variables** are defined directly within the Terraform configuration files using the variable block.<br>
-	**Environment variables** are values set outside the Terraform configuration, typically in the shell or environment where Terraform is executed. We can reference environment variables directly within our Terraform configurations.

In Terraform, we have several ways to manage variables and their values:
[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Variable Blocks
We can define variables directly in our Terraform configuration files using variable blocks. These variables can have default values, descriptions, and other attributes. 
For example:
```
variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}
```

### -var flag:
We can use the -var flag to set an input variable or override a variable in the ```tfvars``` file 

```sh
Copy code
terraform apply -var user_uuid="my-user_id"
```

### -var-file flag:
The -var-file flag in Terraform allows us to specify a file containing variable values. This is useful when we have a lot of variables or sensitive information that we don't want to specify directly on the command line.
```sh
terraform apply -var-file=example.tfvars
```
### terraform.tfvars 
This file is not loaded automatically by Terraform.
we need to explicitly mention it while running Terraform commands, like ```terraform apply -var-file=terraform.tfvars```
It's useful when we want to keep the variable values in a separate file and load them when running Terraform commands.
It's usually used for storing sensitive information or values that don't change frequently.

### auto.tfvars

Terraform automatically loads this file without any need for explicit command-line flags.
It's useful for storing default or frequently changing values that don't contain sensitive information.
Variables defined in auto.tfvars will be automatically loaded without needing any additional flags.

### Order of Terraform Variable 
 The order from highest to lowest precedence:

- ```Command Line Flags (-var and -var-file):``` Variables can be passed via the -var and -var-file options on the command line. Multiple -var options or multiple variables in a single -var-file can be used to set multiple variables.

- ```*.auto.tfvars and *.auto.tfvars.json Files:``` Terraform automatically loads any files with the extensions .auto.tfvars or .auto.tfvars.json in lexical order of their filenames.

- ```terraform.tfvars.json:``` Similar to terraform.tfvars, Terraform automatically loads variables from a JSON file named terraform.tfvars.json if it exists in the current directory.

- ```terraform.tfvars:``` Terraform automatically loads variables from a file named terraform.tfvars if it exists in the current directory.

- ```Environment Variables:``` Terraform checks for environment variables prefixed with TF_VAR_. For example, if your variable is named example_var, Terraform will look for an environment variable named TF_VAR_example_var.


## Terraform Import and Configuration Drift

### Handling State File Loss in Terraform: A Recovery Guide
- **Losing Your State File:** What to Do?
Losing ```Terraform state file``` can be a significant challenge. In such cases, manual intervention might be necessary to rebuild the cloud infrastructure.

- **Manual Infrastructure Rebuilding:** A Last Resort
If our state file is lost, we have to tear down and recreate our cloud resources manually. While Terraform offers the terraform import command, it's essential to note that not all cloud resources can be imported. 

- **Fixing Missing Resources with Terraform Import**
One way to address missing resources is by using terraform import:

```bash
terraform import aws_s3_bucket.bucket bucket-name
```
This command allows to import existing cloud resources into Terraform, enabling us to manage them going forward. [AWS S3 bucket import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

- **Dealing with Manual Configuration Changes**
Sometimes, cloud resources are modified manually, causing configuration drift. To resolve this use ```Terraform plan``` command to restore the infrastructure.

- **Detecting and Correcting Configuration Drift**

By running terraform plan, Terraform assesses our existing infrastructure against the defined configuration. It identifies variances, allowing you to understand the differences between the intended state and the actual state. This insight enables you to correct any configuration drift, ensuring your infrastructure aligns with your desired specifications.

- **Terraform Refresh**
The ```terraform apply -refresh-only``` command in Terraform is used to perform a refresh of the state of the infrastructure without making any changes.

## Terraform Module
### AWS Terrahouse Module
Terraform modules are a way to organize your Terraform code into reusable and self-contained components.
Basic module structure:
```
terrahouse_aws/
  ├── main.tf        # Main Terraform configuration for the module
  ├── variables.tf   # Input variables for the module
  ├── outputs.tf     # Output values that the module provides to the caller
  └── README.md      # Documentation explaining how to use the module
```

### Passing Input Variables

To pass input variables to a module, declare the variables in the module's variables.tf file. For example:

```hcl
Copy code
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```
### Module Sources

We can import modules from different sources using the source attribute, such as:

- **Local Path**
```hcl
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

- **GitHub**
```hcl
Copy code
module "terrahouse_aws" {
  source = "github.com/user/repo/module"
}
```

- **Terraform Registry**
```hcl
Copy code
module "terrahouse_aws" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "1.2.0"
}
```

## Static Website Hosting
We hosted a Static Website in AWS S3 bucket using Terraform

### Working With Files in Terraform

#### File Functions:

- **fileexists Function:**
Terraform provides a built-in function, fileexists, to check the existence of a file.

```hcl
condition = fileexists(var.error_html_filepath)
```
[Terraform fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists) Documentation

- **filemd5 Function:**
The filemd5 function hashes the contents of a file, enabling the verification of file content status.
[Terraform filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5) Documentation

#### Path Variables

In Terraform, special variables like path.module and path.root allow referencing local paths:

- **path.module:**
Retrieves the path for the current module.

- **path.root:**
Retrieves the path for the root module.

```hcl
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

## CDN Implementation

### Terraform Locals:
Locals enable the definition of local variables, useful for transforming data and referencing variables within a module.

```hcl
locals {
  s3_origin_id = "MyS3Origin"
}
```

### Terraform Data Sources:

Data sources fetch data from cloud resources, enabling reference without importing. Useful for accessing cloud resource details.

```hcl
Copy code
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

### Terraform Data:

Plain data values (e.g., local values, input variables) lack side-effects for planning. Use terraform_data to trigger replacements indirectly with plain values.
terraform_data is a special data source in Terraform used to access dynamic data generated during execution. It is typically used in a resource's lifecycle block's replace_triggered_by argument, enabling resource replacement based on changes in specific data values. This ensures resource configurations stay current with dynamic data.

[Terraform data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

### Provisioners:

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax) execute commands on compute instances. While not recommended by HashiCorp (prefer Ansible), they offer functionalities.

- **Local-exec Provisioner** <br>
Executes commands on the machine running Terraform commands (e.g., plan, apply).

```hcl
Copy code
resource "aws_instance" "web" {
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

- **Remote-exec Provisioner**<br>
Executes commands on a targeted machine. Requires SSH credentials.

```hcl
Copy code
resource "aws_instance" "web" {
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

### For Each Expressions:

for_each enumerates over complex data types, reducing repetitive Terraform code when creating multiples of a cloud resource.

```hcl
[for s in var.list : upper(s)]
```
These expressions are handy for optimizing cloud resource configurations.

We used for_each construct for implementing assets upload to our S3 bucket


## Issue: Invalid Path for html files

### Issues with Validation
When running terraform plan, an error occurred due to an invalid path specified for the index_html_filepath variable. The error message pointed to the line in the Terraform configuration file where this variable was used.<br>
The issue was resolved by validating the path using the ```can``` function in Terraform, ensuring the specified file exists before attempting to use it in the configuration.<br>

![validation rule error SS](https://github.com/Sksanth/aws-bc/assets/102387885/37cd7be9-c432-47bb-95ef-a799a670b1a1)

The ```can``` function in Terraform converts its argument to a boolean value. It returns true if the argument can be interpreted as true and false otherwise. In the provided code, can(fileexists(var.index_html_filepath)) checks if the specified file exists and returns a boolean value based on the result.

![validation condition ss](https://github.com/Sksanth/aws-bc/assets/102387885/13aa394d-516f-4dbf-bcf0-d505211e2c23)


### Issues with eTag and Path
Encountered a simillar error again related to the eTag function due to an invalid path. As suggested by a bootcamper resolved it by adjusting the path value in the module 

```hcl
index_html_filepath = "${path.root}${var.index_html_filepath}"
```
Additionally, modified the variable in the terraform.tfvars file:

```hcl
index_html_filepath = "/public/index.html"
```
