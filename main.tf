terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" { 
  source = "./modules/network"

  environment         = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}


module "security_group" {  
  source = "./modules/security-group"  
  environment      = var.environment
  vpc_id          = module.network.vpc_id  
  web_subnet_cidrs = module.network.public_subnet_cidrs
  app_subnet_cidrs = module.network.private_subnet_cidrs  
}

module "ec2_instances" {
  source = "./modules/ec2"

  environment           = var.environment
  instance_type        = var.instance_type
  key_name             = var.key_name
  web_sg_id            = module.security_group.web_sg_id
  app_sg_id            = module.security_group.app_sg_id
  web_subnet_ids       = module.network.public_subnet_ids
  app_subnet_ids       = module.network.private_subnet_ids
  alb_sg_id            = module.security_group.alb_sg_id
  vpc_id               = module.network.vpc_id
}

module "rds" {
  source = "./modules/rds"

  environment        = var.environment
  database_sg_id    = module.security_group.database_sg_id
  private_subnet_ids = module.network.private_subnet_ids
  db_instance_class  = var.db_instance_class
  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}