CREATE DATABASE TouristAgency 
USE TouristAgency 
GO

--01.

CREATE TABLE Countries (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL
);


CREATE TABLE Destinations (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    CountryId INT NOT NULL,
	FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);

CREATE TABLE Rooms (
    Id INT PRIMARY KEY IDENTITY,
    Type NVARCHAR(40) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    BedCount INT NOT NULL, CHECK (BedCount > 0 AND BedCount <= 10)
);


CREATE TABLE Hotels (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    DestinationId INT NOT NULL,
	FOREIGN KEY (DestinationId) REFERENCES Destinations(Id)
);


CREATE TABLE Tourists (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(80) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    Email NVARCHAR(80),
    CountryId INT NOT NULL,
	FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);


CREATE TABLE Bookings (
    Id INT PRIMARY KEY IDENTITY,
    ArrivalDate DATETIME2 NOT NULL,
    DepartureDate DATETIME2 NOT NULL,
    AdultsCount INT NOT NULL CHECK (AdultsCount >= 1 AND AdultsCount <= 10),
    ChildrenCount INT NOT NULL CHECK (ChildrenCount >= 0 AND ChildrenCount <= 9),
    TouristId INT NOT NULL,
	FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
    HotelId INT NOT NULL,
	FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
    RoomId INT NOT NULL,
	FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
);

CREATE TABLE HotelsRooms (
    HotelId INT NOT NULL,
    RoomId INT NOT NULL,
    PRIMARY KEY (HotelId, RoomId),
    FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
);


--02.

INSERT INTO Tourists(Name,	PhoneNumber,	Email,	CountryId)
	VALUES
('John Rivers',	'653-551-1555',	'john.rivers@example.com',	6),
('Adeline Agla�',	'122-654-8726',	'adeline.aglae@example.com',	2),
('Sergio Ramirez',	'233-465-2876',	's.ramirez@example.com',	3),
('Johan M�ller',	'322-876-9826',	'j.muller@example.com',	7),
('Eden Smith',	'551-874-2234',	'eden.smith@example.com',	6)
						
INSERT INTO Bookings (ArrivalDate,	DepartureDate,	AdultsCount,	ChildrenCount,	TouristId,	HotelId,	RoomId)
	VALUES
('2024-03-01',	'2024-03-11',	1,	0,	21,	3,	5),
('2023-12-28',	'2024-01-06',	2,	1,	22,	13,	3),
('2023-11-15',	'2023-11-20',	1,	2,	23,	19,	7),
('2023-12-05',	'2023-12-09',	4,	0,	24,	6,	4),
('2024-05-01',	'2024-05-07',	6,	0,	25,	14,	6)


--03.
BEGIN TRANSACTION
UPDATE Bookings
	SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE DepartureDate LIKE '2023-12%'

UPDATE Tourists
	SET Email = NULL
WHERE Name LIKE '%MA%'
ROLLBACK TRANSACTION

--04.
BEGIN TRANSACTION

DELETE Bookings
WHERE TouristId IN(SELECT Id FROM Tourists WHERE Name LIKE '%Smith%')

DELETE Tourists
WHERE Name LIKE '%Smith%'
ROLLBACK TRANSACTION