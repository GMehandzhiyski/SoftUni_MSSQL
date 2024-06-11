CREATE DATABASE RailwaysDb
USE  RailwaysDb
GO

--01.
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL
);

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
);

CREATE TABLE RailwayStations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	TownId INT  NOT NULL,
	FOREIGN KEY (TownId) REFERENCES Towns(Id)
);

CREATE TABLE Trains
(
	Id INT PRIMARY KEY IDENTITY,
	HourOfDeparture VARCHAR(5) NOT NULL,
	HourOfArrival VARCHAR(5) NOT NULL,
	DepartureTownId INT NOT NULL,
	FOREIGN KEY (DepartureTownId) REFERENCES Towns(Id),
	ArrivalTownId INT NOT NULL, 
	FOREIGN KEY (ArrivalTownId) REFERENCES Towns(Id)
);

CREATE TABLE TrainsRailwayStations
(
	TrainId INT NOT NULL,
	RailwayStationId INT NOT NULL,
	PRIMARY KEY(TrainId,RailwayStationId),
	FOREIGN KEY (TrainId) REFERENCES Trains(Id),
	FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)

);

CREATE TABLE MaintenanceRecords
(
	Id INT PRIMARY KEY IDENTITY,
	DateOfMaintenance DATE NOT NULL,
	Details VARCHAR(2000) NOT NULL,
	TrainId INT NOT NULL ,
	FOREIGN KEY (TrainId) REFERENCES Trains(Id)
);

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(18,2) NOT NULL,
	DateOfDeparture DATE NOT NULL,
	DateOfArrival DATE NOT NULL,
	TrainId INT NOT NULL,
	FOREIGN KEY (TrainId) REFERENCES Trains(Id),
	PassengerId INT NOT NULL,
	FOREIGN KEY (PassengerId) REFERENCES Passengers(Id)
);

--02.

INSERT INTO Trains(HourOfDeparture,	HourOfArrival,	DepartureTownId,	ArrivalTownId)
	VALUES	
		('07:00', '19:00',	1,	3),
		('08:30', '20:30',	5,	6),
		('09:00', '21:00',	4,	8),
		('06:45', '03:55',	27,	7),
		('10:15', '12:15',	15, 5)


INSERT INTO TrainsRailwayStations(TrainId,	RailwayStationId)
	VALUES
		(36, 1),
		(36, 4),
		(36, 31),
		(36, 57),
		(36, 7),
		(37, 13),
		(37, 54),
		(37, 60),
		(37, 16),
		(38, 10),
		(38, 50),
		(38, 52),
		(38, 22),
		(39, 68),
		(39, 3),
		(39, 31),
		(39, 19),
		(40, 41),
		(40, 7),
		(40, 52),
		(40, 13)

INSERT INTO Tickets(Price,	DateOfDeparture,	DateOfArrival,	TrainId,	PassengerId)
	VALUES
		(90.00	,'2023-12-01',	'2023-12-01',	36,	 1),
		(115.00	,'2023-08-02',	'2023-08-02',	37,	 2),
		(160.00	,'2023-08-03',	'2023-08-03',	38,	 3),
		(255.00	,'2023-09-01',	'2023-09-02',	39,	21),
		(95.00	,'2023-09-02',	'2023-09-03',	40,	22)

SELECT * FROM Tickets

--03.
UPDATE Tickets
	SET
		DateOfDeparture = DATEADD(DAY, 7, DateOfDeparture),
		DateOfArrival = DATEADD(DAY, 7, DateOfArrival )
WHERE DateOfDeparture >'2023-10-31'

--04. 

BEGIN TRANSACTION

DELETE
FROM
	Tickets
WHERE TrainId IN
(
	SELECT
		Id
	FROM
		Trains
	WHERE DepartureTownId = (SELECT Id FROM Towns WHERE [Name] = 'Berlin')
)

DELETE
FROM 
	MaintenanceRecords
WHERE TrainId IN
(
	SELECT
		Id
	FROM
		Trains
	WHERE DepartureTownId = (SELECT Id FROM Towns WHERE [Name] = 'Berlin')
)


DELETE
FROM 
	TrainsRailwayStations
WHERE TrainId IN
(
	SELECT
		Id
	FROM
		Trains
	WHERE DepartureTownId = (SELECT Id FROM Towns WHERE [Name] = 'Berlin')
)

DELETE
FROM 
	Trains
WHERE DepartureTownId = (SELECT Id FROM Towns WHERE [Name] = 'Berlin')


ROLLBACK TRANSACTION 


SELECT
	Id
FROM 
	Trains
WHERE DepartureTownId = (SELECT Id FROM Towns WHERE [Name] = 'Berlin')