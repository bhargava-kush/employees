resource "aws_db_instance" "employee_app" {
  allocated_storage        = "${var.rds_allocated_storage}" # gigabytes
  engine                   = "${var.rds_engine}"
  engine_version           = "${var.rds_engine_version}"
  identifier               = "${var.rds_identifier}"
  instance_class           = "${var.rds_instance_class}"
  name                     = "${var.database_name}"
  parameter_group_name     = "${var.rds_parameter_group_name}" # if you have tuned it
  password                 = "${var.database_password}"
  storage_type             = "${var.rds_storage_type}"
  username                 = "${var.database_user}"
  vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
  backup_retention_period  = 7   # in days
  multi_az                 = false
  skip_final_snapshot      = true
  port                     = 5432
  publicly_accessible      = true
}


resource "aws_security_group" "mydb1" {
  name = "mydb1"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id = "${var.rds_vpc_id}"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
