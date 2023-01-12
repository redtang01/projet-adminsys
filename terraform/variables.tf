# tflint-ignore: terraform_unused_declarations
#la région dans laquelle le front sera déployé
variable "region_front" {
  type    = string
  default = "GRA11"
}
#la région dans laquelle la database sera déployé
variable "region_db" {
  type    = string
  default = "GRA"
}

#les régions dans laquelle les backends seront déployés
variable "region_back" {
  type    = list
  default = ["GRA11", "SBG5"]
}

#le nom de mon instance front
variable "instance_name_front" {
  type = string
  default = "front_eductive06"
}

#le nom de mes instances back
variable "instance_name_back" {
  type = string
  default = "backend_eductive06"
}

#le nom de ma base de données
variable "instance_name_db" {
  type = string
  default = "db_eductive06"
}

#mon user_name
variable "user_name" {
  type = string
  default = "eductive06"
}

#le nombre d'instance back qui seront déployer (x2 les backup sont compris)
variable "number_instance_back" {
  type    = number
  default = 3
}

#le nom de mon image pour mes instances
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

#le numéro utilisé pour mon vlan du réseau privé 
variable "vlan_id" {
  type    = number
  default = 6
}

#l'adresse du début du dhcp
variable "vlan_dhcp_start" {
  type = string
  default = "192.168.6.100"
}

#l'adresse de fin du dhcp
variable "vlan_dhcp_end" {
  type = string
  default = "192.168.6.200"
}

#l'ip de du vrack
variable "vlan_dhcp_network" {
  type = string
  default = "192.168.6.0/24"
}
