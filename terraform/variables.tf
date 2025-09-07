variable "project_name" { default = "travelmemory" }
variable "region" { default = "us-west-2" }

# Your public IP/CIDR for SSH lockdown (replace with your IP/32)
variable "my_ip_cidr" { default = "0.0.0.0/0" }

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_cidr" { default = "10.0.1.0/24" }
variable "private_cidr" { default = "10.0.2.0/24" }

# Name of the EC2 Key Pair in AWS (create it beforehand in AWS console as 'Jay-TravelMemoryApp-keypair')
variable "key_name" { default = "Jay-TravelMemoryApp-keypair" }

# Instance types
variable "web_instance_type" { default = "t3.micro" }
variable "db_instance_type" { default = "t3.micro" }
