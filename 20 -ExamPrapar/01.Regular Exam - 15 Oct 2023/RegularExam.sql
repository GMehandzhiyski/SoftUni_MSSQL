CREATE DATABASE TouristAgency 

--01.
CREATE TABLE Countries
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[CountryId] INT FOREIGN KEY REFERENCES [Countries](Id) NOT NULL
)


CREATE TABLE Rooms
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(40) NOT NULL,
	[Price] DECIMAL(18,2) NOT NULL,
	[BedCount] INT NOT NULL
			CHECK([BedCount] > 0 
				AND [BedCount] <= 10 )
)


CREATE TABLE Hotels
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[DestinationId] INT FOREIGN KEY REFERENCES [Destinations](id) NOT NULL
)

CREATE TABLE Tourists
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL,
	[PhoneNumber] VARCHAR(20) NOT NULL,
	[Email] VARCHAR(80),
	[CountryId] INT FOREIGN KEY REFERENCES [Countries](Id) NOT NULL
)

CREATE TABLE Bookings
(
	[Id] INT PRIMARY KEY IDENTITY,
	[ArrivalDate] DATETIME2 NOT NULL,
	[DepartureDate] DATETIME2 NOT NULL,
	[AdultsCount] INT  NOT NULL
			CHECK([AdultsCount] >= 1
					AND [AdultsCount] <=10),
	[ChildrenCount] INT NOT NULL
			CHECK([ChildrenCount] >= 0
					AND [ChildrenCount]<=9),
	[TouristId] INT FOREIGN KEY REFERENCES [Tourists](Id) NOT NULL,
	[HotelId] INT FOREIGN KEY REFERENCES [Hotels](Id) NOT NULL,
	[RoomId] INT FOREIGN KEY REFERENCES [Rooms](Id) NOT NULL
)

CREATE TABLE HotelsRooms
(
	[HotelId] INT  NOT NULL,
	[RoomId] INT NOT NULL,
	CONSTRAINT PR_HotelRooms PRIMARY KEY (HotelId, RoomId),
	CONSTRAINT FK_HotelRooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
	CONSTRAINT FK_HotelRooms_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
)


--02.
INSERT INTO [Tourists]
	VALUES
		('John Rivers', '653-551-1555',	'john.rivers@example.com', 6),
		('Adeline Agla�', '122-654-8726',	'adeline.aglae@example.com', 2),
		('Sergio Ramirez', '233-465-2876',	's.ramirez@example.com', 3),
		('Johan M�ller', '322-876-9826',	'j.muller@example.com',	7),
		('Eden Smith', '551-874-2234',	'eden.smith@example.com', 6)

INSERT INTO [Bookings]
	VALUES
		('2024-03-01',	'2024-03-11',	1,	0,	21,	3,	5),
		('2023-12-28',	'2024-01-06',	2,	1,	22,	13,	3),
		('2023-11-15',	'2023-11-20',	1,	2,	23,	19,	7),
		('2023-12-05',	'2023-12-09',	4,	0,	24,	6,	4),
		('2024-05-01',	'2024-05-07',	6,	0,	25,	14,	6)

--03.
SELECT * FROM Bookings
UPDATE [Bookings]
	SET [DepartureDate] = DATEADD(DAY,1, DepartureDate)
WHERE [ArrivalDate] >='2023-12-01'
						AND [ArrivalDate] <='2023-12-31';

UPDATE [Tourists]
	SET [Email] = NULL
WHERE [Name] LIKE '%MA%';


--04.

DECLARE @TouristsForDelete TABLE (Id INT)

INSERT INTO @TouristsForDelete (Id)
SELECT Id
FROM [Tourists]
WHERE [Name]LIKE '%Smith%'

DELETE FROM [Bookings]
WHERE [TouristId] IN(SELECT Id FROM @TouristsForDelete)

DELETE FROM [Tourists]
WHERE [Id] IN(SELECT Id FROM @TouristsForDelete)

--05.
SELECT
	FORMAT([ArrivalDate],'yyyy-MM-dd') AS [ArrivalDate],
	[AdultsCount],
	[ChildrenCount]
FROM 
	[Bookings] AS b
	JOIN [Rooms] AS r ON b.RoomId = r.Id
ORDER BY 
	r.[Price] DESC,
	b.[ArrivalDate]

--06.
SELECT 
	h.[Id],
	[Name]
FROM
	[Hotels] AS h
	JOIN [HotelsRooms] AS hr ON h.Id = hr.HotelId
	JOIN [Rooms] AS r ON hr.RoomId = r.Id
	JOIN Bookings B ON h.Id = b.HotelId
WHERE r.[Type] = 'VIP Apartment'
GROUP BY 
	h.[Id],
	[Name]
ORDER BY
	COUNT(*) DESC;
	
--07.
SELECT 
	t.[Id],
	t.[Name],
	t.[PhoneNumber]
FROM
	[Tourists] AS t
	LEFT JOIN [Bookings] AS b ON t.Id = b.TouristId
WHERE b.[TouristId] IS NULL
ORDER BY 
	t.[Name]

---------------------------------------------------------------------
SELECT 
	[Id],
	[Name],
	[PhoneNumber]
FROM
	[Tourists]
WHERE [Id] NOT IN (SELECT [TouristId] FROM [Bookings] )
ORDER BY 
	[Name]

SELECT * FROM Bookings

--08.
SELECT TOP 10
	h.[Name] AS [HotelName],
	d.[Name] AS [DestinationName],
	c.[Name] AS [CountryName]
FROM
	[Bookings] AS b
	JOIN [Hotels] AS h ON b.[HotelId] = h.[Id]
	JOIN [Destinations] AS d ON h.DestinationId = d.Id
	JOIN [Countries] AS c ON d.CountryId = c.Id
WHERE [ArrivalDate] < '2023-12-31'
		AND h.[Id] % 2 != 0
ORDER BY 
	c.[Name],
	b.[ArrivalDate]

select * from Countries

--09.
SELECT 
	h.[Name],
	r.[Price]
FROM
	[Tourists] AS t
	JOIN [Bookings] AS b ON t.[Id] = b.[TouristId]	
	JOIN [Hotels] AS h ON b.[HotelId] = h.[Id]
	JOIN [Rooms] AS r ON b.[RoomId] = r.Id
WHERE t.[Name] NOT LIKE '%EZ' 
ORDER BY
	r.[Price] DESC

--10.
SELECT 
	h.[Name],
	SUM(r.[Price]*(DATEDIFF(DAY, [ArrivalDate], [DepartureDate]))) AS [HotelRevenue]
FROM
	[Bookings] AS b
	JOIN [Hotels] AS h ON b.HotelId = h.Id
	JOIN [Rooms] AS r ON b.RoomId = r.Id
GROUP BY
	h.[Name]
ORDER BY 
	[HotelRevenue] DESC


--11. 
CREATE OR ALTER FUNCTION udf_RoomsWithTourists(@name VARCHAR(80))
RETURNS INT 
AS
BEGIN
	DECLARE @Total INT

	SELECT 
		@Total = SUM([AdultsCount] + [ChildrenCount])
	FROM
		[Bookings] AS b
		JOIN [Rooms] AS r ON b.RoomId = r.Id
	WHERE r.[Type] = @name

	RETURN @Total
END

SELECT dbo.udf_RoomsWithTourists ('Double Room')


SELECT * FROM Bookings