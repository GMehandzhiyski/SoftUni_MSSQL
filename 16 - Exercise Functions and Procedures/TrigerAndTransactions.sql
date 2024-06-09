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