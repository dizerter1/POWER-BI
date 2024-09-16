-- Yangi ma'lumotlar bazasini yaratish
CREATE DATABASE SalesDataAnalysisDB;
GO

-- Yangi jadval yaratish
USE SalesDataAnalysisDB;
GO

CREATE TABLE SalesData (
    SubTotal DECIMAL(18, 2),              -- Soliqlardan oldingi jami
    TaxAmt DECIMAL(18, 2),                -- Soliq summasi
    Freight DECIMAL(18, 2),               -- Yuk tashish to'lovi
    OrderDate DATE,                       -- Buyurtma sanasi
    Quantity INT,                         -- Buyurtma miqdori
    UnitPrice DECIMAL(18, 2),             -- Bir birlik mahsulot narxi
    CustomerType NVARCHAR(50),            -- Mijoz turi (do'kon yoki individual)
    RegionName NVARCHAR(50),              -- Mintaqa nomi
    StoreID INT,                          -- Do'kon identifikatori
    StandardCost DECIMAL(18, 2),          -- Mahsulot ishlab chiqarish narxi
    ProfitMargin DECIMAL(18, 2),          -- Foyda marjasi
    SalesTerritoryID INT,                 -- Sotuv hududi identifikatori
    ShipMethodID INT,                     -- Yetkazib berish usuli identifikatori
    TotalDue DECIMAL(18, 2),              -- Jami to'lanishi kerak bo'lgan summa
    ProductName NVARCHAR(255),            -- Mahsulot nomi
    ProductCategory NVARCHAR(255),        -- Mahsulot kategoriyasi
    OrderQty INT,                         -- Buyurtma miqdori
    Season NVARCHAR(10),                  -- Fasl
    Year INT                              -- Yil
);
GO

-- Ma'lumotlarni nusxalash
INSERT INTO SalesData (SubTotal, TaxAmt, Freight, OrderDate, Quantity, UnitPrice, CustomerType, RegionName, StoreID, StandardCost, ProfitMargin, SalesTerritoryID, ShipMethodID, TotalDue, ProductName, ProductCategory, OrderQty, Season, Year)
SELECT
    soh.SubTotal,                         -- Soliqlardan oldingi jami
    soh.TaxAmt,                           -- Soliq summasi
    soh.Freight,                          -- Yuk tashish to'lovi
    soh.OrderDate,                        -- Buyurtma sanasi
    sod.OrderQty AS Quantity,             -- Buyurtma miqdori
    sod.UnitPrice,                        -- Bir birlik mahsulot narxi
    CASE
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        ELSE 'Individual'
    END AS CustomerType,                  -- Mijoz turi (do'kon yoki individual)
    st.Name AS RegionName,                -- Mintaqa nomi
    c.StoreID,                            -- Do'kon identifikatori
    p.StandardCost,                       -- Mahsulot ishlab chiqarish narxi
    (sod.UnitPrice - p.StandardCost) AS ProfitMargin,  -- Foyda marjasi
    soh.TerritoryID AS SalesTerritoryID,  -- Sotuv hududi identifikatori
    soh.ShipMethodID,                     -- Yetkazib berish usuli identifikatori
    soh.TotalDue,                         -- Jami to'lanishi kerak bo'lgan summa
    p.Name AS ProductName,                -- Mahsulot nomi
    pc.Name AS ProductCategory,           -- Mahsulot kategoriyasi
    sod.OrderQty,                         -- Buyurtma miqdori
    CASE
        WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(soh.OrderDate) IN (9, 10, 11) THEN 'Autumn'
    END AS Season,                        -- Fasl
    YEAR(soh.OrderDate) AS Year           -- Yil
FROM
    AdventureWorks2022.Sales.SalesOrderHeader soh
JOIN
    AdventureWorks2022.Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN
    AdventureWorks2022.Production.Product p ON sod.ProductID = p.ProductID
JOIN
    AdventureWorks2022.Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN
    AdventureWorks2022.Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN
    AdventureWorks2022.Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN
    AdventureWorks2022.Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID;
