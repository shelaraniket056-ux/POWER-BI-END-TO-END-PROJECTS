CREATE TABLE Blinkit_data(
	Item_Fat_Content Varchar(100),
	Item_identifier VARCHAR(100),
	Item_Type VARCHAR(100),
	Outlet_Establishment_year INTEGER,
	Outlet_Identifier VARCHAR(50),
	Outlet_Loacation_Type VARCHAR(50),
	Outlet_Size VARCHAR(50),
	Outlet_Type VARCHAR(50),
	Item_Visiblity NUMERIC(10,6),
	Item_Weight NUMERIC(10,2),
	Total_Sales NUMERIC(10,4),
	Rating NUMERIC(10,2)
);

SELECT * FROM Blinkit_data;

ALTER TABLE Blinkit_data
RENAME COLUMN Outlet_Loacation_Type TO Outlet_Location_Type;

COPY Blinkit_data(Item_Fat_content, Item_identifier, Item_Type, Outlet_Establishment_year, Outlet_Identifier, Outlet_Location_Type, Outlet_Size, Outlet_Type, Item_Visiblity, Item_Weight, total_Sales, Rating)
FROM 'D:\Blinkit_data.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM Blinkit_data;

--A.KPIs
--1. DATA CLEANING
UPDATE BLINKIT_DATA
SET Item_Fat_Content=
	CASE
		WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
		WHEN Item_Fat_Content IN ('reg') THEN 'Regular'
		ELSE Item_Fat_Content
			END;

--2. TOTAL SALES
SELECT CAST(SUM(Total_Sales)/1000000.0 AS DECIMAL(10,2)) AS Total_sales_Million
FROM Blinkit_data;

--3.AVERAGE SALES
SELECT CAST(AVG(Total_Sales) AS INTEGER) AS Avg_Sales
FROM Blinkit_data;

--4.COUNT OF ITEM
SELECT COUNT(*) AS No_of_Item
FROM Blinkit_data;

--5.AVG RATINGS
SELECT CAST(AVG(Rating)AS DECIMAL(10,2)) AS Avg_Rating
FROM Blinkit_data;

--B.TOTAL SALES BY FAT CONTENT
SELECT Item_Fat_Content,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS TOTAL_CONTENT
FROM Blinkit_data
GROUP BY Item_Fat_Content;

--C.TOTAL SALES BY ITEM TYPE 
SELECT Item_Type,
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS TOTAL_Sales
FROM Blinkit_data
GROUP BY Item_Type
ORDER BY TOTAL_Sales DESC;

--D.FAT CONTENT BY OUTLET FOR TOTAL SALES
SELECT Outlet_Location_Type,
	COALESCE(
	SUM(CASE
			WHEN Item_Fat_Content='Low Fat'
			THEN Total_Sales
			END),0
			)::NUMERIC(10,2) AS LOW_FAT,

	COALESCE(
	SUM(CASE
			WHEN Item_Fat_Content='Regular'
			THEN Total_Sales
			END),0
			)::NUMERIC(10,2) AS REGULAR
FROM Blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

--E. TOTAL SALES BY OUTLET ESTABLISHMENT
SELECT Outlet_Establishment_Year,
	CAST(SUM(Total_Sales)AS DECIMAL (10,2))
	AS TOTAL_SALES
	FROM Blinkit_data
	GROUP BY Outlet_Establishment_Year
	ORDER BY Outlet_Establishment_Year;

--F.PERCENTAGE OF SALES BY OUTLET SIZE
SELECT Outlet_Size,
	CAST(SUM(Total_sales)AS DECIMAL (10,2)) 
	AS TOTAL_SALES,
	CAST(SUM(Total_sales)*100/SUM(SUM(Total_sales)) OVER () AS DECIMAL(10,2))
	AS SALES_PERCENTAGE
	FROM Blinkit_data
	GROUP BY Outlet_Size
	ORDER BY TOTAL_SALES DESC;
	
--G.SALES BY OUTLET LOCATION
SELECT Outlet_Location_Type,
		CAST(SUM(Total_sales) AS DECIMAL(10,2)) AS TOTAL_SALES
		FROM Blinkit_data
		GROUP BY Outlet_Location_Type
		ORDER BY Outlet_Location_Type DESC;

--H. ALL METRICS BY OUTLET TYPES
SELECT Outlet_Type,
	CAST(SUM(Total_sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
	CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS Avg_Sales,
	COUNT(*) AS No_of_Item,
	CAST(AVG(Rating)AS DECIMAL(10,2)) AS Avg_Rating,
	CAST(AVG(Item_Visiblity) AS DECIMAL(10,2)) AS ITEM_VISIBLITY
	FROM Blinkit_data
		GROUP BY Outlet_Type
		ORDER BY TOTAL_SALES DESC;




