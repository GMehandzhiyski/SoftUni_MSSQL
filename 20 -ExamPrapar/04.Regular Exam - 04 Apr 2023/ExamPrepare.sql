CREATE DATABASE Accounting
USE Accounting
GO



CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(20) NOT NULL,
	StreetNumber INT,
	PostCode INT NOT NULL,
	City VARCHAR(25) NOT NULL,
	CountryId INT NOT NULL,
	FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Vendors 
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25)NOT NULL,
	NumberVAT NVARCHAR(15)NOT NULL,
	AddressId INT NOT NULL,
	FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT NOT NULL,
	FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(10) NOT NULL
)


CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	Price DECIMAL(18,2) NOT NULL,
	CategoryId INT NOT NULL,
	FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	VendorId INT NOT NULL,
	FOREIGN KEY (VendorId) REFERENCES Vendors(Id)
)


CREATE TABLE Invoices
(
	Id INT PRIMARY KEY IDENTITY,
	Number INT NOT NULL,
	IssueDate DATETIME2 NOT NULL,
	DueDate DATETIME2 NOT NULL,
	Amount DECIMAL(18,2) NOT NULL,
	Currency VARCHAR(5) NOT NULL,
	ClientId INT NOT NULL,
	FOREIGN KEY (ClientId) REFERENCES Clients(Id)
)


CREATE TABLE ProductsClients
(
	ProductId INT NOT NULL,
	ClientId INT NOT NULL,
	PRIMARY KEY (ProductId,ClientId),
	FOREIGN KEY (ProductId) REFERENCES Products(Id),
	FOREIGN KEY (ClientId)REFERENCES Clients(Id)
)
--02.
INSERT INTO Products(Name,	Price,	CategoryId,	VendorId)
	VALUES
		('SCANIA Oil Filter XD01',	78.69,	1,	1),
		('MAN Air Filter XD01',	97.38,	1,	5),
		('DAF Light Bulb 05FG87',	55.00,	2,	13),
		('ADR Shoes 47-47.5',	49.85,	3,	5),
		('Anti-slip pads S',	5.87,	5,	7)

INSERT INTO Invoices(Number,	IssueDate,	DueDate,	Amount,	Currency,	ClientId)
	VALUES
	('1219992181',	'2023-03-01',	'2023-04-30',	180.96,	'BGN',	 3),
	('1729252340',	'2022-11-06',	'2023-01-04',	158.18,	'EUR',	13),
	('1950101013',	'2023-02-17',	'2023-04-18',	615.15,	'USD',	19)
	
--03.

BEGIN TRANSACTION
UPDATE Invoices
	SET DueDate = '2023-04-01'
WHERE Year(IssueDate) = 2022 AND Month(IssueDate) = 11

ROLLBACK TRANSACTION

BEGIN TRANSACTION

UPDATE Clients
	 SET AddressId = 3
WHERE [Name] LIKE '%CO%'


ROLLBACK TRANSACTION



--04.
BEGIN TRANSACTION

DELETE
ProductsClients
WHERE ClientId IN
			(
				SELECT 
					Id
				FROM
					Clients
				WHERE NumberVAT LIKE 'IT%'
			)


DELETE
Invoices
WHERE ClientId IN
			(
				SELECT 
					Id
				FROM
					Clients
				WHERE NumberVAT LIKE 'IT%'
			)

DELETE
Clients
WHERE NumberVAT LIKE 'IT%'

ROLLBACK TRANSACTION


--05.
SELECT
	Number,
	Currency
FROM 
	Invoices
ORDER BY
	Amount DESC,
	DueDate

--06.
SELECT 
	p.Id,
	p.[Name],
	p.Price,
	c.Name
FROM
	Products AS p
	JOIN Categories AS c ON	p.CategoryId = c.Id
WHERE c.[Name] = 'ADR'
		OR c.[Name] = 'Others'
ORDER BY
	Price DESC

--07.
SELECT
	c.Id,
	c.[Name],
	CONCAT_WS(', ', CONCAT_WS(' ',a.StreetName, a.StreetNumber), a.City, a.PostCode, co.Name )
FROM
	Clients AS c
	LEFT JOIN ProductsClients AS pc ON pc.ClientId = c.Id
	LEFT JOIN Products AS p ON pc.ProductId = p.Id
	JOIN Addresses AS a ON c.AddressId = a.Id
	JOIN Countries AS co ON	a.CountryId = co.Id
WHERE pc.ProductId IS NULL
ORDER BY
	c.[Name]
	
--08.
SELECT TOP 7
	i.Number,
	i.Amount,
	c.[Name] AS Client
FROM
	Invoices AS i
	JOIN Clients AS c ON I.ClientId = c.Id
WHERE (YEAR(IssueDate) < 2023
		AND i.Currency = 'EUR')
		OR (i.Amount > 500.00
		AND c.NumberVAT LIKE 'DE%')
ORDER BY 
	i.Number,
	i.Amount DESC
