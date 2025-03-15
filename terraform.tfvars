aws_region = "us-east-1"
vpc_cidr  = "10.10.0.0/16"
instance_tenancy = "default"
tag_overlay = {
    Name = "terraform-vpc"
    Env = "Sandbox"
    ProjectID = "MK001"
    PM = "Limbu Emeldine"
}

public_subnet_cidr  = "10.10.10.0/24"
private_subnet_cidr = "10.10.11.0/24"
pubrt_cidrblock = "0.0.0.0/0"
privrt_cidrblock = "0.0.0.0/0"

