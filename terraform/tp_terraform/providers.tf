# Définition des providers que l'on veut, avec une version éventuelle
terraform {
  required_version    = ">= 0.14.0"                    # Prend en compte les versions de terraform à partir de la 0.14.0
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.13.0"
    }
    local = { 
      source = "hashicorp/local" 
      version = ">= 2.2.3" 
    }
  }
}

# Configure le fournisseur OpenStack hébergé par OVHcloud
provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/"    # URL d'authentification
  domain_name = "default"                           # Nom de domaine - Toujours à "default" pour OVHcloud
  alias       = "ovh"                               # Un alias
}

provider "ovh" {
  alias    = "ovh"
  endpoint = "ovh-eu"
}
