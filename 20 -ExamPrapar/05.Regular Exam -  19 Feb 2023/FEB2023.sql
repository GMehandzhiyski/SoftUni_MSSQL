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
