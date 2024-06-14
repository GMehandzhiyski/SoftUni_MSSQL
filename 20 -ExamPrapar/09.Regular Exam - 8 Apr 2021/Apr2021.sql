CREATE DATABASE Service
USE Service
GO

--01.

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(50) NOT NULL,
	Name VARCHAR(50),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 14 AND 110),
	Email VARCHAR(50) NOT NULL
);

CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
);


CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate  DATETIME,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT, 
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL,
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


CREATE TABLE Status
(
	Id INT PRIMARY KEY IDENTITY,
	Label VARCHAR(20) NOT NULL
);

CREATE TABLE Reports
(
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT NOT NULL,
	FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	StatusId INT NOT NULL,
	FOREIGN KEY (StatusId) REFERENCES Status(Id),
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	Description VARCHAR(200)NOT NULL,
	UserId INT  NOT NULL,
	FOREIGN KEY (UserId) REFERENCES Users(Id),
	EmployeeId INT,
	FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
);

--02.
INSERT INTO Employees(FirstName,	LastName,	Birthdate,	DepartmentId)
		VALUES
	('Marlo','O''Malley','1958-9-21',1),
	('Niki','Stanaghan','1969-11-26',4),
	('Ayrton','Senna','1960-03-21',9),
	('Ronnie','Peterson','1944-02-14',9),
	('Giovanna','Amati','1959-07-20',5)

INSERT INTO Reports(CategoryId,	StatusId,	OpenDate,	CloseDate,	Description,	UserId,	EmployeeId)
		VALUES
	(1	,1,	'2017-04-13', NULL,'Stuck Road on Str.133',6 ,2),
	(6	,3,	'2015-09-05', '2015-12-06',	'Charity trail running',	3,	5),
	(14	,2,	'2015-09-07', 	NULL,	'Falling bricks on Str.58',	5,	2),
	(4	,3,	'2017-07-03', '2017-07-06',	'Cut off streetlight on Str.11',	1,	1)

--03.
BEGIN TRANSACTION

UPDATE Reports
	SET CloseDate = GETDATE()
WHERE CloseDate IS NULL
ROLLBACK TRANSACTION

--04.
BEGIN TRANSACTION
DELETE
Reports
WHERE StatusId = 4
ROLLBACK TRANSACTION

--05.
SELECT
	Description,
	FORMAT(OpenDate, 'dd-MM-yyy') AS OpenDate
FROM 
	Reports
WHERE EmployeeId IS NULL
ORDER BY
	FORMAT(OpenDate, 'dd-MM-yyy') ASC,
	Description ASC 

SELECT
* 
FROM 
 Reports
WHERE EmployeeId IS NULL

--06.
SELECT
 r.Description,
 c.Name
FROM
	Reports AS r
	JOIN Categories AS c ON R.CategoryId = c.Id
WHERE CategoryId IS NOT NULL
ORDER BY 
	Description,
	c.Name

--07.
SELECT TOP 5
	c.Name,
	COUNT(r.id)
FROM
	Reports AS r
	JOIN Categories AS c ON R.CategoryId = c.Id
GROUP BY 
	c.Name
ORDER BY
	COUNT(r.id) DESC,
	c.Name

--08.
SELECT 
	u.Username,
	c.Name
FROM 
	Reports AS r
	JOIN Categories AS c ON R.CategoryId = c.Id
	JOIN Users AS u ON r.UserId = u.Id
WHERE FORMAT(r.OpenDate, 'dd-MM') = FORMAT(u.Birthdate, 'dd-MM')
ORDER BY
	u.Username,
	c.Name

--09.
SELECT
	CONCAT_WS(' ', e.FirstName,	e.LastName),
	COUNT(r.Id)
FROM
	Employees AS e
	LEFT JOIN Reports AS r ON e.Id = r.EmployeeId
GROUP BY
	e.FirstName,
	e.LastName
ORDER  BY
	COUNT(r.Id) DESC,
	CONCAT_WS(' ', e.FirstName,	e.LastName)

--10.
SELECT
	ISNULL(CONCAT_WS(' ', e.FirstName, e.LastName), 'None'),
	ISNULL(d.Name, 'None'),
	ISNULL(c.Name, 'None'),
	ISNULL(r.Description,'None'),
	ISNULL(FORMAT(r.OpenDate, 'dd.MM.yyyy'), 'None'),
	ISNULL(s.Label, 'None'),
	ISNULL(u.Name, 'None')
FROM
	Reports AS r
	JOIN Categories AS c ON R.CategoryId = c.Id
	JOIN Employees AS e ON r.EmployeeId = e.Id
	JOIN Departments AS d ON e.DepartmentId = d.Id
	JOIN Status AS s ON r.StatusId = s.Id
	JOIN Users AS u ON r.UserId = u.Id
ORDER BY
	 e.FirstName DESC,
	 e.LastName DESC,
	 d.Name,
	 c.Name,
	 r.Description,
	 r.OpenDate,
	 s.Label,
	 u.Name

--11.
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME) 
RETURNS INT
AS
BEGIN
	DECLARE @result INT

		IF	@StartDate <= 0 OR @EndDate <= 0 
			SET @result = 0;
		ELSE 
			SET	@result = DATEDIFF(HOUR, @StartDate, @EndDate);

	RETURN @result;

END


--12
CREATE PROCEDURE usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT) 
AS
BEGIN
	DECLARE @EmployeeIdCheck INT;
	DECLARE @ReportIdCheck INT;

	SELECT
		@EmployeeIdCheck = d.Id
	FROM
		Employees AS e
		JOIN Departments AS d ON e.DepartmentId = D.Id
	WHERE e.Id = @EmployeeId
	SELECT
		@ReportIdCheck = c.DepartmentId
	FROM
		Reports AS r
		JOIN Categories AS c ON r.CategoryId =	c.Id
	WHERE r.Id = @ReportId
	
	IF @EmployeeIdCheck <> @ReportIdCheck 
		THROW 51000,'Employee doesn''t belong to the appropriate department!',1
	SELECT
		r.CategoryId
	FROM
		Employees AS e
		JOIN Departments AS d ON e.DepartmentId = d.Id
		JOIN Reports AS r ON e.Id = r.EmployeeId
		JOIN Categories AS c ON r.CategoryId = c.Id
		WHERE e.Id = 17 AND  c.Id = 2

END

EXEC usp_AssignEmployeeToReport 30, 1
EXEC usp_AssignEmployeeToReport 17, 2