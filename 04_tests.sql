-- Tests for stock procedures. Run on a fresh database (files 01-03 first).

use WarehouseDB
go

-- AddStock: success
exec WH.AddStock @StockID = 1, @Quantity = 20
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 quantity = 120; StockMovements has 1 row (StockID 1, 'In', 20)
go


-- AddStock: error, quantity is 0
exec WH.AddStock @StockID = 1, @Quantity = 0
-- expected error: throw 50005, 'Quantity must be greater than 0'
go


-- AddStock: error, Stock ID does not exist
exec WH.AddStock @StockID = 999, @Quantity = 20
-- expected error: throw 50006, 'Stock ID does not exist'
go

-- AddStock: verify nothing was written by the failed calls
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 quantity is still 120; StockMovements still has only 1 row
go


-- RemoveStock: success
exec WH.RemoveStock @StockID = 1, @Quantity = 10
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 quantity = 110; StockMovements has 2 rows (both StockID 1: 'In' 20 from AddStock, 'Out' 10 from this call)
go

-- RemoveStock: error, quantity is 0
exec WH.RemoveStock @StockID = 1, @Quantity = 0
-- expected error: throw 50007, 'Quantity must be greater than 0'
go

-- RemoveStock: error, Stock ID does not exist
exec WH.RemoveStock @StockID = 999, @Quantity = 10
-- expected error: throw 50008, 'Stock ID does not exist'
go

-- RemoveStock: error, not enough stock available
exec WH.RemoveStock @StockID = 1, @Quantity = 9999
-- expected error: throw 50009, 'Not enough stock available'
go

-- RemoveStock: verify nothing was written by the failed calls
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 quantity is still 110; StockMovements still has 2 rows
go


-- MoveStock: success
exec WH.MoveStock @FromStockID = 1, @ToStockID = 2, @Quantity = 30
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 = 80, Stock 2 = 80; StockMovements has 4 rows:
--   1: StockID 1, 'In', 20 (AddStock)
--   2: StockID 1, 'Out', 10 (RemoveStock)
--   3: StockID 2, 'In', 30 (MoveStock, destination)
--   4: StockID 1, 'Out', 30 (MoveStock, source)
go

-- MoveStock: error, quantity is 0
exec WH.MoveStock @FromStockID = 1, @ToStockID = 2, @Quantity = 0
-- expected error: throw 50010, 'Quantity must be greater than 0'
go

-- MoveStock: error, same source and destination
exec WH.MoveStock @FromStockID = 1, @ToStockID = 1, @Quantity = 10
-- expected error: throw 50011, 'Source and destination stock must be different'
go

-- MoveStock: error, Destination stock ID does not exist
exec WH.MoveStock @FromStockID = 1, @ToStockID = 999, @Quantity = 10
-- expected error: throw 50012, 'Destination stock ID does not exist'
go

-- MoveStock: error, Source stock ID does not exist
exec WH.MoveStock @FromStockID = 999, @ToStockID = 2, @Quantity = 10
-- expected error: throw 50014, 'Source stock ID does not exist'
go

-- MoveStock: error, Cannot move stock between different products
exec WH.MoveStock @FromStockID = 1, @ToStockID = 3, @Quantity = 10
-- expected error: throw 50013, 'Cannot move stock between different products'
go

-- MoveStock: error, Not enough stock available
exec WH.MoveStock @FromStockID = 1, @ToStockID = 2, @Quantity = 9999
-- expected error: throw 50015, 'Not enough stock available'
go

-- MoveStock: verify nothing was written by the failed calls
select * from WH.Stock
select * from WH.StockMovements
-- expected: Stock 1 = 80, Stock 2 = 80; StockMovements has 4 rows:
--   1: StockID 1, 'In', 20 (AddStock)
--   2: StockID 1, 'Out', 10 (RemoveStock)
--   3: StockID 2, 'In', 30 (MoveStock, destination)
--   4: StockID 1, 'Out', 30 (MoveStock, source)
go









































