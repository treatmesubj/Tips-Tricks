FROM bitnami/minideb:bookworm

RUN apt update &&\
    apt install neofetch -y &&\
    apt install python3-venv -y &&\
    apt install openjdk-17-jdk -y &&\
    python3 -m venv ~/.venv_spark &&\
    /bin/bash -c "source ~/.venv_spark/bin/activate && pip3 install pyspark && pip3 install jupyter && deactivate"

COPY script.sh /container-dir/script.sh
COPY env.sh /container-dir/env.sh
WORKDIR /container-dir/

CMD ["./script.sh"]
