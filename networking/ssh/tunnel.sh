# access remote service locally
ssh -L 8888:localhost:8888 root@remote-host

# access local service remotely
ssh -R 8888:localhost:8888 root@remote-host
