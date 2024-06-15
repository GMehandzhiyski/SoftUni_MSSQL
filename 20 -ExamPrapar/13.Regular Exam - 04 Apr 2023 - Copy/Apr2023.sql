CREATE DATABASE Accounting 
USE Accounting 
GO

--01.
CREATE TABLE Countries
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(10) NOT NULL
);

CREATE TABLE Addresses
(
    Id INT PRIMARY KEY IDENTITY,
    StreetName NVARCHAR(20) NOT NULL,
    StreetNumber INT NULL,
    PostCode INT NOT NULL,
    City NVARCHAR(25) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);

CREATE TABLE Vendors
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(25) NOT NULL,
    NumberVAT NVARCHAR(15) NOT NULL,
    AddressId INT NOT NULL,
    FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
);

CREATE TABLE Clients
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(25) NOT NULL,
    NumberVAT NVARCHAR(15) NOT NULL,
    AddressId INT NOT NULL,
    FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
);

CREATE TABLE Categories
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(10) NOT NULL
);

CREATE TABLE Products
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(35) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    CategoryId INT NOT NULL,
    VendorId INT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (VendorId) REFERENCES Vendors(Id)
);

CREATE TABLE Invoices
(
    Id INT PRIMARY KEY IDENTITY,
    Number INT UNIQUE NOT NULL,
    IssueDate DATETIME2 NOT NULL,
    DueDate DATETIME2 NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    Currency NVARCHAR(5) NOT NULL,
    ClientId INT NOT NULL,
    FOREIGN KEY (ClientId) REFERENCES Clients(Id)
);

CREATE TABLE ProductsClients
(
    ProductId INT NOT NULL,
    ClientId INT NOT NULL,
    PRIMARY KEY (ProductId, ClientId),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (ClientId) REFERENCES Clients(Id)
);


--02.
INSERT INTO Products(Name,	Price,	CategoryId,	VendorId)
	VALUES
('SCANIA Oil Filter XD01',	78.69,	1,	1),
('MAN Air Filter XD01',	97.38,	1,	5),
('DAF Light Bulb 05FG87',	55.00,	2,	13),
('ADR Shoes 47-47.5',	49.85,	3,	5),
('Anti-slip pads S',	5.87,	5,	7)

INSERT INTO Invoices (Number,	IssueDate,	DueDate,	Amount,	Currency,	ClientId)
	VALUES
(1219992181,	'2023-03-01',	'2023-04-30',	180.96,	'BGN',	3),
(1729252340,	'2022-11-06',	'2023-01-04',	158.18,	'EUR',	13)

--03.
BEGIN TRANSACTION

UPDATE	Invoices
	SET DueDate = '2023-04-01'
WHERE IssueDate LIKE '2022-11%'

UPDATE Clients
	SET AddressId = (SELECT Id FROM  Addresses  WHERE StreetName = 'Industriestr')
WHERE Name LIKE '%CO%'

ROLLBACK TRANSACTION


--04.
BEGIN TRANSACTION

DELETE ProductsClients
WHERE ClientId = (SELECT Id FROM Clients WHERE NumberVAT LIKE 'IT%')

DELETE Invoices
WHERE ClientId = (SELECT Id FROM Clients WHERE NumberVAT LIKE 'IT%')

DELETE Clients
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

