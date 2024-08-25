#/bin/bash
sudo service docker start
sudo sysctl -w vm.max_map_count=262144
docker network create elk
mkdir ~/elk
cd ~/elk
docker-compose up -d