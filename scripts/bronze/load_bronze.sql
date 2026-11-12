/*
===============================================================================
Stored Procedure: Load Bronze Layer
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from csv Files to bronze tables.

Notes:
    - COPY reads the files on the database server's machine, so base_path must be
      a folder the PostgreSQL server can read.
    - The user running it needs superuser rights or the pg_read_server_files role.
    - If the server can't read your files, load them from psql with \copy instead.

Usage Example:
    CALL bronze.load_bronze();
    CALL bronze.load_bronze('/path/to/datasets');
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze(
    base_path TEXT DEFAULT 'C:/Users/Sonic/Programing/Data Warehouse Project/sql-data-warehouse-project-main/datasets'
)
LANGUAGE plpgsql
AS $$
DECLARE
    start_time       TIMESTAMP;
    end_time         TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time   TIMESTAMP;
BEGIN
    batch_start_time := clock_timestamp();
    RAISE NOTICE '==================================';
    RAISE NOTICE 'Loading the CRM Layer';
    RAISE NOTICE '==================================';

    RAISE NOTICE 'Table crm_cust_info';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_cust_info;
    EXECUTE format(
        'COPY bronze.crm_cust_info FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_crm/cust_info.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);
    RAISE NOTICE '----------------------------------';

    RAISE NOTICE 'Table crm_prd_info';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;
    EXECUTE format(
        'COPY bronze.crm_prd_info FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_crm/prd_info.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);
    RAISE NOTICE '----------------------------------';

    RAISE NOTICE 'Table crm_sales_details';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;
    EXECUTE format(
        'COPY bronze.crm_sales_details FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_crm/sales_details.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    RAISE NOTICE '==================================';
    RAISE NOTICE 'Loading the ERP Layer';
    RAISE NOTICE '==================================';

    RAISE NOTICE 'Table erp_cust_az12';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;
    EXECUTE format(
        'COPY bronze.erp_cust_az12 FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_erp/cust_az12.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);
    RAISE NOTICE '----------------------------------';

    RAISE NOTICE 'Table erp_loc_a101';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;
    EXECUTE format(
        'COPY bronze.erp_loc_a101 FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_erp/loc_a101.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);
    RAISE NOTICE '----------------------------------';

    RAISE NOTICE 'Table erp_px_cat_g1v2';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    EXECUTE format(
        'COPY bronze.erp_px_cat_g1v2 FROM %L WITH (FORMAT csv, HEADER true)',
        base_path || '/source_erp/px_cat_g1v2.csv'
    );
    end_time := clock_timestamp();
    RAISE NOTICE '>> Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    batch_end_time := clock_timestamp();
    RAISE NOTICE '==================================';
    RAISE NOTICE '>> Total loading duration for bronze layer: % seconds',
        EXTRACT(EPOCH FROM batch_end_time - batch_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE '==========================================';
END;
$$;
