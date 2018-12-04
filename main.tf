//--------------------------------------------------------------------
// Modules
variable "username" {}
variable "password" {}

data "terraform_remote_state" "vpc" {
  backend = "atlas"
  config {
    name = "AWSDemoDarnoldTFE/Network"
  }
}

module "rds" {
  source  = "app.terraform.io/AWSDemoDarnoldTFE/rds/aws"
  version = "1.0.0"

  allocated_storage = 20
  backup_window = "09:46-10:16"
  create_db_instance = true
  create_db_option_group = true
  create_db_parameter_group = true
  create_db_subnet_group = true
  engine = "postgres9.6"
  engine_version = "9.6.3"
  identifier = "tfe"
  instance_class = "db.t2.large"
  maintenance_window = "Mon:00:00-Mon:03:00"
  password = "${var.password}"
  port = 5432
  username = "${var.username}"
  publicly_accessible = true
  family = "tfe"
  subnet_ids = "${data.terraform_remote_state.vpc.private_subnets}"
}
