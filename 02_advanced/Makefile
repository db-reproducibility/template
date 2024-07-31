run: # Run the experiments
	@echo "Setup environment to run experiments"
	@docker compose up -d --wait

	@echo "Run PostgreSQL experiments"
	@docker compose exec postgres bash "run-experiments.sh"

	@echo "Run DuckDB experiments"
	@docker compose run --rm duckdb bash "run-experiments-duckdb.sh"

	@echo "Compile Paper PDF"
	@docker compose run --rm latex

clean: # Clean up the environment
	docker compose down -v
