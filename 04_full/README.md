# Encapsulate `03_advanced` in Docker

This folder contains the Dockerfile and the necessary files to encapsulate the
`03_advanced` project in a Docker container. The Dockerfile is based on the
`docker:27-dind` image, which is a Docker-in-Docker image that allows running
Docker commands inside a Docker container.

This setup is useful for running the `03_advanced` project in a controlled
environment, without the need to install all the dependencies on the host
machine. The Docker container encapsulates all the dependencies and the project
itself, making it easy to run the project on any machine that has Docker
installed.

## Building the Docker image

To build the Docker image, run the following command:

```bash
docker compose build
```

## Running the Docker container

To run the Docker container, run the following command:

```bash
docker compose up -d
```

## Accessing the Docker container

To access the Docker container, run the following command:

```bash
docker compose exec runner sh
```

## Stopping the Docker container

To stop the Docker container, run the following command:

```bash
docker compose down
```
