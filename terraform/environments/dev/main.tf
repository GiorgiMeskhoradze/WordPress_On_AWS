module "networking" {
  source          = "../../modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
}

module "security-groups" {
  source = "../../modules/security-group"
  vpc_id = module.networking.vpc_id
}

module "rds" {
  source             = "../../modules/rds"
  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.security-groups.rds_sg_id
  db_password        = var.db_password
}

module "efs" {
  source             = "../../modules/efs"
  private_subnet_ids = module.networking.private_subnet_ids
  efs_sg_group_id    = module.security-groups.efs_sg_id
}

module "acm" {
  source         = "../../modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}

module "alb" {
  source            = "../../modules/alb"
  alb_sg_group_id   = module.security-groups.alb_sg_id
  public_subnet_ids = module.networking.public_subnet_ids
  vpc_id            = module.networking.vpc_id
  certificate_arn   = module.acm.certificate_arn
  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name
}

module "ec2" {
  source             = "../../modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  asg_sg_id          = module.security-groups.asg_sg_id
  jenkins_sg_id      = module.security-groups.jenkins_sg_id
  efs_id             = module.efs.efs_file_id
  db_host            = module.rds.db_endpoint
  db_password        = var.db_password
}

module "asg" {
  source             = "../../modules/asg"
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  launch_template_id = module.ec2.launch_template_id
  target_group_arn   = module.alb.target_group_arn
}

module "cloudwatch" {
  source      = "../../modules/monitoring"
  asg_name    = module.asg.asg_name
  jenkins_id  = module.ec2.jenkins_id
  alert_email = var.alert_email
}