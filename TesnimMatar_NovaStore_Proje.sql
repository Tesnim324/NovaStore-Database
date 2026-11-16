CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO

-- BOLUM 1: VERI TABANI TASARIMI
-- Gorev 1: Categories tablosunu olusturma

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

-- Gorev 2: Products tablosunu olusturma

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Gorev 3: Customers tablosunu olusturma

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

-- Gorev 4: Orders tablosu

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Gorev 5: OrderDetails tablosu

CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO


-- BOLUM 2: VERI GIRISI
-- Gorev 1: Kategoriler

INSERT INTO Categories (CategoryName)
VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yasam');
GO

-- Gorev 2: Urunler

INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES
('Laptop', 25000, 15, 1),
('Telefon', 18000, 30, 1),
('Kulaklik', 1500, 50, 1),
('Klavye', 900, 25, 1),
('Mouse', 600, 40, 1),
('Tisort', 400, 80, 2),
('Pantolon', 1200, 35, 2),
('Roman', 250, 100, 3),
('SQL Kitabi', 450, 20, 3),
('Parfum', 2000, 18, 4),
('Ruj', 350, 60, 4),
('Masa Lambasi', 850, 12, 5);
GO

-- Gorev 3: Musteriler

INSERT INTO Customers (FullName, City, Email)
VALUES
('Ahmet Yilmaz', 'Istanbul', 'ahmet@example.com'),
('Ayse Demir', 'Ankara', 'ayse@example.com'),
('Mehmet Kaya', 'Izmir', 'mehmet@example.com'),
('Zeynep Celik', 'Bursa', 'zeynep@example.com'),
('Ali Can', 'Antalya', 'ali@example.com'),
('Elif Arslan', 'Istanbul', 'elif@example.com');
GO

-- Gorev 4: Siparisler

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2026-10-01', 26500),
(2, '2026-10-03', 1600),
(3, '2026-10-05', 18000),
(4, '2026-10-07', 2000),
(5, '2026-10-10', 850),
(6, '2026-10-12', 1200),
(1, '2026-10-15', 700),
(2, '2026-10-18', 1500),
(3, '2026-10-20', 25000),
(4, '2026-10-25', 350);
GO

-- Siparis detaylari

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1),
(1, 3, 1),
(2, 6, 4),
(3, 2, 1),
(4, 10, 1),
(5, 12, 1),
(6, 7, 1),
(7, 8, 1),
(7, 9, 1),
(8, 3, 1),
(9, 1, 1),
(10, 11, 1);
GO


-- BOLUM 3
-- SORGU 1
-- Stogu 20'den az olan urunler

SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock ASC;

-- SORGU 2
-- Musteri adi, sehir, siparis tarihi ve toplam tutar

SELECT
    Customers.FullName,
    Customers.City,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID;

-- SORGU 3
-- Coklu JOIN ile detay raporu

SELECT
    c.FullName,
    p.ProductName,
    p.Price,
    cat.CategoryName
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID
INNER JOIN Categories cat
    ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Ahmet Yilmaz';

-- SORGU 4
-- GROUP BY, COUNT ve LEFT JOIN

SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p
    ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- SORGU 5
-- Musterilerin toplam cirosu

SELECT
    c.FullName,
    SUM(o.TotalAmount) AS TotalRevenue
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY TotalRevenue DESC;

-- SORGU 6
-- DATEDIFF ve GETDATE

SELECT
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysPassed
FROM Orders;

-- BOLUM 4
-- GOREV 1
-- Siparis ozeti VIEW

GO

-- BOLUM 4: 
-- GOREV 1
-- Siparis ozeti VIEW

CREATE VIEW vw_SiparisOzet AS
SELECT
    c.FullName AS CustomerName,
    o.OrderDate,
    p.ProductName,
    od.Quantity
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
INNER JOIN Products p
    ON od.ProductID = p.ProductID;
GO

SELECT * FROM vw_SiparisOzet;
GO

-- GOREV 2
-- NovaStoreDB yedekleme

BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH INIT;
GO