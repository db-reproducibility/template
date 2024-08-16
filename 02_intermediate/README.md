# Overview
This repository contains the artifacts for the tutorial "A Reproducible Tutorial
on Reproducibility in Database Systems Research".

## Software Requirements
The artifact requires Make, Docker and Docker Compose.

## Hardware Requirements
At least 4GB of memory and 2 CPU cores are required.

## Time Requirements
* Getting Started: 5 minutes
* Building the Docker image: ~20 minutes
* Running the experiments: ~5 minutes

## Reproducibility
To reproduce the experiments, follow these steps:
* Clone the repository
* In a terminal, navigate to the repository and run the following command:
  ```bash
  ./run.sh
  ```
* The experiments will run and the results will be stored in the `data` directory.
* The paper PDF will be built using the new experimental results and stored in the `data` directory.

## Cleanup
To cleanup, run the following command:
```bash
rm -r data
```
