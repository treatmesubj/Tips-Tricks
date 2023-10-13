docker pull registry.access.redhat.com/ubi8/ubi:8.6
docker run -itd registry.access.redhat.com/ubi8/ubi:8.6
docker ps
# CONTAINER ID   IMAGE                                     COMMAND   CREATED         STATUS         PORTS     NAMES
# 7bfc3b151f19   registry.access.redhat.com/ubi8/ubi:8.6   "bash"    3 minutes ago   Up 3 minutes             special_container
docker exec -it special_container bash
# [root@7bfc3b151f19 /]#
