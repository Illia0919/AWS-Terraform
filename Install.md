# Terraform Evaluation

Deploy serverless application with terraform

---
## Requirements

For development, you will only need Node.js and a node global package, terraform, installed in your environment.

### Node
- #### Node installation on Windows

  Just go on [official Node.js website](https://nodejs.org/) and download the installer.
  Also, be sure to have `git` available in your PATH, `npm` might need it (You can find git [here](https://git-scm.com/)).

- #### Node installation on Ubuntu

  You can install nodejs and npm easily with apt install, just run the following commands.

      $ sudo apt install nodejs
      $ sudo apt install npm

- #### Other Operating Systems
  You can find more information about the installation on the [official Node.js website](https://nodejs.org/) and the [official NPM website](https://npmjs.org/).

If the installation was successful, you should be able to run the following command.

    $ node --version
    v8.11.3

    $ npm --version
    6.1.0

If you need to update `npm`, you can make it using `npm`! Cool right? After running the following command, just open again the command line and be happy.

    $ npm install npm -g


### Terraform installation
After installing node, this project will need terraform cli too, Just go on [official hashicorp website](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) and download the installer.
 - #### Verify the installation
   
   `$ terraform -help`

---

## Install

    $ git clone https://bitbucket.org/illyakov919/terraform_1st.git
    $ cd terraform_1st
    $ npm install



## Running the project

    $ npm run start

## Building for deployment to AWS

    $  npm run transpile

## Deploying to AWS with terraform

    $  terraform init
    $  terraform apply

NB: Change bucket variable in terraform-evaluation