CREATE DATABASE Boardgames
USE Boardgames
GO

--01.
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	AddressId INT NOT NULL,
	FOREIGN KEY (AddressId) REFERENCES Addresses(Id),
	Website NVARCHAR(40),
	Phone NVARCHAR(20)
)

CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT  NULL
)



CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(18,2) NOT NULL,
	CategoryId INT NOT NULL,
	PublisherId INT NOT NULL,
	PlayersRangeId INT NOT NULL,
	FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	FOREIGN KEY (PublisherId) REFERENCES Publishers(Id),
	FOREIGN KEY (PlayersRangeId) REFERENCES PlayersRanges(Id)
)


CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30)NOT NULL,
	LastName NVARCHAR(30)NOT NULL,
	Email NVARCHAR(30)NOT NULL
)

CREATE TABLE CreatorsBoardgames
(
	CreatorId INT,
	BoardgameId INT,
	PRIMARY KEY(CreatorId,BoardgameId),
	FOREIGN KEY (CreatorId) REFERENCES Creators(Id),
	FOREIGN KEY (BoardgameId) REFERENCES Boardgames(Id)
)


--02.
INSERT INTO Boardgames([Name],	YearPublished,	Rating,	CategoryId,	PublisherId,	PlayersRangeId)
		VALUES
('Deep Blue', 2019,	5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1,	5),
('Catan: Starfarers', 2021,	9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25,	3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)


INSERT INTO Publishers([Name], AddressId, Website, Phone)
	VALUES 
('Agman Games',	5,	'www.agmangames.com',	'+16546135542'),
('Amethyst Games',	7,	'www.amethystgames.com',	'+15558889992'),
('BattleBooks',	13,	'www.battlebooks.com',	'+12345678907')


--03.
BEGIN TRANSACTION
UPDATE PlayersRanges
	SET PlayersMax += 1 
WHERE PlayersMin = 2
		AND PlayersMax = 2

UPDATE Boardgames
	SET [Name] = CONCAT([Name],'V2')
WHERE YearPublished >= 2020

ROLLBACK TRANSACTION

--04.

BEGIN TRANSACTION
DELETE 
CreatorsBoardgames WHERE BoardgameId IN (1,16,31,47)
DELETE 
Boardgames WHERE PublisherId IN (1,16)

DELETE Publishers
WHERE AddressId IN (SELECT Id FROM Addresses WHERE Town LIKE 'L%')

DELETE
FROM Addresses
WHERE Town LIKE 'L%'

ROLLBACK TRANSACTION

--05.
SELECT
	[Name],
	Rating
FROM 
Boardgames
ORDER BY
	YearPublished,
	[Name] DESC
--06.
SELECT
	b.Id,
	b.[Name],
	b.YearPublished,
	c.[Name] AS CategoryName
FROM 
	Boardgames AS b
	JOIN Categories AS c ON b.CategoryId = c.Id
WHERE c.[Name] = 'Strategy Games' 
				OR c.[Name] ='Wargames' 
ORDER BY
	YearPublished DESC

--07.
SELECT 
	c.Id,
	CONCAT_WS(' ',c.FirstName, c.LastName) AS CreatorName,
	c.Email
FROM
	Creators AS c
	LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
	LEFT JOIN Boardgames AS b ON cb.BoardgameId = B.Id
WHERE cb.BoardgameId IS NULL
ORDER BY
	CONCAT_WS(' ',c.FirstName, c.LastName)
	