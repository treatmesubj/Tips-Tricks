```bash
docker build . -t pyspark-jupyter-notebook
docker run -itd --name pyspark-jupyter-notebook --net=host -p 8888:8888 -v ./local-dir/:/mount-dir -v ./notebooks/:/container-dir/notebooks -v ./JARs/:/container-dir/JARs -v ./truststore/:/container-dir/truststore pyspark-jupyter-notebook
    # docker container stop pyspark-jupyter-notebook
    # docker container rm pyspark-jupyter-notebook
docker logs -f pyspark-jupyter-notebook
```

```bash
docker exec -it pyspark-jupyter-notebook bash
    # source ~/.venv_spark/bin/activate
    # pyspark
```
