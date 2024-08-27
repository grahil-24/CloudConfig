# Infrastructure and Deployment Automation for Static Sites

## Overview

This repository contains infrastructure code and configuration for provisioning a Virtual Private Server (VPS), setting up DNS, configuring the VPS, and deploying a static site. The setup uses Terraform, Ansible, and GitHub Actions to automate these processes.

First of all clone the github repository - 

```bash
    git clone https://github.com/grahil-24/URL-Shortener-Config-and-Automate.git
```

## Requirements

- **Terraform**
- **Ansible**
- **Git**
- **AWS**

## Setup Instructions

### 1. Check for AWS env variables
Make sure the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are available as they are required by terraform to provision services on AWS. If not simply run these two commands - 

       ```bash
       export AWS_ACCESS_KEY_ID={AWS_ACCESS_KEY}
       export AWS_SECRET_ACCESS_KEY={AWS_SECRET_KEY}
       ```

### 2. Terraform:
Not recommended to execute terraform apply directly without validating the script. Terrafrom Validate checks the syntax and runs the resource dependencies to check that all the mentioned resources are defined, configured, and linked. Terraform  plan checks the configuration changes.  

        ```bash
        cd ./terraform
        terraform init
        ```
1. to setup ec2 instances, security groups, elastic ip

    ```bash
    cd ./aws-vps
    terraform validate
    terraform plan
    terraform apply
    ```

if you would like to change the name of the security group or ec2 instance, simply modify the main.tf file

2. Creating a record in route53 hosted zone

First edit the hosted zone, elastic ip id and name with yours, and then - 

        ```bash
        cd ./aws-dns
        terraform validate
        terraform plan
        terraform apply
        ```
 
### 3. Ansible configuration
1. Change the ssh key path in the ansible.cfg file inside the ansible directory
2. Change the ip of the elastic ip to yours in the inventory file
3. Edit the variable file letsencrypt_conf.yml inside the web server role for setting up a tls certificate

    ```bash
        cd ./ansible/roles/web_server/vars
    
    ```
    replace - 
    - server_name with your domain
    - document root - folder where your static file will be present. As this setup uses apache/httpd its preferable to keep it inside /var/www/ dir.
    - certbot_register_email:
    - certbot_domain: your domain 

4. Make sure you are in the ansible directory and run the command - 
    
    ```bash
        ansible-playbook playbook.yml --tags "base,web_server"
    ```

This script will
    
- update the ec2 instance, install apache/httpd, install certbot package and its dependencies and generate an tls certificate. 


### 4. Automatic deployment with github action

1. First you need to push your static code to a github repository
2. Copy the .github directory present in this project to your project's root directory.
3. Open the deploy.yml file inside ./.github/workflows
4. In the 6th line edit the path to the path where your files for static site is present
 
    'static/**'
5. In the 22nd line, replace the domain to yours

    ssh-keyscan {your_domain} >> ~/.ssh/known_hosts

6. In the 28th line, replace the path of site, hostname, and location on remote server where the code will be present (keep this same, if you did not change during ansible configuration)

    ./static/ ec2-user@{hostname}:/var/www/site/
    
7. In 32nd line, again replace the hostname with yours - 

    ssh -o StrictHostKeyChecking=no ec2-user@{hostname} 'sudo systemctl restart httpd'
8. Before pushing these changes, add your private ssh key of your local machine to your static sites' github repo's secret

    - go to your github repo
    - click on settings
    - Under security, click on actions.
    - In actions, click on secrets, and click on new repository secret
    - Give it the name "SSH_PRIVATE_KEY" (If you want to give a different name, make sure to use that name in deploy.yml file in line 20)
9. Push to remote repo


