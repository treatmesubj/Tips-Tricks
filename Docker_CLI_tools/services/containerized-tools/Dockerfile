FROM bitnami/minideb:bookworm

RUN apt update && \
    apt install neofetch -y

COPY script.sh /container-dir/script.sh
WORKDIR /container-dir/

CMD ["./script.sh"]
