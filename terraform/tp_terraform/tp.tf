# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "test_keypair" {
  count      = length(var.region)
  provider   = openstack.ovh
  name       = "sshkey_${var.instance_name}"
  public_key = file("~/.ssh/id_rsa.pub")
  region     = element(var.region, count.index)
}

resource "local_file" "inventory" {
  filename = "../ansible/inventory.yml"
  content = templatefile("inventory.tmpl",
    {
      nodes = [for k, p in openstack_compute_instance_v2.tp_terraform: p.access_ip_v4],
    }
  )
}
# Création d'une instance
resource "openstack_compute_instance_v2" "tp_terraform" {
  count       = length(var.region)   # Nombre d'instance
  name        = "${var.instance_name}_pub_${count.index+1}"   # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name      # Nom du type d'instance
  region      = element(var.region, count.index)           # Nom de la régions
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair[count.index].name

  network {
    name      = "Ext-Net"
  }

  network {
    name = ovh_cloud_project_network_private.network.name
  }
  depends_on = [ovh_cloud_project_network_private_subnet.subnet]

}

# Création d'un réseau privé
 resource "ovh_cloud_project_network_private" "network" {
    service_name = var.service_name
    name         = "private_network_${var.instance_name}"                        # Nom du réseau
    regions      = var.region
    provider     = ovh.ovh                                  # Nom du fournisseur
    vlan_id      = var.vlan_id                              # Identifiant du vlan pour le vRrack
 }
resource "ovh_cloud_project_network_private_subnet" "subnet" {
    count        = length(var.region)
    service_name = var.service_name
    network_id   = ovh_cloud_project_network_private.network.id
    start        = var.vlan_dhcp_start                          # Première IP du sous réseau
    end          = var.vlan_dhcp_end                            # Dernière IP du sous réseau
    network      = var.vlan_dhcp_network
    dhcp         = true                                         # Activation du DHCP
    region       = var.region[count.index]
    provider     = ovh.ovh                                      # Nom du fournisseur
    no_gateway   = true                                         # Pas de gateway par defaut
 }


