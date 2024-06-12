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
