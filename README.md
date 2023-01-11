# Projet de déploiement avec terraform ansible et docker pour monter une infrastructure (coir schéma ci-dessous)


Le Haproxy sera disponible sur l'ip du front qui sera récuperer avec la démarche suivante lorsque le terraform et le ansible auront été lancé

  - aller dans le dossier "ansible" 
    ```
    sed -n 4p inventory.yml | sed 's/.$//'
    ```

Il y aura premièrement les backends 1 qui seront sur le port 80
Cette page internet affichera une image de chat qui change lorsque vous rechargez la page puis une phrase avec le meilleur utilisateur

 - vous pouvez y accéder grâce à l'ip du front suivi de  :80  ce qui donnera `<ip front>:80`

deuxièmement les backends 2 qui seront sur le port 81
Cette page internet affichera un tableau aves des informations spécifique sur le navigateur et autres ...

 - vous pouvez y accéder grâce à l'ip du front suivi de  :81  ce qui donnera `<ip front>:81`

dernièrement les backends 3 qui seront sur le port 82
Cette page internet affichera un wordpress sur lequel vous pourrez créer votre propre site internet

 - vous pouvez y accéder grâce à l'ip du front suivi de  :82  ce qui donnera `<ip front>:82`



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

