data "aws_caller_identity" "current" {}

module "aws_terra_vpc" {
  source = "./modules/aws_vpc"
}

module "aws_terra_instance" {
  source     = "./modules/aws_instance"
  vpc_id     = module.aws_terra_vpc.vpc_id
  subnet_id  = module.aws_terra_vpc.subnet_id
  account_id = data.aws_caller_identity.current.account_id
}