
USE AdventureWorksDashboards;
GO

CREATE TABLE SalesDashboard (
    SubTotal DECIMAL(19,4),
    TaxAmt DECIMAL(19,4),
    Freight DECIMAL(19,4),
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(19,4),
    CustomerType NVARCHAR(50),
    RegionName NVARCHAR(50),
    StoreID INT,
    StandardCost DECIMAL(19,4),
    ProfitMargin AS (UnitPrice - StandardCost),
    SalesTerritoryID INT,
    ShipMethodID INT,
    TotalDue DECIMAL(19,4),
    ProductName NVARCHAR(100),
    ProductCategory NVARCHAR(50),
    OrderQty INT,
    Year INT,
    Season NVARCHAR(10),
    ListPrice DECIMAL(19,4),
    Color NVARCHAR(15),
    Size NVARCHAR(5),
    Weight DECIMAL(8, 2),
    Class NVARCHAR(2),
    Style NVARCHAR(2),
    CustomerID INT,
    TerritoryName NVARCHAR(50),
    StateProvinceID INT,
    SalesPersonID INT,
    CurrencyRateID INT,
    AddressLine1 NVARCHAR(60),
    AddressLine2 NVARCHAR(60),
    City NVARCHAR(30),
    PostalCode NVARCHAR(15),
    SalesOrderNumber NVARCHAR(25),
    PurchaseOrderNumber NVARCHAR(25),
    ShipDate DATE
);

-- Ma'lumotlarni AdventureWorks2022 dan ko'chirish
INSERT INTO SalesDashboard (SubTotal, TaxAmt, Freight, OrderDate, Quantity, UnitPrice, CustomerType, RegionName, StoreID, StandardCost, SalesTerritoryID, ShipMethodID, TotalDue, ProductName, ProductCategory, OrderQty, Year, Season, ListPrice, Color, Size, Weight, Class, Style, CustomerID, TerritoryName, StateProvinceID, SalesPersonID, CurrencyRateID, AddressLine1, AddressLine2, City, PostalCode, SalesOrderNumber, PurchaseOrderNumber, ShipDate)
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
    soh.TerritoryID AS SalesTerritoryID,  -- Sotuv hududi identifikatori
    soh.ShipMethodID,                     -- Yetkazib berish usuli identifikatori
    soh.TotalDue,                         -- Jami to'lanishi kerak bo'lgan summa
    p.Name AS ProductName,                -- Mahsulot nomi
    pc.Name AS ProductCategory,           -- Mahsulot kategoriyasi
    sod.OrderQty,                         -- Buyurtma miqdori
    YEAR(soh.OrderDate) AS Year,          -- Yil
    CASE                                  -- Faslni aniqlash
        WHEN MONTH(soh.OrderDate) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(soh.OrderDate) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(soh.OrderDate) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(soh.OrderDate) IN (9, 10, 11) THEN 'Autumn'
    END AS Season,                        -- Fasl
    p.ListPrice,                          -- Mahsulotning narxi (listprice)
    p.Color,                              -- Rang
    p.Size,                               -- Hajm
    p.Weight,                             -- Og'irlik
    p.Class,                              -- Sinf (class)
    p.Style,                              -- Uslub (style)
    soh.CustomerID,                       -- Mijoz identifikatori
    st.Name AS TerritoryName,             -- Sotuv hududi nomi
    a.StateProvinceID,                    -- Mintaqa kodi
    soh.SalesPersonID,                    -- Sotuvchi identifikatori
    soh.CurrencyRateID,                   -- Valyuta kursi identifikatori
    a.AddressLine1,                       -- Manzil 1-qator
    a.AddressLine2,                       -- Manzil 2-qator
    a.City,                               -- Shahar
    a.PostalCode,                         -- Pochta indeksi
    soh.SalesOrderNumber,                 -- Buyurtma raqami
    soh.PurchaseOrderNumber,              -- Xarid buyurtma raqami
    soh.ShipDate                         -- Yetkazib berish sanasi
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
    AdventureWorks2022.Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN
    AdventureWorks2022.Person.Address a ON soh.ShipToAddressID = a.AddressID;
GO
