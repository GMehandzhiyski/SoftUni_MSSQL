--01.
USE [SoftUni]
GO

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
BEGIN
	SELECT
		[FirstName],
		[LastName]
	FROM
		[Employees]
	WHERE [Salary] > 35000
END

EXEC usp_GetEmployeesSalaryAbove35000

--02.
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18,9)
AS
BEGIN
	SELECT 
		[FirstName],
		[LastName]
	FROM
		[Employees]
	WHERE [Salary] >= @minSalary
END

EXEC usp_GetEmployeesSalaryAboveNumber 50000

--03
CREATE PROCEDURE usp_GetTownsStartingWith @FirstLatter VARCHAR(MAX)
AS
BEGIN
	SELECT 
		[Name] AS [Town]
	FROM
		[Towns]
	WHERE [Name] LIKE CONCAT(@FirstLatter, '%')
END

EXEC usp_GetTownsStartingWith b

--04.
CREATE PROCEDURE usp_GetEmployeesFromTown  @inputTown VARCHAR(MAX)
AS
BEGIN

	SELECT 
		e.[FirstName],
		e.[LastName]
	FROM
		[Employees] AS e
		JOIN [Addresses] AS a ON e.AddressID = a.AddressID
		JOIN [Towns] AS t ON a.TownID = t.TownID
	WHERE t.[Name] = @inputTown
	
END

EXEC usp_GetEmployeesFromTown Sofia

--05.
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @outputSalaryLevel VARCHAR(10)
		IF(@salary < 30000) 
			SET @outputSalaryLevel = 'Low'
		ELSE IF (@salary  BETWEEN 30000 AND 50000)
			SET @outputSalaryLevel = 'Average'
		ELSE
			SET @outputSalaryLevel = 'High'

	RETURN @outputSalaryLevel
END
 
SELECT 
	[FirstName],
	[LastName],
	[Salary],
	dbo.ufn_GetSalaryLevel(Salary)
FROM
	[Employees]


--06.
CREATE PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(10)
AS
BEGIN
	SELECT 
		[FirstName],
		[LastName]
	FROM 
		[Employees]
	WHERE dbo.ufn_GetSalaryLevel([Salary]) = @salaryLevel
	
END

EXEC usp_EmployeesBySalaryLevel high