--Lecture exercise
--01.
USE [SoftUni]

SELECT TOP 50
	e.[FirstName], e.[LastName], t.[Name] AS [Town], a.[AddressText]
FROM [Employees] AS e
	JOIN [Addresses] AS a ON e.[AddressID] = a.[AddressID]
	JOIN [Towns] AS t ON a.[TownID] = t.[TownID]
ORDER BY
	e.[FirstName], e.[LastName]


--02.
SELECT 
	e.[FirstName], e.[LastName],e.[HireDate], d.[Name] AS [DeptName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE 
	e.[HireDate] > '1999-1-1'
	AND d.[Name] IN('Sales', 'Finance')
ORDER BY
	e.[HireDate]

--Exercise
--01.
SELECT TOP 5
	e.[EmployeeID],e.[JobTitle], a.[AddressID], a.[AddressText] 
FROM 
	[Employees] AS e
	JOIN [Addresses] AS a ON e.AddressID = a.[AddressID]
ORDER BY a.[AddressID]

--02. 
SELECT TOP 50
	e.[FirstName], e.[LastName], t.[Name] AS [Town], a.[AddressText]
FROM
	[Employees] AS e
	JOIN [Addresses] AS a ON e.AddressID = a.AddressID
	JOIN [Towns] AS t ON t.TownID = a.TownID
ORDER BY [FirstName], [LastName]

--03.
SELECT 
	e.[EmployeeID], e.[FirstName], e.[LastName], d.[Name] AS [DepartmentName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

--04.
SELECT TOP 5
	e.[EmployeeID], e.[FirstName], e.[Salary], d.[Name] AS [DepartmentName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE e.[Salary] > 15000
ORDER BY d.[DepartmentID]

--05.
SELECT TOP 3
	e.[EmployeeID], e.[FirstName]
FROM
	[Employees] AS e
	LEFT JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN [Projects] AS p ON ep.ProjectID = p.ProjectID
WHERE ep.ProjectID IS NULL
ORDER BY 
	e.[EmployeeID]

--06.
SELECT
	e.[FirstName], e.[LastName], e.[HireDate], d.[Name] AS [DeptName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
WHERE e.[HireDate] > '1999-01-01'
		AND d.[Name] IN ('Sales', 'Finance')
ORDER BY 
	e.[HireDate]

--07.
SELECT TOP 5
	e.[EmployeeID], e.[FirstName], p.[Name] AS [ProjectName]
FROM 
	[Employees] AS e
	JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN [Projects] AS p ON ep.ProjectID = p.ProjectID
WHERE p.[StartDate] > '2002-08-13'
		AND p.[EndDate] IS NULL
ORDER BY 
	e.[EmployeeID]

--08.
SELECT
	e.[EmployeeID], e.[FirstName], [ProjectName] =
	CASE 
		WHEN DATEPART(YEAR,[StartDate]) > 2004 THEN NULL
		ELSE p.[Name]
	END
FROM
	[Employees] AS e
	JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN [Projects] AS p ON ep.ProjectID = p.ProjectID
WHERE e.[EmployeeID] = 24
		
--09.
SELECT 
	e.[EmployeeID], e.[FirstName], em.[EmployeeID] AS [ManagerID], em.[FirstName] AS [ManagerName]  

FROM
	[Employees] AS e
	JOIN [Employees] AS em ON e.ManagerID = em.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY
	e.[EmployeeID]

--10.
SELECT TOP 50
	e.[EmployeeID],
	CONCAT_WS(' ', e.[FirstName], e.[LastName]) AS [EmployeeName],
	CONCAT_WS(' ', em.[FirstName], em.[LastName] ) AS [ManagerName],
	d.[Name]
FROM
	[Employees] AS e
	JOIN [Employees] AS em ON e.[ManagerID] = em.[EmployeeID]
	JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
 ORDER BY 
	e.EmployeeID

--11.
SELECT TOP 1
	AVG(e.[Salary]) AS [MinAverageSalary]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID
ORDER BY
	[MinAverageSalary]

USE [Geography]

--12.
SELECT
	c.[CountryCode], m.[MountainRange], p.[PeakName], p.[Elevation]
FROM
	[Countries]	AS c 
	JOIN  [MountainsCountries] AS mc ON c.[CountryCode] = mc.[CountryCode]
	JOIN [Mountains] AS m ON mc.MountainId = m.Id
	JOIN [Peaks] AS p ON m.Id = p.MountainId
WHERE c.[CountryName] = 'Bulgaria'
		AND p.[Elevation] > 2835
ORDER BY 
	p.[Elevation] DESC

--13.
SELECT
	c.[CountryCode],
	COUNT(m.[MountainRange]) AS [MountainRanges]
FROM
	[Countries] AS c 
	JOIN [MountainsCountries] AS mc ON c.[CountryCode] = mc.[CountryCode]
	JOIN [Mountains] AS m ON mc.[MountainId] = m.Id 
WHERE c.[CountryName] IN ('United States','Russia', 'Bulgaria')
GROUP BY
	c.[CountryCode]
