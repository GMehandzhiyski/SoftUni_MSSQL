USE [Gringotts]
go
--01.
SELECT COUNT(*) AS [Count]
FROM
	[WizzardDeposits]

--02.
SELECT 
	MAX([MagicWandSize]) AS [LongestMagicWand]
FROM 
	[WizzardDeposits]


--03.
SELECT 
	[DepositGroup],
	MAX([MagicWandSize]) AS [LongestMagicWand]
FROM 
	[WizzardDeposits]
GROUP BY [DepositGroup]

--04.
SELECT top 2
	[DepositGroup]
FROM 
	[WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize])

--05.
SELECT 
	[DepositGroup],
	SUM(DepositAmount) AS [TotalSum]
FROM
	[WizzardDeposits]
GROUP BY
	[DepositGroup]

--06.
SELECT 
	[DepositGroup],
	SUM(DepositAmount) AS [TotalSum]
FROM
	[WizzardDeposits]
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY
	[DepositGroup]

--.07
SELECT 
	[DepositGroup],
	SUM(DepositAmount) AS [TotalSum]
FROM
	[WizzardDeposits]
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY
	[DepositGroup]
HAVING  
	SUM(DepositAmount) < 150000
ORDER BY 
	[TotalSum] DESC

--08.
SELECT 
	[DepositGroup],
	[MagicWandCreator],
	MIN([DepositCharge]) AS [MinDepositCharge]
FROM
	[WizzardDeposits]
GROUP BY
	[DepositGroup],
	[MagicWandCreator]
ORDER BY
	[MagicWandCreator],
	[DepositGroup]

--09.
SELECT 
	[AgeGroup], COUNT(*) AS [WizardCount]
FROM
(
		SELECT 
			CASE
				WHEN [Age] < 10 THEN '[0-10]'
				WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
				WHEN [Age] > 60 THEN '[61+]'
			END AS [AgeGroup]
		FROM
			[WizzardDeposits]
) AS NestedQuery
GROUP BY [AgeGroup]
	
--10.
SELECT 
	[FirstLetter]
FROM
(
	SELECT 
		SUBSTRING(FirstName, 1, 1) AS [FirstLetter]
	FROM
		[WizzardDeposits]
	WHERE 
		[DepositGroup] = 'Troll Chest'
) AS SUBQUERY
GROUP BY
	[FirstLetter]

--11.
SELECT
	[DepositGroup],
	[IsDepositExpired],
	AVG([DepositInterest])
FROM
	[WizzardDeposits]
WHERE [DepositStartDate] > '1985-01-01' 
GROUP BY 
	[DepositGroup],
	[IsDepositExpired]
ORDER BY [DepositGroup] DESC,
			[IsDepositExpired]


--PART 2 - Queries for SoftUni Database
USE [SoftUni]
GO


--13.
SELECT 
	[DepartmentID],
	SUM([Salary]) AS [TotalSalary]
FROM
	[Employees]
GROUP BY
		[DepartmentID]
ORDER BY 
	[DepartmentID]
	

	

SELECT*FROM[Employees]


