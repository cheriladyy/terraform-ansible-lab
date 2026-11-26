module "vpc" {
  source = "../../modules/vpc"

  project        = var.project
  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr_block
}

module "network" {
  source = "../../modules/network"

  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "compute" {
  source = "../../modules/compute"

  project          = var.project
  environment      = var.environment
  instance_type    = var.instance_type
  ssh_allowed_cidr = var.ssh_allowed_cidr
  public_key_path  = var.public_key_path
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.network.public_subnet_ids[0]

  depends_on = [module.network]
}

module "monitoring" {
  source = "../../modules/monitoring"

  project          = var.project
  environment      = var.environment
  instance_type    = var.monitoring_instance_type
  ssh_allowed_cidr = var.ssh_allowed_cidr
  public_key_path  = var.public_key_path

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.network.public_subnet_ids[0]

  agent_security_group_id = module.compute.security_group_id
}

