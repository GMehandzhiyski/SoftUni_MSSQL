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


select * from[WizzardDeposits]
