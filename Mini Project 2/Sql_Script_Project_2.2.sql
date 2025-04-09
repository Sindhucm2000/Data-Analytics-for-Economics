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
  Number_of_Employees INT
);

-- STEP: 2
copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM 'C:\Sindhu Documents\Data Analysis Projects\Mini Project 2.2\organizations-10000.csv'
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
WHERE Index = '100001'

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



