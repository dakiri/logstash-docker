# Build

make build

# Mise à jour de logstash

Télécharger le package .deb disponible sur https://www.elastic.co/fr/downloads/logstash 

+ déposer dans ./package 
+ actualiser la variable LOGSTASH_VERSION du Dockerfile

# Volumes

+ /etc/logstash/conf.d
Configuration du logstash

+ /var/log/logstash
Log propre au fonctionnement du logstash

+ /var/result
Données générées par logstash


# Configuration

La configuration est automatiquement recharge en cas de modification

# TODO 

Mise en place d'un logrotate

