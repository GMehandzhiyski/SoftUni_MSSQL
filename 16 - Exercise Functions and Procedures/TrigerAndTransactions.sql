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
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber 
	@Salary DECIMAL(18, 9)
AS
BEGIN
	SELECT 
		[FirstName],
		[LastName]
	FROM
		[Employees]
	WHERE [Salary] <= @Salary
END