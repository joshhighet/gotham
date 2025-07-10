#!/bin/bash
mkdir opencti && cd opencti
git clone https://github.com/OpenCTI-Platform/docker.git
cd docker
# sub out mail.int & beluga.highnet respectively
sudo apt install -y jq
cd ~/docker
(cat << EOF
OPENCTI_ADMIN_EMAIL=opencti@mail.int
OPENCTI_ADMIN_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
OPENCTI_ADMIN_TOKEN=$(cat /proc/sys/kernel/random/uuid)
OPENCTI_BASE_URL=http://beluga.highnet:8080
MINIO_ROOT_USER=$(cat /proc/sys/kernel/random/uuid)
MINIO_ROOT_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
ELASTIC_MEMORY_SIZE=4G
CONNECTOR_HISTORY_ID=$(cat /proc/sys/kernel/random/uuid)
CONNECTOR_EXPORT_FILE_STIX_ID=$(cat /proc/sys/kernel/random/uuid)
CONNECTOR_EXPORT_FILE_CSV_ID=$(cat /proc/sys/kernel/random/uuid)
CONNECTOR_IMPORT_FILE_STIX_ID=$(cat /proc/sys/kernel/random/uuid)
CONNECTOR_EXPORT_FILE_TXT_ID=$(cat /proc/sys/kernel/random/uuid)
CONNECTOR_IMPORT_DOCUMENT_ID=$(cat /proc/sys/kernel/random/uuid)
SMTP_HOSTNAME=mx.dotco.nz
EOF
) > .env

if [ $(sysctl -n vm.max_map_count) -lt 1048575 ]; then
    echo "vm.max_map_count=1048575" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

docker compose up -d
