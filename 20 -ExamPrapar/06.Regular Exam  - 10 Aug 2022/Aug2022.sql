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