# Straight Dockerfile
- `docker build ./services/containerized-tools/ -t containerized-tools`
- `docker run -itd --name containerized-tools -v ./local-dir/:/mount-dir containerized-tools`
- `docker container ls`
- `docker exec -it containerized-tools bash`

clean up
- `docker container kill containerized-tools`

# Docker Compose
- `docker compose up -d`
- `docker container ls`
- `docker exec -it docker_cli_tools-containerized-tools-1 bash`

clean up
- `docker compose down`

---
# Purely Temporary Container From Base Image
- `docker run -itd --name temp bitnami/minideb:bookworm`
- `docker container ls`
- `docker exec -it temp bash`

clean up
- `docker container kill temp`

---
# Docker System Prune All
- `docker system prune --all`
