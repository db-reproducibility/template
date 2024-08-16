COMPOSE = docker compose

.PHONY: docker
docker: data/docker/images-built data/docker/pg-started # Build and start Docker services

data/docker/images-built:
	@echo "Build Docker images"
	@$(COMPOSE) build
	@mkdir -p ./data
	@mkdir -p ./data/docker
	@touch data/docker/images-built
	@echo

data/docker/pg-started: data/docker/images-built
	@echo "Start live services to run experiments"
	@$(COMPOSE) up postgres -d --wait
	@touch data/docker/pg-started
	@echo


.PHONY: setup
setup: data/setup/duckdb.db data/setup/pg-setup # Setup the environment

data/setup/duckdb.db: data/docker/images-built
	@echo "Setup TPC-H on DuckDB"
	@$(COMPOSE) run --rm duckdb bash "scripts/generate-tpch-duckdb.sh"
	@echo

.PHONY: setup-pg
data/setup/pg-setup: data/docker/pg-started data/setup/duckdb.db
	@echo "Setup TPC-H on PostgreSQL"
	@$(COMPOSE) exec postgres bash "scripts/load-tpch-postgres.sh"
	@touch data/setup/pg-setup
	@echo


.PHONY: experiments
experiments: data/results/duckdb.csv data/results/postgres.csv # Run the experiments

data/results/postgres.csv: data/setup/pg-setup
	@echo "Run PostgreSQL experiments"
	@$(COMPOSE) exec postgres bash "scripts/run-experiments-postgres.sh"
	@echo

data/results/duckdb.csv: data/setup/duckdb.db
	@echo "Run DuckDB experiments"
	@$(COMPOSE) run --rm duckdb bash "scripts/run-experiments-duckdb.sh"
	@echo


.PHONY: paper
paper: data/paper/paper.pdf # Compile the paper

data/paper/paper.pdf: experiments
	@echo "Compile Paper PDF"
	@$(COMPOSE) run --rm latex bash "scripts/build-paper.sh"
	@echo


.PHONY: clean
clean: clean-docker clean-experiments clean-setup clean-paper # Clean up everything
	@rm -rf data

.PHONY: clean-docker
clean-docker:
	@echo "Stop live services and remove images and volumes"
	@$(COMPOSE) down -v --rmi all
	@rm -rf data/docker

.PHONY: clean-setup
clean-setup:
	@echo "Remove all generated experiment data"
	@rm -rf data/setup/

.PHONY: clean-experiments
clean-experiments:
	@echo "Remove all generated experiment data"
	@rm -rf data/results

.PHONY: clean-paper
clean-paper:
	@echo "Remove generated paper"
	@rm -rf data/paper
