# tflint-ignore: terraform_unused_declarations
variable "region_front" {
  type    = string
  default = "GRA11"
}

variable "region_db" {
  type    = string
  default = "GRA"
}


variable "region_back" {
  type    = list
  default = ["GRA11", "SBG5"]
}
variable "instance_name_front" {
  type = string
  default = "front_eductive06"
}

variable "instance_name_back" {
  type = string
  default = "backend_eductive06"
}

variable "instance_name_db" {
  type = string
  default = "db_eductive06"
}

variable "user_name" {
  type = string
  default = "eductive06"
}

variable "number_instance_back" {
  type    = number
  default = 3
}

variable "image_name" {
  type = string
  default = "Debian 11"
}

variable "flavor_name" {
  type = string
  default = "s1-2"
}

variable "flavor_name_bdd" {
  type = string
  default = "s1-2"
}

variable "service_name" {
  type    = string
}

variable "vlan_id" {
  type    = number
  default = 6
}
variable "vlan_dhcp_start" {
  type = string
  default = "192.168.6.100"
}
variable "vlan_dhcp_end" {
  type = string
  default = "192.168.6.200"
}
variable "vlan_dhcp_network" {
  type = string
  default = "192.168.6.0/24"
}
