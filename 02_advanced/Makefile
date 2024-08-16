COMPOSE = docker compose
DATA_DIR = data

.PHONY: setup
setup: $(DATA_DIR)/duckdb.db $(DATA_DIR)/pg-setup # Setup the environment

$(DATA_DIR)/images-built:
	@echo "Build Docker images"
	@$(COMPOSE) build
	@mkdir -p ./$(DATA_DIR)
	@touch $(DATA_DIR)/images-built

$(DATA_DIR)/duckdb.db: $(DATA_DIR)/images-built
	@echo "Setup TPC-H on DuckDB"
	@$(COMPOSE) run --rm duckdb bash "scripts/generate-tpch-duckdb.sh"

$(DATA_DIR)/pg-started: $(DATA_DIR)/images-built
	@echo "Start live services to run experiments"
	@$(COMPOSE) up postgres -d --wait
	@touch $(DATA_DIR)/pg-started

.PHONY: setup-pg
$(DATA_DIR)/pg-setup: $(DATA_DIR)/pg-started $(DATA_DIR)/duckdb.db
	@echo "Setup TPC-H on PostgreSQL"
	@$(COMPOSE) exec postgres bash "scripts/load-tpch-postgres.sh"
	@touch $(DATA_DIR)/pg-setup


.PHONY: experiments
experiments: $(DATA_DIR)/duckdb.csv $(DATA_DIR)/postgres.csv # Run the experiments

$(DATA_DIR)/postgres.csv: $(DATA_DIR)/pg-setup
	@echo "Run PostgreSQL experiments"
	@$(COMPOSE) exec postgres bash "scripts/run-experiments-postgres.sh"

$(DATA_DIR)/duckdb.csv: $(DATA_DIR)/duckdb.db
	@echo "Run DuckDB experiments"
	@$(COMPOSE) run --rm duckdb bash "scripts/run-experiments-duckdb.sh"


.PHONY: paper
paper: $(DATA_DIR)/paper.pdf # Compile the paper

$(DATA_DIR)/paper.pdf: $(DATA_DIR)/images-built experiments
	@echo "Compile Paper PDF"
	@$(COMPOSE) run --rm latex bash "scripts/build-paper.sh"


.PHONY: clean
clean: clean-docker clean-experiments clean-setup clean-paper # Clean up everything
	@rm -rf $(DATA_DIR)

.PHONY: clean-docker
clean-docker:
	@echo "Stop live services and remove images and volumes"
	@$(COMPOSE) down -v --rmi all
	@rm -rf $(DATA_DIR)/{pg-started,images-built}

.PHONY: clean-setup
clean-setup:
	@echo "Remove all generated experiment data"
	@rm -rf $(DATA_DIR)/{duckdb.db,tables,pg-setup}

.PHONY: clean-experiments
clean-experiments:
	@echo "Remove all generated experiment data"
	@rm -f $(DATA_DIR)/*.csv

.PHONY: clean-paper
clean-paper:
	@echo "Remove generated paper"
	@rm -f $(DATA_DIR)/{paper,texput}.*
