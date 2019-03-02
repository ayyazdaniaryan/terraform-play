variable "cidr_sub_pub_list" {
  type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "cidr_sub_private_list" {
  type = "list"
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zone_list" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}