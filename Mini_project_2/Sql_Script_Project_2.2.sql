-- STEP: 1
CREATE TABLE organizations (
  Index SERIAL PRIMARY KEY,
  Organization_Id VARCHAR(255),
  Name VARCHAR(255),
  Website VARCHAR(255),
  Country VARCHAR(255),
  Description TEXT,
  Founded VARCHAR(5),
  Industry VARCHAR(255),
  Number_of_Employees INT);

-- STEP: 2
copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM 'C:\Github_Desktop\Data-Analytics-for-Economics\Mini Project 2\organizations-10000.csv'
DELIMITER ',' CSV HEADER;

-- STEP: 3
SELECT 
  Name,
  Country
FROM organizations
LIMIT 20;
-- select all the columns but restrict it to the first 20 rows
SELECT *
FROM organizations
LIMIT 20

-- STEP: 4
INSERT INTO organizations (
  Index, Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  100001, 'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);

-- STEP: 5
SELECT *
FROM organizations
WHERE Index = '100001';

-- STEP: 6
SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;

-- STEP: 7
SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;

-- STEP: 8
UPDATE organizations
SET Number_of_Employees = '3135'
WHERE Organization_Id = '6CDCcdE3D0b7b44';

--STEP: 9
SELECT *
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44';

-- STEP:10 
SELECT COUNT(DISTINCT Industry)
FROM organizations;
-- INCASE OF THE LIST
SELECT DISTINCT Industry
FROM organizations;

-- STEP: 11
SELECT 
	Industry,
	COUNT(*) AS count_by_industry
FROM organizations
GROUP BY Industry

-- STEP: 12
SELECT Industry,
COUNT(DISTINCT Country) AS Number_of_Countries
FROM organizations
GROUP BY Industry
ORDER BY Number_of_Countries DESC;

-- STEP: 13
SELECT
  LENGTH(Founded) AS years_founded
FROM organizations;

SELECT
     Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 

UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';

-- the following code is used to alter the table column 
-- and truncate the existing value to the fit the new type
ALTER TABLE public.organizations
ALTER COLUMN founded TYPE VARCHAR(4)
USING SUBSTRING(founded FROM 1 FOR 4);

-- STEP: 14 -- removing duplicate values
SELECT
Organization_Id,
COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;

CREATE TABLE organizations_clean AS
SELECT DISTINCT ON (Organization_Id) *
FROM organizations
ORDER BY Organization_Id, Index;
-- here we drop the original table and rename the new one
DROP TABLE organizations;
ALTER TABLE organizations_clean RENAME TO organizations;

-- STEP: 15
SELECT
    Country,
    Number_of_employees
FROM organizations
ORDER BY Number_of_employees DESC;

-- STEP: 16
SELECT 
	Name, 
	Country, 
	to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31';

-- STEP: 17
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date,
     Number_of_Employees
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
     AND Number_of_Employees BETWEEN 2000 AND 3000;

-- STEP: 18
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000;

-- STEP: 19
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date,
     Number_of_Employees
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
     AND Number_of_Employees BETWEEN 2000 AND 3000;

-- STEP: 20
SELECT
    CASE
        WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN '0-1000'
        WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN '1001-2000'
        WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN '2001-3000'
        ELSE '3001+'
    END AS Employee_Range,
    COUNT(*) AS Count_of_Organizations
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
GROUP BY Employee_Range
ORDER BY Employee_Range;

---- Step 1: Add the New Column firm_size
ALTER TABLE organizations
ADD COLUMN firm_size VARCHAR(10);

---- Step 2: Populate the firm_size Column
UPDATE organizations
SET firm_size = CASE
WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
ELSE 'Very Large'
END;

---- Step 3: Verify the Changes
SELECT Name, Number_of_Employees, firm_size
FROM organizations
LIMIT 20;

-- STEP: 21
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms

-- STEP: 22
SELECT
    TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word,
    COUNT(*) AS Frequency
FROM organizations
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;

-- STEP: 23
DO $$
DECLARE
    org_id VARCHAR;
BEGIN
    -- Create a loop to iterate through all rows
    FOR org_id IN
        SELECT Organization_Id
        FROM organizations
    LOOP
        -- Update each row's Number_of_Employees by adding 100
        UPDATE organizations
        SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100
        WHERE Organization_Id = org_id;
    END LOOP;
END $$;

-- STEP: 24 A SIMPLE LOOP
-- Create the Departments table
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50)
);

-- Insert data into the Departments table
INSERT INTO Departments (Department_ID, Department_Name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Sales'),
(5, 'Service');

-- Create the Employees table
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department_ID INT
);

-- Insert data into the Employees table
INSERT INTO Employees (Employee_ID, Employee_Name, Department_ID) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 3),
(104, 'Diana', NULL),
(105, 'Eve', 4);

-- STEP: 25 INNER JOIN
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
INNER JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- STEP: 26 LEFT JOIN
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
LEFT JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

--STEP: 27 RIGHT JOIN
SELECT
    Departments.Department_ID,
    Departments.Department_Name,
    Employees.Employee_Name
FROM
    Employees
RIGHT JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- STEP: 28 FULL OUTER JOIN
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
FULL OUTER JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- STEP: 29 -- SUBQUERIES PRACTICE 
-- Create the Warehouses table
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(50),
    state VARCHAR(2)
);

-- Insert data into the Warehouses table
INSERT INTO Warehouses (warehouse_id, warehouse_name, state) VALUES
(1, 'Warehouse A', 'NY'),
(2, 'Warehouse B', 'CA'),
(3, 'Warehouse C', 'TX'),
(4, 'Warehouse D', 'FL');

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    warehouse_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);

-- Insert data into the Orders table
INSERT INTO Orders (order_id, warehouse_id, customer_id, order_date, amount) VALUES
(101, 1, 201, '2025-01-01', 500.00),
(102, 1, 202, '2025-01-02', 300.00),
(103, 2, 203, '2025-01-01', 700.00),
(104, 3, 204, '2025-01-03', 200.00),
(105, 4, 205, '2025-01-04', 100.00),
(106, 2, 206, '2025-01-04', 400.00),
(107, 3, 207, '2025-01-05', 250.00);

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

-- Insert data into the Customers table
INSERT INTO Customers (customer_id, customer_name, city) VALUES
(201, 'Alice', 'New York'),
(202, 'Bob', 'San Francisco'),
(203, 'Charlie', 'Los Angeles'),
(204, 'Diana', 'Houston'),
(205, 'Eve', 'Miami'),
(206, 'Frank', 'Sacramento'),
(207, 'Grace', 'Dallas');

-- Subquery in a SELECT Statement:
SELECT
    warehouse_id,
    warehouse_name,
    (SELECT SUM(amount) FROM Orders) AS total_order_amount
FROM
    Warehouses;

-- EXERCISE:Modify the query to include the average order amount instead of the total
SELECT 
	warehouse_id,
	warehouse_name,
	(SELECT AVG(amount) FROM Orders) AS average_order_amount
FROM Warehouses;

-- Subquery in a FROM Statement
SELECT
    W.warehouse_name,
    O.total_amount
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        SUM(amount) AS total_amount
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

--EXERCISE: Modify the query to show the number of orders instead of the total amount
SELECT
    W.warehouse_name,
    O.order_count
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        COUNT(*) AS order_count
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

-- Subquery in a WHERE Statement
SELECT
    warehouse_name
FROM
    Warehouses
WHERE
    warehouse_id IN (
        SELECT DISTINCT warehouse_id
        FROM Orders
        WHERE customer_id IN (
            SELECT customer_id
            FROM Customers
            WHERE city IN ('New York', 'Dallas')
        )
    );

-- EXERCISE: Modify the query to find warehouses that processed orders for customers NOT from 'New York' or 'Dallas'
SELECT 
    warehouse_name
FROM
    Warehouses
WHERE
    warehouse_id IN (
        SELECT DISTINCT warehouse_id
        FROM Orders
        WHERE customer_id IN (
            SELECT customer_id
            FROM Customers
            WHERE city NOT IN ('New York', 'Dallas')
        )
    );

-- Subquery with Aggregate Functions
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.20 THEN '0-20% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.20 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.60 THEN '21-60% Orders'
        ELSE 'More than 60% Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;

-- EXERCISE: Adjust the ranges to divide fulfillment percentages into quartiles (0-25%, 26-50%, etc.,)
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.25 THEN '0-25% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.50 THEN '26-50% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.75 THEN '51-75% Orders'
        ELSE '76-100% Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
    ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;

-- 