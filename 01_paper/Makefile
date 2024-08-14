run: # Run the experiments
	@echo "Start live services to run experiments"
	@docker compose up postgres -d --wait
	@echo

	@echo "Setup TPC-H on DuckDB"
	@docker compose run --rm duckdb bash "scripts/generate-tpch-duckdb.sh"
	@echo

	@echo "Setup TPC-H on PostgreSQL"
	@docker compose exec postgres bash "scripts/load-tpch-postgres.sh"
	@echo

	@echo "Run DuckDB experiments"
	@docker compose run --rm duckdb bash "scripts/run-experiments-duckdb.sh"
	@echo

	@echo "Run PostgreSQL experiments"
	@docker compose exec postgres bash "scripts/run-experiments-postgres.sh"

clean: # Clean up the environment
	docker compose down -v
	rm -rf data/{queries,tables,duckdb.db}
