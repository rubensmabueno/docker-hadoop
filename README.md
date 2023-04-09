# Project: Hadoop Docker Image

This is an open-source project that provides a Docker image with Hadoop and JMX Exporter pre-installed. The Docker image is based on OpenJDK 8 and includes Hadoop version 2.10.2.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [License](#license)
- [Contact](#contact)

## Features

- OpenJDK 8 as the base image.
- Hadoop 2.10.2 pre-installed.
- JMX Exporter 0.3.1 pre-installed for monitoring.

## Prerequisites

- Docker installed on your system.

## Installation
There is no need to install the Docker image as it is available on DockerHub. You can download the image using the following command:

```bash
docker pull rubensminoru/hadoop
```

### Building image manually
1. Clone the repository:
```bash
git clone https://github.com/rubensmabueno/docker-hadoop.git
```

2. Build the Docker image:
```bash
cd your-repo
docker build -t your-image-name .
```

## Usage
### Option 1: Using Docker Compose
```yaml
version: '3'

services:
  namenode:
      image: rubensminoru/hadoop
      command: hdfs namenode
      ports:
        - 8020:8020
        - 50070:50070
        - 5556:5556
      environment:
        - HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml
      volumes:
        - "./tmp/namenode:/hadoop/dfs/name"
        - "./config:/etc/hadoop:ro"
        - "./config/jmx-namenode-config.yml:/opt/jmx_prometheus_javaagent/config.yml"
      healthcheck:
        test: [ "CMD-SHELL", "curl --fail http://localhost:50070/ || exit 1" ]
        interval: 30s
        timeout: 10s
        retries: 5
    datanode-1:
      image: rubensminoru/hadoop
      command: hdfs datanode
      ports:
        - 5557:5556
      environment:
        - HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml
      depends_on:
        namenode:
          condition: service_healthy
      volumes:
        - "./tmp/datanode-1:/hadoop/dfs/data"
        - "./config:/etc/hadoop:ro"
        - "./config/jmx-datanode-config.yml:/opt/jmx_prometheus_javaagent/config.yml"
    datanode-2:
      image: rubensminoru/hadoop
      command: hdfs datanode
      ports:
        - 5558:5556
      environment:
        - HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml
      depends_on:
        namenode:
          condition: service_healthy
      volumes:
        - "./tmp/datanode-2:/hadoop/dfs/data"
        - "./config:/etc/hadoop:ro"
        - "./config/jmx-datanode-config.yml:/opt/jmx_prometheus_javaagent/config.yml"
```

### Option 2: Using Docker run

1. Create a NameNode container:
```bash
docker run -d --name namenode -p 5556:5556 -p 50070:50070 -p 8020:8020 \
  -v "$(pwd)/tmp/namenode:/hadoop/dfs/name" \
  -v "$(pwd)/config:/etc/hadoop:ro" \
  -v "$(pwd)/config/jmx-namenode-config.yml:/opt/jmx_prometheus_javaagent/config.yml" \
  -e "HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml" \
  rubensminoru/hadoop hdfs namenode
```

2. Create Datanode containers:
```bash
docker run -d --name datanode-1 -p 5557:5556 \
  -v "$(pwd)/tmp/datanode-1:/hadoop/dfs/data" \
  -v "$(pwd)/config:/etc/hadoop:ro" \
  -v "$(pwd)/config/jmx-datanode-config.yml:/opt/jmx_prometheus_javaagent/config.yml" \
  -e "HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml" \
  --link datanode-1:namenode \
  rubensminoru/hadoop hdfs datanode

docker run -d --name datanode-2 -p 5558:5556 \
  -v "$(pwd)/tmp/datanode-2:/hadoop/dfs/data" \
  -v "$(pwd)/config:/etc/hadoop:ro" \
  -v "$(pwd)/config/jmx-datanode-config.yml:/opt/jmx_prometheus_javaagent/config.yml" \
  -e "HADOOP_OPTS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=5556:/opt/jmx_prometheus_javaagent/config.yml" \
  --link datanode-2:namenode \
  rubensminoru/hadoop hdfs datanode
```

### Accessing
1. Access the Hadoop Web UI:

- NameNode: `http://localhost:50070`

2. Access the JMX Exporter metrics:

```bash
http://localhost:5556/metrics
```

## Configuration
- To customize the JMX Exporter configuration, edit the `JMX_PROMETHEUS_JAVAAGENT_CONFIG` environment variable in the Dockerfile.
- To configure Hadoop, you can modify the Hadoop configuration files located in `/etc/hadoop` within the container.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
- Maintainer: Rubens Minoru Andako Bueno
- Email: rubensmabueno@hotmail.com
- Feel free to reach out for any questions, issues, or contributions.
