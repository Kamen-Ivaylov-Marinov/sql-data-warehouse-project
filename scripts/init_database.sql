/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'datawarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

How to run:
    Run it with psql while connected to another database (for example 'postgres'):
        psql -U postgres -d postgres -f scripts/init_database.sql
    The '\c' line is a psql command, so in pgAdmin or DBeaver run the first part,
    connect to 'datawarehouse' manually, then run the CREATE SCHEMA part.

WARNING:
    Running this script will drop the entire 'datawarehouse' database if it exists.
    All data in the database will be permanently deleted.
*/

-- Drop and recreate the 'datawarehouse' database
-- WITH (FORCE) disconnects other sessions first (PostgreSQL 13+)
DROP DATABASE IF EXISTS datawarehouse WITH (FORCE);

-- Create the 'datawarehouse' database
CREATE DATABASE datawarehouse;

-- Connect to the new database
\c datawarehouse

-- Create Schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
