# https://github.com/geerlingguy/internet-pi/issues/7
# Pi-hole update example
cd ~/pi-hole
docker-compose pull  # pulls the latest images inside the compose file
docker-compose up -d --no-deps  # restarts necessary containers with newer images
docker system prune --all  # deletes unused container images