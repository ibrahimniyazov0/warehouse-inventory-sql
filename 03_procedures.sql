-- Stored procedures for stock operations: AddStock, RemoveStock, MoveStock

use WarehouseDB
go

-- AddStock: increases stock quantity and logs an 'In' movement.
-- Parameters: @StockID, @Quantity.
-- Errors: 50005 (quantity <= 0), 50006 (stock not found).
create procedure WH.AddStock
@StockID int, @Quantity int
as begin
	begin try
		begin tran
		if (@Quantity <= 0)
			throw 50005, 'Quantity must be greater than 0', 1;
		if not exists (select 1 from WH.Stock where StockID = @StockID)
			throw 50006, 'Stock ID does not exist', 1;
		insert into WH.StockMovements (StockID, MovementType, Quantity)
		values (@StockID, 'In', @Quantity)
		update WH.Stock
		set Quantity = Quantity + @Quantity
		where StockID = @StockID
		commit
	end try
	begin catch
		rollback;
		throw;
	end catch
end
go

-- RemoveStock: decreases stock quantity and logs an 'Out' movement.
-- Parameters: @StockID, @Quantity.
-- Errors: 50007 (quantity <= 0), 50008 (stock not found), 50009 (not enough stock).
create procedure WH.RemoveStock
@StockID int, @Quantity int
as begin
	begin try
		begin tran
		if @Quantity <= 0
			throw 50007, 'Quantity must be greater than 0', 1;
		if not exists (select 1 from WH.Stock where StockID = @StockID)
			throw 50008, 'Stock ID does not exist', 1;
		if (select Quantity from WH.Stock where StockID = @StockID) < @Quantity
			throw 50009, 'Not enough stock available', 1;
		insert into WH.StockMovements (StockID, MovementType, Quantity)
		values (@StockID, 'Out', @Quantity)
		update WH.Stock
		set Quantity = Quantity - @Quantity
		where StockID = @StockID
		commit
	end try
	begin catch
		rollback;
		throw;
	end catch
end
go

-- MoveStock: moves quantity between two stock rows of the same product and logs 'Out' and 'In' movements.
-- Parameters: @FromStockID, @ToStockID, @Quantity.
-- Errors: 50010 (quantity <= 0), 50011 (same stock), 50012 (destination not found), 50013 (different products), 50014 (source not found), 50015 (not enough stock).
create procedure WH.MoveStock
@FromStockID int, @ToStockID int, @Quantity int
as begin
	begin try
		begin tran
		if @Quantity <= 0
			throw 50010, 'Quantity must be greater than 0', 1;
		if @FromStockID = @ToStockID
			throw 50011, 'Source and destination stock must be different', 1;
		if not exists (select 1 from WH.Stock where StockID = @ToStockID) 
			throw 50012, 'Destination stock ID does not exist', 1;
		if not exists (select 1 from WH.Stock where StockID = @FromStockID)
			throw 50014, 'Source stock ID does not exist', 1;
		if (select ProductID from WH.Stock where StockID = @ToStockID) != (select ProductID from WH.Stock where StockID = @FromStockID)
			throw 50013, 'Cannot move stock between different products', 1;
		if (select Quantity from WH.Stock where StockID = @FromStockID) < @Quantity
			throw 50015, 'Not enough stock available', 1;
		insert into WH.StockMovements (StockID, MovementType, Quantity)
		values (@ToStockID, 'In', @Quantity)
		insert into WH.StockMovements (StockID, MovementType, Quantity)
		values (@FromStockID, 'Out', @Quantity)
		update WH.Stock
		set Quantity = Quantity - @Quantity
		where StockID = @FromStockID
		update WH.Stock
		set Quantity = Quantity + @Quantity
		where StockID = @ToStockID
		commit
	end try
	begin catch
		rollback;
		throw;
	end catch
end
go