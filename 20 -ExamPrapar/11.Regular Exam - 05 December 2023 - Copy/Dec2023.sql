CREATE DATABASE RailwaysDB 
USE RailwaysDB
GO

--01.

CREATE TABLE Passengers 
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(80) NOT NULL
);


CREATE TABLE Towns
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(30) NOT NULL
);


CREATE TABLE RailwayStations
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
	TownId INT NOT NULL,
    FOREIGN KEY (TownId)REFERENCES Towns(Id)
);


CREATE TABLE Trains 
(
    Id INT PRIMARY KEY IDENTITY,
    HourOfDeparture NVARCHAR(5) NOT NULL,
    HourOfArrival NVARCHAR(5) NOT NULL,
	DepartureTownId INT NOT NULL,
	ArrivalTownId INT NOT NULL,
    FOREIGN KEY(DepartureTownId) REFERENCES Towns(Id) ,
    FOREIGN KEY(ArrivalTownId )REFERENCES Towns(Id) 
);


CREATE TABLE TrainsRailwayStations
(
    TrainId INT,
    RailwayStationId INT,
    PRIMARY KEY (TrainId, RailwayStationId),
    FOREIGN KEY (TrainId) REFERENCES Trains(Id),
    FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)
);


CREATE TABLE MaintenanceRecords (
    Id INT PRIMARY KEY IDENTITY,
    DateOfMaintenance DATE NOT NULL,
    Details NVARCHAR(2000) NOT NULL,
	TrainId INT NOT NULL,
   FOREIGN KEY (TrainId) REFERENCES Trains(Id) 
);


CREATE TABLE Tickets
(
    Id INT PRIMARY KEY IDENTITY,
    Price DECIMAL(10,2) NOT NULL,
    DateOfDeparture DATE NOT NULL,
    DateOfArrival DATE NOT NULL,
	TrainId INT NOT NULL,
	PassengerId INT NOT NULL,
    FOREIGN KEY(TrainId) REFERENCES Trains(Id) ,
    FOREIGN KEY(PassengerId) REFERENCES Passengers(Id)
);


--02.
INSERT INTO Trains(HourOfDeparture,	HourOfArrival,	DepartureTownId,	ArrivalTownId)
	VALUES
		('07:00',	'19:00',	1,	3),
		('08:30',	'20:30',	5,	6),
		('09:00',	'21:00',	4,	8),
		('06:45',	'03:55',	27,	7),
		('10:15',	'12:15',	15,	5)

INSERT INTO TrainsRailwayStations(TrainId,	RailwayStationId)
	VALUES
(36,	1),
(36,	4),
(36,	31),
(36,	57),
(36,	7),
(37,	13),
(37,	54),
(37,	60),
(37,	16),
(38,	10),
(38,	50),
(38,	52),
(38,	22),
(39,	68),
(39,	3),
(39,	31),
(39,	19),
(40,	41),
(40,	7),
(40,	52),
(40,	13)

INSERT INTO Tickets(Price,	DateOfDeparture,	DateOfArrival,	TrainId,	PassengerId)
	VALUES
	(90.00, '2023-12-01',	'2023-12-01',	36,	1),
	(115.00, '2023-08-02',	'2023-08-02',	37,	2),
	(160.00, '2023-08-03',	'2023-08-03',	38,	3),
	(255.00, '2023-09-01',	'2023-09-02',	39,	21),
	(95.00, '2023-09-02',	'2023-09-03',	40,	22)

--03. 
BEGIN TRANSACTION

UPDATE Tickets
	SET DateOfArrival = DATEADD(DAY, 7, DateOfArrival),
		DateOfDeparture = DATEADD(DAY,7,DateOfDeparture)
WHERE  DateOfDeparture > '2023-10-31'

 ROLLBACK TRANSACTION

 --04. 
BEGIN TRANSACTION
DELETE
Tickets
WHERE TrainId IN (SELECT tr.Id FROM Trains AS tr JOIN Towns tw ON tr.DepartureTownId = tw.Id WHERE tw.Name = 'Berlin')


DELETE
MaintenanceRecords
WHERE TrainId IN (SELECT tr.Id FROM Trains AS tr JOIN Towns tw ON tr.DepartureTownId = tw.Id WHERE tw.Name = 'Berlin')

DELETE
TrainsRailwayStations
WHERE TrainId IN (SELECT tr.Id FROM Trains AS tr JOIN Towns tw ON tr.DepartureTownId = tw.Id WHERE tw.Name = 'Berlin')

DELETE
Trains 
WHERE Id IN (SELECT tr.Id FROM Trains AS tr JOIN Towns tw ON tr.DepartureTownId = tw.Id WHERE tw.Name = 'Berlin')

ROLLBACK TRANSACTION
 
--05.
SELECT
	DateOfDeparture,
	Price

FROM 
	Tickets
ORDER BY
	Price,
	DateOfDeparture DESC

--06.
SELECT
	pa.Name,
	ti.Price,
	ti.DateOfDeparture,
	ti.TrainId
FROM 
	Tickets AS ti
	JOIN  Passengers AS pa ON ti.PassengerId = pa.Id
ORDER BY
	ti.Price DESC,
	pa.Name


--07. 
SELECT 
	t.Name,
	rs.Name

FROM
	RailwayStations AS rs
	LEFT JOIN TrainsRailwayStations AS trs ON rs.Id = trs.RailwayStationId
	LEFT JOIN Towns AS t ON rs.TownId = t.Id
WHERE TrainId IS NULL
ORDER BY
	t.Name,
	rs.Name


--08.
SELECT TOP 3
	tr.Id,
	tr.HourOfDeparture,
	t.Price,
	tw.Name
FROM
	Trains AS tr
	JOIN Tickets AS t ON tr.Id = t.TrainId
	JOIN Towns AS tw ON tr.ArrivalTownId = tw.Id
WHERE HourOfDeparture LIKE '08:%'
		AND t.Price > 50
ORDER BY
	t.Price
	
--09.
SELECT
	t.Name,
	COUNT(tr.ArrivalTownId)
FROM
	Passengers AS p
	JOIN Tickets AS ti ON p.Id = ti.PassengerId
	JOIN Trains AS tr ON ti.TrainId = tr.Id
	JOIN Towns AS t ON tr.ArrivalTownId = T.Id 
WHERE ti.Price > 76.99

GROUP BY
		t.Name


--10.
SELECT 
	tr.Id,
	tw.Name,
	mr.Details
FROM
	MaintenanceRecords AS mr
	JOIN Trains AS tr ON mr.TrainId = tr.Id
	JOIN Towns AS tw ON tr.DepartureTownId  = tw.Id
WHERE Details LIKE '%inspection%'
ORDER BY
		tr.Id

--11.
CREATE FUNCTION udf_TownsWithTrains(@name VARCHAR(180)) 
RETURNS INT
AS
BEGIN
	DECLARE @result INT;
	SELECT
	@result = 	COUNT(Id)
	FROM 
		Trains 
	WHERE DepartureTownId IN (SELECT Id FROM Towns WHERE Name = @name) 
			OR ArrivalTownId IN (SELECT Id FROM Towns WHERE Name = @name)
	RETURN @result
END

SELECT dbo.udf_TownsWithTrains('Paris')

--12.
CREATE PROCEDURE usp_SearchByTown(@townName VARCHAR (180)) 
AS
BEGIN
	SELECT
		p.Name,
		ti.DateOfDeparture,
		tr.HourOfDeparture
	FROM
		Passengers AS p
		JOIN Tickets AS ti ON p.Id = ti.PassengerId
		JOIN Trains AS tr ON ti.TrainId = tr.Id
		JOIN Towns AS t ON tr.ArrivalTownId = t.Id 
	WHERE t.Name = @townName
	ORDER BY 
		ti.DateOfDeparture DESC,
		p.Name
END

EXEC usp_SearchByTown 'Berlin'