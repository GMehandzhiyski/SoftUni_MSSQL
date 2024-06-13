CREATE DATABASE CigarShop
USE CigarShop
GO

--01.
CREATE TABLE Sizes
(
	Id INT PRIMARY KEY IDENTITY,
	[Length] INT NOT NULL CHECK ([Length] BETWEEN 10 AND 25),
	RingRange DECIMAL(18,2) NOT NULL CHECK (RingRange BETWEEN 1.5 AND 7.5)
)

CREATE TABLE Tastes
(
	Id INT PRIMARY KEY IDENTITY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands
(
	Id INT PRIMARY KEY IDENTITY,
	BrandName VARCHAR(30) NOT NULL,
	BrandDescription VARCHAR(MAX),

)

CREATE TABLE Cigars
(
	Id INT PRIMARY KEY IDENTITY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT NOT NULL,
	FOREIGN KEY (BrandId) REFERENCES Brands(Id),
	TastId INT NOT NULL,
	FOREIGN KEY (TastId) REFERENCES Tastes(Id),
	SizeId INT NOT NULL,
	FOREIGN KEY (SizeId) REFERENCES Sizes(Id),
	PriceForSingleCigar DECIMAL NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	Town VARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT NOT NULL,
	FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)


CREATE TABLE ClientsCigars
(
	ClientId INT NOT NULL,
	CigarId INT NOT NULL,
	PRIMARY KEY (ClientId,CigarId),
	FOREIGN KEY (ClientId) REFERENCES Clients(Id),
	FOREIGN KEY (CigarId) REFERENCES Cigars(Id),
)

--02.
INSERT INTO Cigars (CigarName,	BrandId,	TastId,	SizeId,	PriceForSingleCigar,	ImageURL)
		VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50,	'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00,	'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE',	14,	5,	11,	7.50,	'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN',	14,	4,	15,	32.00,	'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES',	2,	3,	8,	85.21,	'trinidad-coloniales-stick_30.jpg')


INSERT INTO  Addresses(Town,	Country,	Streat,	ZIP)
		VALUES
('Sofia',	'Bulgaria',	'18 Bul. Vasil levski',	1000),
('Athens',	'Greece',	'4342 McDonald Avenue',	10435),
('Zagreb',	'Croatia',	'4333 Lauren Drive',	10000)

--03.
BEGIN TRANSACTION

UPDATE	Cigars 
	SET PriceForSingleCigar = PriceForSingleCigar * 1.2	
WHERE TastId IN (SELECT Id FROM Tastes WHERE TasteType = 'Spicy')


UPDATE Brands
	SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

ROLLBACK TRANSACTION

--04.
BEGIN TRANSACTION

DELETE
	Clients
WHERE AddressId IN (SELECT Id FROM Addresses WHERE Country LIKE 'C%' )

DELETE
	Addresses
WHERE Country LIKE 'C%' 

ROLLBACK TRANSACTION



--05.
SELECT
	CigarName,
	PriceForSingleCigar,
	ImageURL

FROM
	 Cigars
ORDER BY 
	PriceForSingleCigar,
	CigarName DESC

--06.
SELECT
	c.Id,
	c.CigarName,
	c.PriceForSingleCigar,
	t.TasteType,
	t.TasteStrength

FROM
	Cigars AS c
	JOIN Tastes AS t ON c.TastId = t.Id
WHERE t.TasteType = 'Earthy'
		OR t.TasteType = 'Woody'
ORDER BY
	PriceForSingleCigar DESC

--07.
SELECT
	cl.Id,
	CONCAT_WS(' ', cl.FirstName, cl.LastName) AS ClientName,
	cl.Email

FROM 
	Clients AS cl
	LEFT JOIN ClientsCigars AS cc ON cl.Id = cc.ClientId
	LEFT JOIN Cigars AS ci ON cc.CigarId = ci.Id
WHERE cc.CigarId IS NULL
GROUP BY
	cl.Id,
	cl.Email,
	cl.FirstName, 
	cl.LastName
ORDER BY 
	CONCAT_WS(' ', cl.FirstName, cl.LastName)
	
--08.
SELECT  TOP 5
	ci.CigarName,
	ci.PriceForSingleCigar,
	ci.ImageURL
FROM
	Cigars AS ci
	JOIN Sizes AS s ON ci.SizeId = s.Id
WHERE s.Length >= 12 AND (ci.CigarName LIKE '%ci%'
		OR  ci.PriceForSingleCigar > 50) AND s.RingRange > 2.55
ORDER BY
	ci.CigarName,
	ci.PriceForSingleCigar DESC

--09.
SELECT
	CONCAT_WS(' ' , cl.FirstName, cl.LastName) AS FullName,
	a.Country,
	a.ZIP,
	 CONCAT('$',(MAX(ci.PriceForSingleCigar))) AS CigarPrice

FROM
	Clients AS cl
	JOIN  Addresses AS a ON cl.AddressId = a.Id
	JOIN ClientsCigars AS cc ON cl.Id = cc.ClientId
	JOIN Cigars AS ci ON  cc.CigarId = ci.Id
WHERE a.ZIP LIKE '%[0-9]%'  
	 AND a.ZIP NOT LIKE '%[^0-9]%'  
GROUP BY
	a.Country,
	a.ZIP,
	cl.FirstName,
	cl.LastName
ORDER BY
	CONCAT_WS(' ' , cl.FirstName, cl.LastName)
	
--10.
SELECT 
	cl.LastName,
	AVG(s.Length) AS CiagrLength,
	CEILING (AVG(s.RingRange))
FROM 
	Clients AS cl
	JOIN ClientsCigars AS cc ON cl.Id = cc.ClientId
	JOIN Cigars AS ci ON  cc.CigarId = ci.Id
	JOIN Sizes AS s ON ci.SizeId = s.Id
GROUP BY
	cl.LastName
ORDER BY
	AVG(s.Length) DESC



