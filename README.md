# Warehouse Inventory Database

A warehouse inventory database written in SQL Server (T-SQL). It stores products, stock quantities per location and a history of stock movements. Stored procedures change quantities safely using transactions.

## Files

- `01_tables.sql`: creates the database, the WH schema and 3 tables (Products, Stock, StockMovements)
- `02_sample_data.sql`: adds 3 products and 4 stock rows for testing
- `03_procedures.sql`: creates 3 procedures (AddStock, RemoveStock, MoveStock)
- `04_tests.sql`: checks success and error cases, with expected results in comments

## How to run

Run files 01 to 04 in order on an empty SQL Server instance.

## Stored procedures

- `WH.AddStock`: increases the stock quantity and logs an 'In' movement.
- `WH.RemoveStock`: decreases the stock quantity and logs an 'Out' movement.
- `WH.MoveStock`: moves quantity between two stock rows of the same product and logs an 'Out' movement for the source and an 'In' movement for the destination.

## What this project demonstrates

- Constraints (PK, FK, CHECK, DEFAULT, NOT NULL)
- Transactions (COMMIT and ROLLBACK)
- Error handling (TRY...CATCH and THROW)
- Test scripts with expected results in comments
