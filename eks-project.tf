provider "aws" { 
  region = "us-west-1"
}

module "VPC" {
    source = "./modules/vpc"
    environment = var.environment
}

module "EKS" {
    private_subnet1 = module.VPC.private_subnet1
    private_subnet2 = module.VPC.private_subnet2
    public_subnet1 = module.VPC.public_subnet1
    public_subnet2 = module.VPC.public_subnet2
    source = "./modules/eks"
    environment = var.environment
}


variable "environment" {}
