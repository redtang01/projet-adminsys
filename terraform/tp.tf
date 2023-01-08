# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "front_key" {
  provider   = openstack.ovh
  name       = "sshkey_${var.instance_name_front}"
  public_key = file("~/.ssh/id_rsa.pub")
  region     = var.region_front
}


# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "back_key" {
  count      = length(var.region_back)
  provider   = openstack.ovh
  name       = "sshkey_${var.instance_name_back}"
  public_key = file("~/.ssh/id_rsa.pub")
  region     = element(var.region_back, count.index)
}

#resource "local_file" "inventory" {
#  filename = "../ansible/inventory.yml"
#  content = templatefile("inventory.tmpl",
#    {
#      nodes_front = [for k, p in openstack_compute_instance_v2.tp_frontend: p.access_ip_v4],
#      nodes_back = [for k, p in openstack_compute_instance_v2.tp_backend: p.access_ip_v4],
#    }
#  )
#}

# Création d'une instance
resource "openstack_compute_instance_v2" "tp_frontend" {
  name        = var.instance_name_front   # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name      # Nom du type d'instance
  region      = var.region_front           # Nom de la régions
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.front_key.name

  network {
    name      = "Ext-Net"
  }
}


# Création d'une instance
resource "openstack_compute_instance_v2" "tp_backend" {
  count       = var.number_instance_back * 2   # Nombre d'instance
  name        = "${var.instance_name_back}_${lower(substr(element(var.region_back, count.index), 0, 3))}_${((count.index + 1) % 2 == 0) ? ((count.index+1) / 2) : (((count.index +1) + 1) / 2)}"   # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name      # Nom du type d'instance
  region      = element(var.region_back, count.index % 2)           # Nom de la régions
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.back_key[count.index % 2].name

  network {
    name      = "Ext-Net"
  }

  network {
    name = ovh_cloud_project_network_private.network.name
  }
  depends_on = [ovh_cloud_project_network_private_subnet.subnet]

}

# Inventaire
resource "local_file" "inventory" {
  filename = "../ansible/inventory.yml"
  content  = templatefile("templates/inventory.tmpl",
    {
      tp_backend_1 = [for k, p in openstack_compute_instance_v2.tp_backend: p.access_ip_v4 if substr(p.name, -1,length(p.name)) == "1"],
      tp_backend_2 = [for k, p in openstack_compute_instance_v2.tp_backend: p.access_ip_v4 if substr(p.name, -1,length(p.name)) == "2"],
      front = openstack_compute_instance_v2.tp_frontend.access_ip_v4,
    }
  )
}

# Création d'un réseau privé
 resource "ovh_cloud_project_network_private" "network" {
    service_name = var.service_name
    name         = "private_network_${var.instance_name_back}"                        # Nom du réseau
    regions      = var.region_back
    provider     = ovh.ovh                                  # Nom du fournisseur
    vlan_id      = var.vlan_id                              # Identifiant du vlan pour le vRrack
 }
resource "ovh_cloud_project_network_private_subnet" "subnet" {
    count        = length(var.region_back)
    service_name = var.service_name
    network_id   = ovh_cloud_project_network_private.network.id
    start        = var.vlan_dhcp_start                          # Première IP du sous réseau
    end          = var.vlan_dhcp_end                            # Dernière IP du sous réseau
    network      = var.vlan_dhcp_network
    dhcp         = true                                         # Activation du DHCP
    region       = var.region_back[count.index % 2]
    provider     = ovh.ovh                                      # Nom du fournisseur
    no_gateway   = true                                         # Pas de gateway par defaut
 }
