variable "private_subnet_count" {
  type    = number
  default = 6

}

variable "public_subnet_count" {
  type    = number
  default = 6

}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1b", "us-west-1c", "us-east-1d", "us-east-1e", "us-east-1f"]

}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.111.10.0/24",
    "10.111.12.0/24",
    "10.111.32.0/24",
    "10.111.42.0/24",
    "10.111.52.0/24",
    "10.111.62.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.111.100.0/24",
    "10.111.110.0/24",
    "10.111.120.0/24",
    "10.111.130.0/24",
    "10.111.140.0/24",
    "10.111.150.0/24"
  ]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.111.205.0/24",
    "10.111.210.0/24",
    "10.111.215.0/24",
    "10.111.220.0/24",
    "10.111.225.0/24",
    "10.111.230.0/24"
  ]
}

variable "engine" {
  type        = string
  default     = "aurora-postgresql"
  description = "The engine of the Aurora DB cluster"

  validation {
    condition     = contains(["aurora-postgresql"], var.engine)
    error_message = <<-EOT
        This engine must contain: 'aurora-postgresql'
        EOT
  }
}

variable "db_username" {
  description = "The database username for IAM authentication."
  type        = string
  sensitive   = true
  default = "DMay12345"
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
  default = "admin1234$"
}