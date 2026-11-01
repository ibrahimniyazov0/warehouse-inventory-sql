-- Warehouse Inventory Database: tables for products, stock per location, and stock movement history.

create database WarehouseDB
go
use WarehouseDB
go
create schema WH
go

create table WH.Products ( 
ProductID int identity (1, 1)  constraint PK_Products_ProductID primary key,
ProductName nvarchar(100) not null,
CreatedDate date not null default(getdate())
)

create table WH.Stock (
StockID int identity (1, 1) constraint PK_Stock_StockID primary key,
ProductID int not null constraint FK_Stock_Products references WH.Products (ProductID),
Location nvarchar(50) not null constraint CK_Stock_Location check (Location in ('Baku', 'Ganja', 'Absheron')),
Quantity int not null default (0) constraint CK_Stock_Quantity check (Quantity >= 0),
CreatedDate date not null default(getdate())
)

create table WH.StockMovements (
MovementID int identity (1,1) constraint PK_StockMovements_MovementID primary key,
StockID int not null constraint FK_StockMovements_Stock references WH.Stock (StockID),
MovementType nvarchar (20) not null constraint CK_StockMovements_Type check (MovementType in ('In', 'Out')),
Quantity int not null  constraint CK_StockMovements_Quantity check (Quantity > 0),
MovementDate datetime not null default(getdate())
)
