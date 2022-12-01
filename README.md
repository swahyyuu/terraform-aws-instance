# terraform aws instance
This is a Terraform configuration and Packer as AMI (Amazon Machine Image) source configuration tool in order to provisioning AWS instance which are NGINX and Apache configuration have installed inside the instance. <br>

## What Terraform do?
---
AWS resources which configured in this Terraform configuration are following : 
<br>
- AWS Virtual Private Cloud (VPC)
- AWS Elastic Compute Cloud (EC2)

## What Packer do?
---
Packer provisioning an AMI and Volume which are required to when build an instance, by doing this we can use this AMI to create instances as much as we desired with a same configuration for the instance. In this case, I build AMI with NGINX and Apache are already installed, once our instance spins up finished. Instance is read to use.

## Prerequisites
---
Currently, I'm using Ubuntu 22.04.01 LTS to build and run this project, please follow the installation steps according to your OS.
<br>
Things that we consider to have in our computer in order to run this project : 
- Terraform [[How to install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)]
- Packer [[How to install Packer](https://developer.hashicorp.com/packer/downloads?host=www.packer.io)]
- AWS CLI [[How to install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)]

Based on official guidance installation above, you can use them as references.

## How to run the project
---
### ***CAUTION, THIS PROJECT COULD MAKE AN INVOICE ON YOUR AWS ACCOUNT***
First of all, we need to configure AWS CLI in our terminal, since everything we do is using AWS CLI to connect our Terraform with AWS Resources in our account. Do this to configure AWS CLI or you can check [official documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html) :
```
  aws configure
```
This will prompt you to input your Access Key and Secret Access Key which you can found by setting up IAM User first.

After AWS CLI has been configured, let's jump into our project : 
<br>

1. Open your terminal, and clone this repository by following this :
```
  git clone https://github.com/swahyyuu/terraform-aws-instance.git
```

2. Now, let's move into where Packer configuration files placed :
```
  cd packer
```

You can see some configuration files with extension of 'pkr.hcl', because Packer was made by HashiCorp, therefore it could be written in HashiCorp Configuration Language (HCL). Basically, the name convention of the file is same like terraform file. 
<br>
You can also see there is a bash script and nginx configuration file inside 'required_scripts' folder, this bash script would be used in order to do everything once our AMI being created, and nginx configuration file required to make some changes, so Apache could run in the same server/instance.

3. Since Packer has been installed, let's run our Packer first, because we need an AMI and Volume before we build our instance. Make sure you are in the correct path directory where main.pkr.hcl is placed.
```
├── main.pkr.hcl
├── required_scripts
│   ├── nginx.conf
│   └── requirements_install.sh
├── variables.pkr.hcl
└── variables.pkrvars.hcl

```
After that, you can run following command to build our AMI and Volume :
```
  packer build -var-file="variables.pkrvars.hcl" .
```
If you want not to write this all long command because we need to specify which file will be used while we run our Packer, rename 'variables.pkrvars.hcl' to 'variables.auto.pkrvars.hcl', then you can run following command :
```
  packer build main.pkr.hcl
```
You can check this [documentation](https://developer.hashicorp.com/packer/guides/hcl/variables), if you want to know more about how variables file written.

After packer has finished, you can check if you AWS management console, whether your AMI and Volume are ready to use or not.

4. Now, let's build our Terraform configuration, make sure you are in the correct path directory where 'main.tf' file is placed.
```
├── clean_resources.py
├── main.tf
├── modules
│   ├── aws_instance
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── aws_vpc
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── bash_scripts
│       └── check_services.sh
├── outputs.tf
├── packer
│   ├── main.pkr.hcl
│   ├── required_scripts
│   │   ├── nginx.conf
│   │   └── requirements_install.sh
│   ├── variables.pkr.hcl
│   └── variables.pkrvars.hcl
├── provider.tf
├── README.md
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf
```
Terraform will ask you a default region of AWS, if you don't define it yet. Terraform do not retrieve a default region where configured in '*aws configure*', so you need to define it manually inside your file. Terraform only retrieve Acces Key and Secret Access Key of AWS Account which already configured beforehand.
<br>
Now, let's run our Terraform by running following command :
```
  terraform init
```
This will install everything in the folder tree of Terraform, and this command required before we apply configuration files.

5. After that, let's make sure everything is going alright and no error inside the files.
```
  terraform plan
```
This command will inform you all the configuration that will be build when we apply our configuration files. Here, you can check if anything might not going as you desire, so you don't have to waste time to debug when configuration has spun up.

6. After everything is fine, now it's time to apply our configuration files.
```
  terraform apply 
```
This command will ask your permission to run, if you do not want to bother it, you can add '*-auto-approve*' at the end of the command.You can take a break when this configuration files are running, and come back after several minutes.
<br>
Once everything is done, you can check in your AWS management console if everything going as you desire.

If you want to clean up all these resources, you can easily run following command : 
```
  terraform destroy -auto-approve
```
As you already know '*-auto-approve*' used in order not to ask your permission.
<br>
And if you want to clean up the AMI and Volume because it's not being used anymore, you can run this python script 'clean_resources.py'.
```
  python3 clean_resources.py
```
This python script also required aws cli configuration in order to run the script.