-- Sample data: 3 products and 4 stock rows (one product in two locations, one with zero quantity).

use WarehouseDB
go

insert into WH.Products (ProductName)
values ('Laptop Lenovo'),
('Mobile Phone Samsung'),
('Headphones Sony')

insert into WH.Stock (ProductID, Location, Quantity)
values (1, 'Baku', 100),
(1, 'Ganja', 50),
(2, 'Baku', 200)

insert into WH.Stock (ProductID, Location)
values (3, 'Absheron') -- Quantity is omitted on purpose: DEFAULT sets it to 0