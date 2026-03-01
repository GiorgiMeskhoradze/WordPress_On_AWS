module "Networking" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
}

module "Security-Groups" {
  source = "../../modules/security-group"
  vpc_id = module.Networking.vpc_id
}

module "Rds" {
  source = "../../modules/rds"
  private_subnet_ids = module.Networking.private_subnet_ids
  rds_sg_id = module.Security-Groups.rds_sg_id
  db_password = var.db_password
}

module "Efs" {
  source = "../../modules/efs"
  private_subnet_ids = module.Networking.private_subnet_ids
  efs_sg_group_id = module.Security-Groups.efs_sg_id
}