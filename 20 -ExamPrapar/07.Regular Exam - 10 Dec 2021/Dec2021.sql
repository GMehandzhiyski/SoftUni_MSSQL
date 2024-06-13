CREATE DATABASE Airport
USE Airport
GO
--01.

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName NVARCHAR(100) NOT NULL UNIQUE,
	Email NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL UNIQUE,
	LastName NVARCHAR(30) NOT NULL UNIQUE,
	Age TINYINT  NOT NULL CHECK(Age BETWEEN 21 AND 62),
	Rating FLOAT CHECK(Rating BETWEEN 0.0 AND 10.0),
)


CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
	TypeName NVARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer NVARCHAR(25) NOT NULL,
	Model NVARCHAR(30) NOT NULL,
	Year INT NOT NULL,
	FlightHours INT ,
	Condition CHAR(1) NOT NULL,
	TypeId INT NOT NULL,
	FOREIGN KEY (TypeId) REFERENCES AircraftTypes(Id)
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT NOT NULL,
	PilotId INT NOT NULL,
	PRIMARY KEY(AircraftId, PilotId),
	FOREIGN KEY (AircraftId) REFERENCES Aircraft(Id),
	FOREIGN KEY (PilotId) REFERENCES Pilots(Id),
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
	AirportName NVARCHAR(70) NOT NULL UNIQUE,
	Country NVARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT NOT NULL,
	FOREIGN KEY (AirportId) REFERENCES Airports(Id),
	[Start] DATETIME  NOT NULL,
	AircraftId INT  NOT NULL,
	FOREIGN KEY (AircraftId) REFERENCES Aircraft(Id),
	PassengerId INT  NOT NULL,
	FOREIGN KEY (PassengerId) REFERENCES Passengers(Id),
	TicketPrice DECIMAL(18,2) NOT NULL DEFAULT 15
)


--02.

BEGIN TRANSACTION

INSERT INTO Passengers (FullName, Email)
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    CONCAT(FirstName, LastName, '@gmail.com') AS Email
FROM 
    Pilots
WHERE 
    Id BETWEEN 5 AND 15;


ROLLBACK TRANSACTION


--03.
BEGIN TRANSACTION

--SELECT
--*
--FROM Aircraft
UPDATE Aircraft
	SET Condition = 'A'
WHERE Condition LIKE '[BC]'
		AND (FlightHours IS NULL OR FlightHours <= 100)
		AND [Year] >= 2013

ROLLBACK TRANSACTION


--04.
BEGIN TRANSACTION
DELETE Passengers
WHERE LEN(FullName) <= 10 
ROLLBACK TRANSACTION

--05.

SELECT
	Manufacturer,
	Model,
	FlightHours,
	Condition
FROM
	Aircraft
ORDER BY
	FlightHours DESC

--06.
SELECT
	FirstName,
	LastName,
	Manufacturer,
	Model,
	FlightHours
FROM
	Pilots AS p
	JOIN PilotsAircraft AS ps on p.Id = ps.PilotId
	JOIN Aircraft AS a ON ps.AircraftId = a.Id
WHERE FlightHours IS NOT NULL
		AND FlightHours < 304
ORDER BY
	FlightHours DESC,
	FirstName
	
	
--07.
SELECT TOP 20
	fd.Id,
	fd.Start,
	p.FullName,
	a.AirportName,
	fd.TicketPrice

FROM
	FlightDestinations AS fd
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Airports AS a ON fd.AirportId = a.Id
WHERE DAY(Start) % 2 = 0
ORDER BY
	fd.TicketPrice DESC,
	a.AirportName

--08. 
SELECT
	a.Id,
	a.Manufacturer,
	a.FlightHours,
	COUNT(fd.Id) AS FlightDestinationsCount,
	ROUND(AVG(fd.TicketPrice), 2)
FROM
	Aircraft AS a
	JOIN FlightDestinations AS fd ON a.Id = fd.AircraftId
GROUP BY
	a.Id,
	a.Manufacturer,
	a.FlightHours
HAVING COUNT(fd.AircraftId) >= 2
ORDER BY
	COUNT(fd.Id) DESC,
	a.Id

--09.
