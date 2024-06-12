CREATE DATABASE NationalTouristSitesOfBulgaria
USE NationalTouristSitesOfBulgaria
GO

--01.
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
	Province VARCHAR(50)
)


CREATE TABLE Sites
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT NOT NULL,
	FOREIGN KEY (LocationId) REFERENCES Locations(Id),
	CategoryId INT NOT NULL,
	FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	Establishment VARCHAR(15)

)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Age INT NOT NULL
		CHECK(Age BETWEEN 0 AND 120),
	PhoneNumber VARCHAR(20)NOT NULL,
	Nationality VARCHAR(30)NOT NULL,
	Reward VARCHAR(20)

)


CREATE TABLE SitesTourists
(
	TouristId INT NOT NULL,
	SiteId INT NOT NULL,
	PRIMARY KEY (TouristId, SiteId),
	FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
	FOREIGN KEY (SiteId) REFERENCES Sites(Id)
)

CREATE TABLE BonusPrizes
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes
(
	TouristId INT NOT NULL,
	BonusPrizeId INT NOT NULL,
	PRIMARY KEY (TouristId,BonusPrizeId),
	FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
	FOREIGN KEY (BonusPrizeId) REFERENCES BonusPrizes(Id)
)

--02.
INSERT INTO Tourists(Name,	Age,	PhoneNumber,	Nationality,	Reward)
	VALUES
	('Borislava Kazakova',	52,	'+359896354244',	'Bulgaria',	NULL),
	('Peter Bosh',	48,	'+447911844141',	'UK',	NULL),
	('Martin Smith',	29,	'+353863818592',	'Ireland',	'Bronze badge'),
	('Svilen Dobrev',	49,	'+359986584786',	'Bulgaria',	'Silver badge'),
	('Kremena Popova',	38,	'+359893298604',	'Bulgaria',	NULL)

INSERT INTO Sites(Name,	LocationId,	CategoryId,	Establishment)
	VALUES
('Ustra fortress',	90,	7,	'X'),
('Karlanovo Pyramids',	65,	7,	NULL),
('The Tomb of Tsar Sevt',	63,	8,	'V BC'),
('Sinite Kamani Natural Park',	17,	1,	NULL),
('St. Petka of Bulgaria – Rupite',	92,	6,	'1994')

--03.
BEGIN TRANSACTION
UPDATE Sites
	SET Establishment = '(not defined)'
WHERE Establishment IS NULL
ROLLBACK TRANSACTION

--04.
BEGIN TRANSACTION

DELETE
TouristsBonusPrizes
WHERE BonusPrizeId IN (SELECT Id FROM BonusPrizes WHERE Name = 'Sleeping bag ')

DELETE
BonusPrizes
WHERE Id IN (SELECT Id FROM BonusPrizes WHERE Name = 'Sleeping bag ')


ROLLBACK TRANSACTION


--05.
SELECT
	Name,
	Age,
	PhoneNumber,
	Nationality
FROM
Tourists
ORDER BY
	Nationality,
	Age DESC,
	Name 

--06.
SELECT 
	s.Name,
	l.Name,
	s.Establishment,
	c.Name
FROM
	Sites AS s
	JOIN Categories AS c ON s.CategoryId = c.Id
	JOIN Locations AS l ON s.LocationId = l.Id
ORDER BY
	c.Name DESC,
	l.Name,
	s.Name

--07.
SELECT 
	l.Province,
	l.Municipality,
	l.[Name],
	COUNT(s.Id)
FROM
	Sites AS s
	JOIN Locations AS l ON s.LocationId = l.Id
WHERE Province = 'Sofia'
GROUP BY
	l.Province,
	l.Municipality,
	l.[Name]
ORDER BY 
	COUNT(s.Id) DESC,
	l.Name

--08.
SELECT 
	s.Name,
	l.Name,
	l.Municipality,
	l.Province,
	s.Establishment
FROM
	Sites AS s
	JOIN Locations AS l ON s.LocationId = l.Id
WHERE l.Name NOT LIKE '[BMD]%'
				AND s.Establishment LIKE '%BC'
ORDER BY
	s.Name

--09.
SELECT 
	t.Name,
	t.Age,
	t.PhoneNumber,
	t.Nationality,
	ISNULL(bp.Name, '(no bonus prize)')
FROM
	Tourists AS t
	LEFT JOIN TouristsBonusPrizes AS tb ON t.Id = tb.TouristId
	LEFT JOIN BonusPrizes AS bp ON tb.BonusPrizeId = bp.Id
ORDER BY
	t.Name

--10.
SELECT 
	DISTINCT SUBSTRING(t.Name, CHARINDEX(' ',t.Name)+1, LEN(t.Name)),
	t.Nationality,
	t.Age,
	t.PhoneNumber
FROM
	Tourists AS t
	JOIN SitesTourists AS st ON t.Id = st.TouristId
	JOIN Sites AS s ON st.SiteId = s.Id
	JOIN Categories AS c ON s.CategoryId = c.Id
WHERE c.Name = 'History and archaeology'
ORDER BY
	SUBSTRING(t.Name, CHARINDEX(' ',t.Name)+1, LEN(t.Name))

SELECT * FROM Categories

--11.
CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(180)) 
RETURNS INT
AS
BEGIN
	DECLARE @result INT
	SELECT 
		@result  = COUNT(t.Id)
	FROM 
	 Tourists AS t
		JOIN SitesTourists AS st ON t.Id = st.TouristId
		JOIN Sites AS s ON st.SiteId = s.Id
	WHERE s.Name = @Site
	RETURN @result
END
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Gorge of Erma River')

--12.

BEGIN TRANSACTION


CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(120))
AS
BEGIN
	IF (SELECT COUNT(t.Id) FROM 
					Sites AS s
					JOIN SitesTourists AS st ON s.Id = st.SiteId
					JOIN Tourists AS t ON st.TouristId = t.Id
				WHERE t.Name = @TouristName) >= 100
		BEGIN
				UPDATE Tourists
					Set Reward = 'Gold badge'
				WHERE Name = @TouristName
					
			
		END
	ELSE IF (SELECT COUNT(t.Id) FROM 
					Sites AS s
					JOIN SitesTourists AS st ON s.Id = st.SiteId
					JOIN Tourists AS t ON st.TouristId = t.Id
				WHERE t.Name = @TouristName) >= 50
		BEGIN
			UPDATE Tourists
					Set Reward = 'Silver badge'
				WHERE Name = @TouristName
					
		END
	ELSE IF (SELECT COUNT(t.Id) FROM 
					Sites AS s
					JOIN SitesTourists AS st ON s.Id = st.SiteId
					JOIN Tourists AS t ON st.TouristId = t.Id
				WHERE t.Name = @TouristName) >= 25
		BEGIN 
				UPDATE Tourists
					Set Reward = 'Bronze badge'
				WHERE Name = @TouristName
					
		END
SELECT Name, Reward FROM Tourists
WHERE Name = @TouristName
END

ROLLBACK TRANSACTION

SELECT 
	COUNT(t.Id)
FROM 
	Sites AS s
	JOIN SitesTourists AS st ON s.Id = st.SiteId
	JOIN Tourists AS t ON st.TouristId = t.Id
		WHERE t.Name = 'Zac Walsh'