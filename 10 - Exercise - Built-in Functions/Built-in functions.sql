--01.
USE SoftUni
GO

SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'

--02.
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [LastName] LIKE '%ei%'

--03.
SELECT [FirstName]
FROM [Employees]
WHERE [DepartmentID] IN (3, 10) AND
		DATEPART(YEAR, [HireDate]) BETWEEN 1995 AND 2005

--04.
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE  [JobTitle] NOT LIKE '%engineer%'

--05.
SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]

--06.
SELECT [TownID], [Name]
FROM [Towns]
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--07.
SELECT [TownID], [Name]
FROM [Towns]
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

--08.
CREATE VIEW V_EmployeesHiredAfter2000  AS

	SELECT [FirstName], [LastName]
	FROM [Employees]
	WHERE DATEPART(YEAR, [HireDate]) > 2000

--09.
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE LEN([LastName]) = 5 

--10.
SELECT [EmployeeID], [FirstName], [LastName], [Salary],
	DENSE_RANK() OVER 
	(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN  10000 AND 50000
ORDER BY [Salary] DESC

--11.

SELECT * FROM
(
	SELECT [EmployeeID], [FirstName], [LastName], [Salary],
		DENSE_RANK() OVER
		(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
	FROM [Employees]
	WHERE [Salary] BETWEEN 10000 AND 50000 
) AS [Result]
WHERE [Result].[Rank] = 2
ORDER BY [Salary] DESC



USE [Geography]
--12.
SELECT [CountryName], [ISOCode]
FROM [Countries]
WHERE [CountryName] LIKE '%A%A%A%'
ORDER BY [IsoCode]

--13.
SELECT  [PeakName], [RiverName], LOWER(CONCAT(SUBSTRING([PeakName], 1, LEN([PeakName])-1),[RiverName])) AS Mix
FROM [Peaks], [Rivers]
WHERE RIGHT([PeakName], 1) = LEFT([RiverName],1)
ORDER BY Mix


USE [Diablo]
--14.
SELECT TOP 50 [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE DATEPART(YEAR,[Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name]

--15.
SELECT [UserName], SUBSTRING([Email], (CHARINDEX('@',[Email])+1), LEN([Email])) AS [EmailProveder]
FROM [Users]
ORDER BY [EmailProveder], [UserName]

--15.
SELECT [UserName], [IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [UserName]