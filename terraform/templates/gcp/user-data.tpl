#cloud-config
bootcmd:
    - echo "PAGE_TITLE=Greetings from GCP!" | sudo tee -a /etc/environment
    - echo "HEADER_MESSAGE=Greetings from GCP!" | sudo tee -a /etc/environment
    - echo "SPECIAL_MESSAGE=${special_message}" | sudo tee -a /etc/environment
    - echo "HOST_NAME=$(hostname)" | sudo tee -a /etc/environment
    - echo "INTERNAL_IP_ADDRESS=$(ip addr show ens4 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')" | sudo tee -a /etc/environment
    - echo "EXTERNAL_IP_ADDRESS=$(curl -s ifconfig.me)" | sudo tee -a /etc/environment
    - echo "HOST_OPERATING_SYSTEM=$(uname -srmpio)" | sudo tee -a /etc/environment
    - echo "BOOT_TIME=$(uptime -s)" | sudo tee -a /etc/environment
runcmd:
    - sudo -u ubuntu docker stack deploy -c /opt/docker/docker-stack-deploy.yml hello-world