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

--07.
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN

	DECLARE @wordLength INT = LEN(@word) 
	DECLARE @iter INT= 1

	WHILE(@iter <= @wordLength)
		BEGIN
			IF	(CHARINDEX(SUBSTRING(@word, @iter, 1), @setOfLetters) = 0)
				RETURN  0
			SET @iter += 1
		END
		RETURN 1
END

USE [Bank]
GO
--08.
CREATE PROCEDURE usp_GetHoldersFullName 
AS
BEGIN
	SELECT
		CONCAT_WS(' ', [FirstName], [LastName]) AS [Full Name]
	FROM
		[AccountHolders]
END

--10.
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @number MONEY
AS
BEGIN
	SELECT 
		[FirstName],
		[LastName]
	FROM
		[AccountHolders] AS ah
		JOIN [Accounts] AS a ON ah.Id = a.AccountHolderId
	GROUP BY 
		[FirstName],
		[LastName]
	HAVING SUM(a.[Balance]) > @number
	ORDER BY 
		[FirstName],
		[LastName]

END 

EXEC usp_GetHoldersWithBalanceHigherThan 50000


--11.
CREATE FUNCTION ufn_CalculateFutureValue  (@sum DECIMAL(10,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS decimal(10,4)
AS
BEGIN
	RETURN @sum * POWER((1 + @yearlyInterestRate), @numberOfYears)
END


--12. 
alter PROCEDURE usp_CalculateFutureValueForAccount (@accountId INT,  @interestRate FLOAT)
AS

	DECLARE @years INT = 5
	SELECT 
		ah.[Id] AS [Account Id],
		[FirstName],
		[LastName],
		[Balance] AS [Current Balance],
		dbo.ufn_CalculateFutureValue(a.[Balance], @interestRate, @years) AS [Balance in 5 years]
	FROM
		[AccountHolders] AS ah
		JOIN [Accounts] AS a ON  a.AccountHolderId = ah.Id


EXec usp_CalculateFutureValueForAccount 12, 0.5