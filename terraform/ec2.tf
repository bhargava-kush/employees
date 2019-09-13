data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]

  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

   owners = ["099720109477"] # Canonical
}

resource "aws_instance" "employees-terraform" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  provisioner "remote-exec" {
    inline = [
    "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
    "sudo apt-get -y update;",
    "sudo apt-get -y install python3-pip libpq-dev nginx git postgresql postgresql-contrib software-properties-common;",
    "sudo -H pip3 install virtualenv;",
    "git clone https://${var.git_username}:${var.git_password}@github.com/harpsha/dixiapp.git;",
//    "git clone git@github.com:harpsha/dixiapp.git",
    "export POSTGRES_HOST=${element(split(":", aws_db_instance.employee_app.endpoint), 0)}",
    "export DJANGO_SETTINGS_MODULE=employees.prod_settings",
    "virtualenv employee;",
    ". employee/bin/activate;",

    "cd employees/;",

    "echo 'POSTGRES_HOST=${element(split(":", aws_db_instance.employee_app.endpoint), 0)}' >> .envs/.django",
    "pip install -r requirements.txt;",
    "python manage.py makemigrations --settings=employees.prod_settings;",
    "python manage.py migrate --settings=employees.prod_settings",
    "python manage.py collectstatic --settings=employees.prod_settings --no-input",
    "deactivate;",
    "cd ..",
    "sudo cp employees/terraform/gunicorn.service /etc/systemd/system/;",
    "sudo systemctl daemon-reload;",
    "sudo systemctl start gunicorn;",
    "sudo systemctl enable gunicorn;",
    "sudo systemctl restart gunicorn;",
    "sudo cp employees/terraform/employee_nginx /etc/nginx/sites-available/;",
    "sudo ln -s /etc/nginx/sites-available/dixiapp_nginx /etc/nginx/sites-enabled;",
    "sudo systemctl restart nginx;",
    "sudo ufw allow 'Nginx Full';",
    "sudo systemctl daemon-reload",
    "sudo systemctl restart gunicorn",
    "sudo systemctl restart nginx",
],
  }

  connection {
    # The default username for our AMI
    user = "ubuntu"
    type = "ssh"
    host = "${aws_instance.employees-terraform.public_ip}"
    private_key = "${file(var.pem_file_path)}"
    # The connection will use the local SSH agent for authentication.
    agent = false
  }

  associate_public_ip_address=true

  depends_on = ["aws_db_instance.employee_app",]

  # The name of our SSH keypair we created above.
  key_name = "mumbai-server"

  tags {
    Name = "employees-prod-backend"
  }

}


resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


resource "aws_security_group" "sgroup_22_80" {
  name = "sgroup_21"
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
//Allow traffic on port 443 (HTTPS)
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags {
    "Environment" = "${var.environment}"
  }
}

