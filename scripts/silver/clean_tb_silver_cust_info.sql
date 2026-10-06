/*
This query cleans all the firstname/lastname trailing spaces.
We changed the gender and martial status convensiton to something more appropriate
*/

TRUNCATE TABLE silver.crm_cust_info;
PRINT 'Inserting data to silver.crm_cust_info';
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gndr,
	cst_create_date
)
SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE
		WHEN UPPER(cst_material_status) = 'S' THEN 'Single'
		WHEN UPPER(cst_material_status) = 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_material_status,
	CASE
		WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gnr,
	cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id  IS NOT NULL
	) t
WHERE flag_last = 1;


/*
--TESTS
--Check for duplicates in primary key
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data standardization & consistency
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT
	cst_material_status
FROM silver.crm_cust_info;
*/
