/*
=============================================================
Create Database and Schemas
=============================================================
Purpose:
    Sets up the 'DataWarehouse' database and the three layers of a
    medallion architecture: bronze, silver and gold.

What this script does:
    1. Switches to 'master' and creates 'DataWarehouse' if it does
       not already exist.
    2. Switches to 'DataWarehouse'.
    3. Creates the schemas 'bronze' (raw data), 'silver' (cleaned
       data) and 'gold' (business-ready data), each only if it
       does not already exist.

Notes:
    - Safe to rerun: existing objects are skipped, not recreated or dropped.
    - GO separates batches. CREATE SCHEMA must be the first statement in
      its batch, so it is wrapped in EXEC('...') inside the IF checks.
    - GO is understood by SSMS, Azure Data Studio and sqlcmd, not by
      drivers such as pyodbc.

Created: 2026-11-17
=============================================================
*/

USE master;
GO

-- Create the database only if it does not exist yet
IF DB_ID('DataWarehouse') IS NULL
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT 'Database DataWarehouse created.';
END
ELSE
    PRINT 'Database DataWarehouse already exists, skipped.';
GO

USE DataWarehouse;
GO

-- Bronze layer: raw data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schema bronze created.';
END
ELSE
    PRINT 'Schema bronze already exists, skipped.';
GO

-- Silver layer: cleaned and standardized data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema silver created.';
END
ELSE
    PRINT 'Schema silver already exists, skipped.';
GO

-- Gold layer: business-ready data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schema gold created.';
END
ELSE
    PRINT 'Schema gold already exists, skipped.';
GO
