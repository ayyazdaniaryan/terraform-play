variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id" {}

output "instance_id_web" {
  value = "${aws_instance.web.id}"
}