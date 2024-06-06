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