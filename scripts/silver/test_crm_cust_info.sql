-- TESTS for silver.crm_cust_info table

SELECT *
FROM silver.crm_cust_info;


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
