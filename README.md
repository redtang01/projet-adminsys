Projet de déploiement avec terraform ansible et docker pour monter une infrastructure (coir schéma ci-dessous)

Installation

- Installer terraform et ansible sur votre machine
- Cloner le dépot du projet

  ```
  git clone https://github.com/redtang01/projet-adminsys.git
  cd projet-adminsys
  ```

### Changer la configuration du Terraform si vous souhaithez d'autres instances back

    ```
    cd terraform
    nano variables.tf
    ```
    modifier la variables

    ```
    variable "number_instance_back" {
      type    = number
      default = 3
    }
    ```
    
### Démarrer le Terraform

aller dans le répêrtoire "terraform"

```
terraform apply
```

### Démarrer le ansible 

aller dans le répêrtoire "ansible"

```
ansible-playbook deploy.yml -i inventory.yml
```

