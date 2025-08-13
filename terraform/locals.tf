locals {
  identifier = "${var.identifier}-${var.env}"
  all_azs    = data.aws_availability_zones.primary.names

  azs = slice(data.aws_availability_zones.primary.names, 0, var.vpc.number_of_az)

  num_private_subnets = length(local.azs)
  num_public_subnets  = length(local.azs)

}
