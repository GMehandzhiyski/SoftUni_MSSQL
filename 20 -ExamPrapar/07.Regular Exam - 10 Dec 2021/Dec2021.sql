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
SELECT
	p.FullName,
	COUNT(AircraftId)AS CountOfAircraft,
	SUM(fd.TicketPrice)
FROM 
	Passengers AS p
	JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
	JOIN Aircraft AS a ON fd.AircraftId = a.Id
WHERE FullName LIKE '_a%'
GROUP BY 
		p.FullName
HAVING COUNT(AircraftId) >= 2

--10.
SELECT 
	ap.AirportName AS AirportName,
	fd.Start AS DayTime,
	fd.TicketPrice,
	p.FullName,
	ac.Manufacturer,
	ac.Model
FROM
	Passengers AS p
	JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
	JOIN Airports AS ap ON fd.AirportId = ap.Id
	JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
WHERE DATEPART(hour,fd.Start) BETWEEN 6 AND 20
	AND fd.TicketPrice >= 2500
ORDER BY
	ac.Model

--11.
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(200)) 
RETURNS INT
AS
BEGIN
	DECLARE @result INT
		SELECT
			@result = COUNT(PassengerId)
		FROM 
			FlightDestinations
		WHERE PassengerId IN (SELECT Id FROM Passengers WHERE Email = @email)
		RETURN @result
END
SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')



--12.
CREATE OR ALTER PROCEDURE usp_SearchByAirportName(@airportName VARCHAR(70))
AS
BEGIN
    SELECT
        ap.AirportName,
        p.FullName,
        CASE 
            WHEN fd.TicketPrice <= 400 THEN 'Low'
            WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
            ELSE 'High'
        END AS LevelOfTicketPrice,
        ac.Manufacturer,
        ac.Condition,
        aty.TypeName
    FROM
        Airports AS ap
    JOIN FlightDestinations AS fd ON ap.Id = fd.AirportId
    JOIN Passengers AS p ON fd.PassengerId = p.Id
    JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
    JOIN AircraftTypes AS aty ON ac.TypeId = aty.Id
    WHERE ap.AirportName = @airportName
    ORDER BY
        ac.Manufacturer,
        p.FullName

END

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'	
-------------------------------------------------------------------------------

SELECT
	fd.TicketPrice
FROM
	Airports AS ap
	JOIN FlightDestinations AS fd  ON ap.Id = fd.AirportId
WHERE AirportName = 'Sir Seretse Khama International Airport'





-----------------------------------------------------------------------------------

SELECT
	ap.AirportName,
	p.FullName,
	----LevelOfTickerPrice 
	ac.Manufacturer,
	ac.Condition,
	aty.TypeName

FROM
	Airports AS ap
	JOIN FlightDestinations AS fd  ON ap.Id = fd.AirportId
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
	JOIN AircraftTypes AS aty ON ac.TypeId = aty.Id
WHERE AirportName = 'Sir Seretse Khama International Airport'
		AND fd.TicketPrice <= 400
ORDER BY
	ac.Manufacturer,
	p.FullName