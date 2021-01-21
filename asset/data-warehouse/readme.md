## Overview
This resource includes a Data Warehouse which is established to implement the effective analysis for the customers' data from FreshOrganic. Here is the step‐by‐step instructions to operate the resource and build a Data Warehouse with INLJ algorithm in Star-Schema model. SQL Developer is required to support this model. 
## Preparations
Construct the PLSQL environment. Connect the database to Oracle2 server. An alternate way to connect can refer to the following example.
![figure 1](https://user-images.githubusercontent.com/11970319/67135196-b8607200-f273-11e9-94e2-4a3de4bb6c68.png)
## Step 1. Import data
Run the provided sql script 'Transaction_and_MasterData_Generator.sql' to import the transactions data and the master data which is required to join the data source to achieve ETL.
## Step 2. Create the Data Warehouse
Run the sql script 'createDW.sql' to create the data warehouse in star schema.
## Step 3. Implement the INLJ algorithm 
Run the sql file 'INLJ.sql' to implement the INLJ algorithm.
## Step 4. OLAP queries
Run the sql script 'queriesDW.sql' to implement query statement in order to achieve OLAP analytical operations.
