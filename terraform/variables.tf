//ec2

variable "region" {}

variable "environment" {
  type    = "string"
  default = "test"
}

variable "s3_bucket_prefix" {
  default     = "terra-bucket-3"
  description = "Prefix of s3 bucket"
  type        = "string"
}

variable "s3_region" {
  type = "string"
}

locals {
  s3_tags = {
    created_by  = "terraform"
    environment = "${var.environment}"
  }
}

variable "repo_key" {
  description = "Public key path"
}


variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "pem_file_path" {
  description = "Pem file"
}

variable "rds_vpc_id" {
  default = "vpc-XXXXXXXX"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "git_username" {
  description = "Git username"
}

variable "git_password" {
  description = "Git password"
}

// RDS

variable rds_allocated_storage {
  description = "Amount of storage to be initially allocated for the DB instance, in gigabytes."
  default = 20
}

variable rds_engine {
  description = "Name of the database engine to be used for this instance."
  default = "postgres"
}

variable rds_engine_version {
  description = "Version number of the database engine to use."
  default = "10.6"
}

variable rds_instance_class {
  description = "The compute and memory capacity of the instance"
  default = "db.t2.micro"
}

variable database_name {
  description = "The name of the database."
}

variable database_user {
  description = "The name of the master database user."
}

variable database_password {
  description = "Password for the master DB instance user"
}

variable rds_storage_type {
  description = "Specifies the storage type for the DB instance."
}

variable "rds_parameter_group_name" {
  description = ""
  default = "default.postgres10"
}

variable "rds_identifier" {
  description = "Identifier name"
}
