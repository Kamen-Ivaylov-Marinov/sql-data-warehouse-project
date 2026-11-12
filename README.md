# sql-data-warehouse-project
Building a data warehouse with PostgreSQL, including ETL processes, data modeling and analytics

## How to run

Run the scripts in this order with `psql`:

1. `scripts/init_database.sql` (creates the `datawarehouse` database and the `bronze`, `silver` and `gold` schemas)
2. `scripts/bronze/ddl_bronze.sql`
3. `scripts/bronze/load_bronze.sql`, then `CALL bronze.load_bronze('/path/to/datasets');`
4. `scripts/silver/ddl_silver.sql`
5. `scripts/silver/clean_tb_silver_cust_info.sql`, then `CALL silver.load_silver();`
6. `scripts/silver/clean_tb_silver_crm_prd_info.sql`

`COPY` reads the CSV files on the database server, so the folder passed to `bronze.load_bronze` must be readable by PostgreSQL.
