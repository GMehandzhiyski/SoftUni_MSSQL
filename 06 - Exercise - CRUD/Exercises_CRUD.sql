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
	