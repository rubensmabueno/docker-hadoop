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

1. Clone the repository:
```bash
git clone https://github.com/your-username/your-repo.git
```

2. Build the Docker image:
```bash
cd your-repo
docker build -t your-image-name .
```

## Usage
1. Create a Hadoop container:
```bash
docker run -d --name your-container-name -p 5556:5556 -p 50070:50070 -p 8088:8088 your-image-name
```

2. Access the Hadoop Web UI:

- NameNode: `http://localhost:50070`
- ResourceManager: `http://localhost:8088`

3. Access the JMX Exporter metrics:

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
