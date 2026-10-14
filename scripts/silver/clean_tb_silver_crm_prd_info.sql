/*
Clean the tb silver.crm_prd_info
*/

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS product_id,
	prd_key,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other Sales'
		 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		 ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	DATEADD(day,-1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM bronze.crm_prd_info;

---------------------------------------------------------- TEST
-- Check for duplicates or NULL in primary key
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING	COUNT(*) > 1 OR prd_id IS NULL;
---------------------------------------------------------
-- Check the category id, conclution -> CO_PE category does not exist in the dataset
SELECT
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') NOT IN (SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2);


------------------------------------------------------------
--Check prd_nm if we have unwanted spaces
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

------------------------------------------------------------
-- Check if prd_cost has negative values or NULL. Here we have found orders that are = NULL, we can replace the NULL with 0
SELECT
	ISNULL(prd_cost, 0) AS prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
------------------------------------------------------------
-- Check for ivalid date order
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Load the table
SELECT *
FROM silver.crm_prd_info;
