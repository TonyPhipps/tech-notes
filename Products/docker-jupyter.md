Quick run of Docker-based Jupyter notebook sharing the local path D:\Tony\Docker-in\notebook so it appears in the /work folder displayed in Jupyter at launch

```
docker run -p 8888:8888 -v d:/tony/Docker-in/notebook:/home/jovyan/work/notebook jupyter/all-spark-notebook
```

Note: add -d to run in detached mode (run in background, giving you back the prompt).

If you need to show the URL, run the command below and use the IP 127.0.0.1 instead of the displayed 0.0.0.0

```
docker exec -i ############ jupyter notebook list
```



Good Reads
- https://www.dataquest.io/blog/docker-data-science/