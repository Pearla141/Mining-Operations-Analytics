-- TABLE CREATION
-- 1. Products
CREATE TABLE  dim_products (
Product_ID INT PRIMARY KEY IDENTITY (1,1),
Product NVARCHAR(50),
Current_Price_Ton FLOAT
);
INSERT INTO dim_products (Product,Current_Price_Ton)
VALUES
('5/8',14100),
('3/8',12000),
('1/2',13000),
('Stone dust', 4500),
('Stone base', 8000),
('Hard core', 10000),
('Lumps', 10000);

-- 2. Operators
CREATE TABLE dim_operators (
Operator_ID INT PRIMARY KEY IDENTITY (1,1),
Operator_Name NVARCHAR (50) 
);
INSERT INTO dim_operators (Operator_Name)
SELECT DISTINCT Operator
FROM fact_transaction
WHERE Operator IS NOT NULL
ORDER BY Operator;

-- 3. Agents
CREATE TABLE dim_agents (
Agent_ID INT PRIMARY KEY IDENTITY (1,1),
Agent_Name NVARCHAR (50) 
);
INSERT INTO dim_agents (Agent_Name)
SELECT DISTINCT Agent
FROM fact_transaction
WHERE Agent IS NOT NULL
ORDER BY Agent;

-- 4. Trucks
CREATE TABLE dim_trucks (
Truck_ID INT PRIMARY KEY IDENTITY (1,1),
Truck_Number NVARCHAR (50)
);
INSERT INTO dim_trucks (Truck_Number)
SELECT DISTINCT Truck_No
FROM fact_transaction
WHERE Truck_No IS NOT NULL
ORDER BY Truck_No;

--5. Price History
CREATE TABLE dim_price_history (
Price_History_ID INT PRIMARY KEY IDENTITY (1,1),
Product_ID INT,
Price_Per_Ton FLOAT,
Effective_From DATE,
Effective_To DATE
);
INSERT INTO dim_price_history (Product_ID,Price_Per_Ton,Effective_From,Effective_To)
VALUES
--5/8 (PRODUCTID = 1)
(1,10600,'2025-11-01','2026-02-17'),
(1,11100,'2026-02-18','2026-03-08'),
(1,11900,'2026-03-09','2026-03-15'),
(1,12600,'2026-03-16','2026-04-02'),
(1,13100,'2026-04-03','2026-04-30'),
(1,13700,'2026-05-01','2026-05-04'),
(1,14100,'2026-05-05',NULL),
--3/8 (ProductID = 2)
(2,10100,'2025-11-01','2026-02-17'),
(2,10100,'2026-02-18','2026-03-08'),
(2,10500,'2026-03-09','2026-03-15'),
(2,10600,'2026-03-16','2026-04-02'),
(2,11000,'2026-04-03','2026-04-30'),
(2,11500,'2026-05-01','2026-05-04'),
(2,12000,'2026-05-05',NULL),
--1/2 (ProductID = 3)
(3,10100,'2025-11-01','2026-02-17'),
(3,10100,'2026-02-18','2026-03-08'),
(3,10800,'2026-03-09','2026-03-15'),
(3,11600,'2026-03-16','2026-04-02'),
(3,12100,'2026-04-03','2026-04-30'),
(3,12600,'2026-05-01','2026-05-04'),
(3,13000,'2026-05-05',NULL),
-- Stone dust (ProductID = 4)
(4,4000,'2025-11-01','2026-02-17'),
(4,3500,'2026-02-18','2026-03-08'),
(4,4000,'2026-03-09','2026-03-15'),
(4,4000,'2026-03-16','2026-04-02'),
(4,4000,'2026-04-03','2026-04-30'),
(4,4000,'2026-05-01','2026-05-04'),
(4,4500,'2026-05-05',NULL),
-- Stone base (ProductID = 5)
(5,6500,'2025-11-01','2026-02-17'),
(5,6500,'2026-02-18','2026-03-08'),
(5,7000,'2026-03-09','2026-03-15'),
(5,7000,'2026-03-16','2026-04-02'),
(5,7500,'2026-04-03','2026-04-30'),
(5,8000,'2026-05-01','2026-05-04'),
(5,8000,'2026-05-05',NULL),
-- Hard core (ProductID = 6)
(6,8500,'2025-11-01','2026-02-17'),
(6,8500,'2026-02-18','2026-03-08'),
(6,9000,'2026-03-09','2026-03-15'),
(6,9000,'2026-03-16','2026-04-02'),
(6,9500,'2026-04-03','2026-04-30'),
(6,10000,'2026-05-01','2026-05-04'),
(6,10000,'2026-05-05',NULL),
--Lumps (ProductID = 7)
-- Hard core (ProductID = 6)
(7,8500,'2025-11-01','2026-02-17'),
(7,8500,'2026-02-18','2026-03-08'),
(7,9000,'2026-03-09','2026-03-15'),
(7,9000,'2026-03-16','2026-04-02'),
(7,9500,'2026-04-03','2026-04-30'),
(7,10000,'2026-05-01','2026-05-04'),
(7,10000,'2026-05-05',NULL);

-- Update revenue and price_per_tons columns in facts table
Update f
SET
	f.Price_Per_Tons = ph.Price_Per_Ton,
	f.Revenue = f.NetTons * ph.Price_Per_Ton
FROM fact_transaction f
JOIN dim_products p
ON f.Product = p.Product
JOIN dim_price_history ph
ON p.Product_ID = ph.Product_ID
AND f.Date >= ph.Effective_From
AND (f.Date <= ph.Effective_To OR ph.Effective_To IS NULL);