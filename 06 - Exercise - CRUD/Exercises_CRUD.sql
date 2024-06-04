--02.------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM [Departments]

--03.------------------------------------------------------------------------------------------------------------------------------
SELECT [Name]
FROM [Departments]

--04.
SELECT [FirstName], [LastName], [Salary]
FROM Employees

--05.
SELECT [FirstName], [MiddleName], [LastName]
FROM Employees

--06.
SELECT 
	CONCAT([FirstName],'.',[LastName],'@softuni.bg') AS 'Full Email Address'
FROM Employees

--07.
SELECT DISTINCT [Salary]
FROM Employees

--08.
SELECT *
FROM Employees
WHERE [JobTitle] =  'Sales Representative'

--09
SELECT [FirstName], [LastName], [JobTitle]
From [Employees]
WHERE [Salary] >= 20000
		AND [Salary] <= 30000

--10.
SELECT 
	CONCAT_WS(' ', [FirstName], [MiddleName], [LastName]) AS 'Full Name'
FROM [Employees]
WHERE [Salary] = 25000
		OR [Salary] = 14000
		OR [Salary] = 12500
		OR [Salary] = 23600

--11.
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [ManagerID] IS NULL

--12.
SELECT [FirstName], [LastName], [Salary]
FROM [Employees]
WHERE [Salary] > 50000
ORDER BY [Salary] DESC

--13.
SELECT TOP(5) [FirstName], [LastName]
FROM [Employees]
ORDER BY [Salary] DESC

--14.
SELECT [FirstName], [LastName]
FROM [Employees]
WHERE [DepartmentId] != 4


