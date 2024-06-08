USE [Gringotts]
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
