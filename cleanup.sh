#!/bin/bash

docker stop $(docker ps -aq) 
docker rmi $(docker images -q) -f
docker rm $(docker ps -aq)
sudo rm -rf rails_app/tmp
sudo rm -rf data
echo y | docker volume prune
echo y | docker network prune