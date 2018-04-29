# Docker: jupyter-scala

## Description

Scala kernel を含む Jupyter Notebook の docker image です  
https://github.com/jupyter-scala/jupyter-scala

## Requirements

このプロジェクトを実行するには以下が必要です:

* [Docker](https://docs.docker.com) 1.10.0+

## Quick start

1. Run docker image `kzmake/jupyter-scala`

    ```
$ docker run -it -p 8888:8888 -v $(pwd):/home/jovyan/work kzmake/jupyter-scala
```

    or

    ```
$ docker run -it -p 8888:8888 -v $(pwd):/home/jovyan/work kzmake/jupyter-scala start-notebook.sh --NotebookApp.token=''
```

2. Access to Jupyter Notebook
http://localhost:8888/

## Build

```
docker build -t kzmake/jupyter-scala .
```

## Pull

```
docker pull kzmake/jupyter-scala
```

## Support and Migration

特に無し

## License

* [MIT License](http://petitviolet.mit-license.org/)
