# Week 0 — Project Preparation

## Terraform CLI Installation

Updated the Terraform CLI installation process due to changes in gpg keyring handling. So we needed to refer to the latest installation instructions in the Terraform Documentation and adjust the installation scripts accordingly.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Linux Distribution Compatibility

This project is built against Ubuntu, so ensure compatibility with the Linux distribution by checking its version and making necessary adjustments.

[To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

```
$ cat /etc/os-release
```

### Refactoring into Bash Scripts
To streamline the process and improve portability, we've created a bash script for Terraform CLI installation - 
**[install_terraform_cli](./bin/install_terraform_cli)**

- This keeps the Gitpod Task File (.gitpod.yml) clean.
- Provides an easier way to debug and manually execute Terraform CLI installation.
- Enhances portability for other projects requiring Terraform CLI installation.

#### Shebang Note
A shebang (e.g., ```#!/bin/bash```) informs the system which program to interpret the script. ChatGPT recommends using ```#!/usr/bin/env bash``` for better portability across different OS distributions.

Learn more about shebang: https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations
When running the bash script, you can use the ./ shorthand:

e.g., ```./bin/install_terraform_cli```

If we are using a script in .gitpod.yml, we need to specify the interpreter:

e.g., ```source ./bin/install_terraform_cli```

#### Linux Permissions
To make our bash scripts executable, adjust Linux permissions to allow execution in user mode:
```sh
$ chmod u+x ./bin/install_terraform_cli
```

Alternatively, we can use:
```sh
$ chmod 744 ./bin/install_terraform_cli
```
Learn more about chmod: https://en.wikipedia.org/wiki/Chmod

## GitHub Workspace Considerations
Be cautious when using the init command, as it won't rerun if we restart an existing workspace.

Read more about Gitpod workspace tasks: https://www.gitpod.io/docs/configure/workspaces/tasks

## Working with Environment Variables
Using the ```env``` Command
We can list all environment variables (Env Vars) in our workspace using the ```env``` command. To filter specific Env Vars, use grep. For example:
```
env | grep AWS_
```


### Setting and Unsetting Env Vars
In the terminal, we can set an Env Var using **export**, and unset it using **unset**. 
For example:
```
export HELLO='world`
unset HELLO
```

We can also set an Env Var temporarily for a single command:

```sh
HELLO='world' ./bin/print_message
```
In a bash script, we can set an Env Var without writing export:

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Env Vars
To print an Env Var, use the echo command. For example:
```
echo $HELLO
```

### Scope of Env Vars
New bash terminals in VSCode won't inherit Env Vars set in other windows. To make Env Vars persistent across all future bash terminals, set them in your bash profile (e.g., ```.bash_profile```).

### Persisting Env Vars in Gitpod
You can persist Env Vars in Gitpod by storing them in Gitpod Secrets Storage using:

```
gp env HELLO='world'
```
This will set Env Vars for all bash terminals opened in future workspaces. <br>
You can also set env vars in the ```.gitpod.yml```.
**Note** that sensitive Env Vars should not be stored this way.


## AWS CLI Installation
The AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)<br>
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


To check if the AWS credentials are configured correctly, run the following AWS CLI command:

```sh
aws sts get-caller-identity
```
If successful, you should see a JSON payload.

<img src="https://github.com/Sksanth/terraform-beginner-bootcamp-2023/assets/102387885/482d2864-dce2-4fcf-9f4b-414e1a7a2c6a" width=50% height=70%> 

Make sure to generate AWS CLI credentials from an IAM User to use the AWS CLI.


## Terraform Basics
### Terraform Registry
Terraform sources providers and modules from the Terraform registry, [registry.terraform.io](https://registry.terraform.io/). <br>
- **Providers** interface with APIs to create resources
- **modules** make Terraform code modular and shareable.

Example: [Randon Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console
You can see a list of Terraform commands by typing ```terraform```.
| Terraform Command       | Description                                                                                       |
|-----------------------  |---------------------------------------------------------------------------------------------------|
| Terraform Init        | Use `terraform init` at the start of a new project to download provider binaries.               |
| Terraform Plan        | Run `terraform plan` to generate a changeset about the state of your infrastructure.             |
| Terraform Apply       | Execute `terraform apply` to apply changes. Use `--auto-approve` for automatic approval.         |
| Terraform Destroy     | Run `terraform destroy` to delete resources. You can use `--auto-approve` for automatic approval. |
| Terraform Lock Files  | `.terraform.lock.hcl` contains locked provider or module versions and should be committed to version control. |
| Terraform State Files | `.terraform.tfstate` contains infrastructure state information. Do not commit this file to version control. |
| Terraform Directory   | The `.terraform` directory contains Terraform provider binaries.                                   |


## Issues with Terraform Cloud Login and Gitpod Workspace
Running terraform login in Gitpod's VSCode browser view may not work as expected. A workaround is to manually generate a token in Terraform Cloud:

Generate Token
Then create and open the file manually:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace with your token):

![tf cloud token code](https://github.com/Sksanth/terraform-beginner-bootcamp-2023/assets/102387885/9b6b7dfc-2a4c-4066-a397-543aca8da9f6)


We have automated this workaround with the following bash script [generate_tfrc_credentials](https://github.com/Sksanth/terraform-beginner-bootcamp-2023/blob/main/bin/generate_tfrc_credentials)


## Setting an Alias for Terraform

To make working with Terraform commands more convenient, we set an alias for Terraform as 'tf' in our bash profile. Here are the steps:

Open the ```.bash_profile``` file in a gitpod text editor using the following command
```
open ~/.bash_profile
```
This command opens the .bash_profile file in a text editor, allowing you to make edits.<br>
Add the Alias by entering ```alias tf="terraform" ``` into the .bash_profile file

This line creates an alias named **tf** that maps to the **terraform** command.

Execute the Alias immediately in our current shell session by running:
```
source ~/.bash_profile
```
This command reloads our .bash_profile file, making the **tf** alias available for immediate use.


We've also created a bash script, [set_tf_alias](https://github.com/Sksanth/terraform-beginner-bootcamp-2023/blob/main/bin/set_tf_alias), that automates this process. It checks if the alias already exists in the .bash_profile file and appends it if doesn't exists. 







