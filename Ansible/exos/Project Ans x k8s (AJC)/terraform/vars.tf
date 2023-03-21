# Variables de création

variable  "AWS_ACCESS_KEY" {}    #demanderas de taper la clé ACCESS manuellement

variable  "AWS_SECRET_KEY" {}    #demanderas de taper la clé SECRET manuellement

# variable  "AWS_SSH_PUB" {}       #demanderas de taper la clé SSH PUBLIQUE manuellement

variable "INSTANCE_TYPE" {
        default = "t2.medium"
}
variable "AWS_REGION" {
 default = "us-east-1"  # permet de définir quel map il va choisir en dessous depuis le fichier main.tf
}

variable "AWS_AMIS" {
        type = map
        default = {
                "us-east-1" = "ami-09a41e26df464c548"
                "us-east-2" = "ami-"
        }
}