 --01. Crate DataBase
 CREATE DATABASE [Minions]
 USE Minions
 GO

 --02. Create Tables
 CREATE TABLE [Minions]
 (
	[Id] INT PRIMARY KEY,
	[Name]	VARCHAR(50),
	[Age] INT
 )
 CREATE TABLE [Towns]
 (
	[Id] INT PRIMARY KEY,
	[Name]	VARCHAR(50)
 )

 --03. Alter Minions Table
 ALTER TABLE [Minions]
 ADD [TownId] INT

 ALTER TABLE [Minions]
 ADD FOREIGN KEY (TownId) REFERENCES [Towns](Id)


 --04. Insert Records in Both Tables
 INSERT INTO [Towns] ([Id], [Name])
	VALUES (1, 'Sofia')
			,(2, 'Plovdiv')
			,(3, 'Varna')


 INSERT INTO [Minions] ([Id], [Name], [Age], [TownId])
	VALUES	(1, 'Kevin', 22, 1)
			,(2, 'Bob', 15, 3)
			,(3, 'Steward', NULL, 2)
 
 --05. Truncate Table Minions
  TRUNCATE TABLE [Minions]
  
  --06. Drop All Tables
  DROP TABLE [Minions]
  DROP TABLE [Towns]
	--DROP TABLE[People]

  --07. Create Table People
CREATE TABLE [People]
  (
	[Id]  INT PRIMARY KEY IDENTITY(1, 1)
	,[Name] NVARCHAR(200) NOT NULL
	,[Picture] VARBINARY(MAX)
	,[Height] DECIMAL (3,2)
	,[Weight] DECIMAL (5,2)
	,[Gender] CHAR (1) NOT NULL
				CHECK (Gender IN('m', 'f'))
	,[Birthdate] DATETIME2 NOT NULL
	,[Biography] VARCHAR(MAX)
  )

INSERT INTO [People] ([Name], [Gender], [Birthdate])
			VALUES ('Georgi', 'm', '1990-01-12')
					,('Peter', 'm', '1991-01-12')
					,('Ivana', 'f', '1991-12-12')
					,('Penka', 'f', '1995-12-25')
					,('Tosho', 'm', '1996-10-22')


SELECT * FROM [People]
DROP TABLE[People] 


--08.	Create Table Users
TRUNCATE TABLE [Users]
CREATE TABLE [Users]
(
	[Id] BIGINT PRIMARY KEY IDENTITY(1, 1)
	,[Username] VARCHAR(30) NOT NULL
	,[Password] VARCHAR(26) NOT NULL
	,[ProfilePicture] VARBINARY(MAX)
	,[LastLoginTime] DATETIME DEFAULT GETDATE()
	,[IsDeleted] BIT
)

INSERT INTO [Users] ([Username], [Password])
			VALUES ('Georgi', 'gggggg')
					,('Pesho', 'cgggggg')
					,('Tosho', 'aggggg')
					,('Georgi', 'sggggg')
					,('Ivan', 'hgggggg')



--09.	Change Primary Key
ALTER TABLE [Users]
DROP CONSTRAINT [PK__Users__3214EC075A69CD5C]

ALTER TABLE [Users]
ADD CONSTRAINT PK_UserTable PRIMARY KEY (Id, Username)

--10.	Add Check Constraint
ALTER TABLE [Users]
ADD CONSTRAINT CHK_PasswordIsAtleastFiveSymbols
				CHECK(LEN([Password]) >= 5)

INSERT INTO [Users] ([Username], [Password])
				VALUES ('pETKO', 'GGGGGGG')

--11.	Set Default Value of a Field	
UPDATE [Users]
SET LastLoginTime = GETDATE()
WHERE LastLoginTime IS NULL

 INSERT INTO [Users] ([Username], [Password], [LastLoginTime])
			VALUES ('GSSeorSSgi', 'gggggg', GETDATE())

SELECT * FROM [Users]

--12.	Set Unique Field

ALTER TABLE [Users]
DROP CONSTRAINT [PK_UserTable]

ALTER TABLE[Users]
ADD CONSTRAINT [PK_UserTable] PRIMARY KEY (Id)

ALTER TABLE [Users]
ADD CONSTRAINT CHK_UserNameLong3Symbols
				CHECK (LEN([Username]) >= 3)

INSERT INTO [Users] ([Username], [Password], [LastLoginTime])
			VALUES ('Gsi', 'gggggg', GETDATE())


--13.	Movies Database
DROP TABLE[Directors]
DROP TABLE[Genres]
DROP TABLE[Categories]
DROP TABLE [Movies]
TRUNCATE TABLE[Directors]

CREATE DATABASE [Movies]
USE Movies
GO

CREATE TABLE [Directors] 
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL
	,[DirectorName] VARCHAR(255)
	,[Notes] VARCHAR(MAX)
)

CREATE TABLE [Genres]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL
	,[GenerName] VARCHAR(255)
	,[Notes] VARCHAR(MAX)
)

CREATE TABLE [Categories] 
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL
	,[CategoryName] VARCHAR(255)
	,[Notes] VARCHAR(MAX)
)

CREATE TABLE [Movies]  
(
	[Id] INT IDENTITY NOT NULL
	,[Title] VARCHAR(50)
	,[DirectorId] INT FOREIGN KEY REFERENCES [Directors](Id)
	,[CopyrightYear] SMALLINT
	,[Length] FLOAT
	,[GenreId] INT  FOREIGN KEY REFERENCES [Genres](Id)
	,[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id)
	,[Rating] DECIMAL(3,1)
	,[Notes] VARCHAR(MAX)
)

INSERT INTO [Directors] ([DirectorName], [Notes])
		VALUES 
		('IVAN iVANOV', NULL)
		,('dRAGAN iVANOV', 'ASDASD' )
		,('STEFAN iVANOV', 'ASDASASDSAD')
		,('PETYR PETROV', 'ASDADSASASAD')
		,('TSVETOMIV P', 'SADASDA')

INSERT INTO [Genres] ([GenerName])
		VALUES 
		('FUNNY')
		,('SCARE' )
		,('ACTION')
		,('HISTORYCAL')
		,('COMEDDY')

INSERT INTO [Categories] ([CategoryName])
		VALUES 
		('ANIMAL')
		,('WOMAN' )
		,('MEN')
		,('KID')
		,('ALL')

INSERT INTO [Movies] ([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes])
		VALUES
		('MOVIE 1', 1, 1990, 60, 1, 1, 1.2, 'sas')
		,('MOVIE 2', 2, 1990, 70, 2, 2, 2.3, 'sas')
		,('MOVIE 3', 3, 1992, 80, 3, 3, 3.4, 'sas')
		,('MOVIE 4', 4, 1993, 90, 4, 4, 4.5, 'sas')
		,('MOVIE 5', 5, 1994, 100, 5, 5, 5.6, 'sas')


SELECT * FROM [Movies]
TRUNCATE TABLE Movies


--14.	Car Rental Database-----------------------------------------------------------------------------------------
CREATE DATABASE [CarRental1] 
USE CarRental1
GO


CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[CategoryName]  VARCHAR(255)
	,[DailyRate] INT
	,[WeeklyRate] INT
	,[MonthlyRate] INT
	,[Weeked=ndRate] INT
)

CREATE TABLE [Cars]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[PlateNumber]  VARCHAR(255)
	,[Manufacturer] VARCHAR (255)
	,[Model] VARCHAR (255)
	,[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id)
	,[Doors] INT
	,[Pictures] VARBINARY(MAX)
	,[Condition] INT
	,[Available] BIT
)

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] VARCHAR(255)
	,[LastName] VARCHAR(255)
	,[Title] VARCHAR(255)
	,[Notes] VARCHAR(MAX)
)


CREATE TABLE [Customers]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[DriverLicenceNumber] INT 
	,[FullName] VARCHAR(255)
	,[Address] VARCHAR(255)
	,[City] VARCHAR(255)
	,[ZIPCode] INT 
	,[Notes] VARCHAR(MAX)
)

CREATE TABLE [RentalOrders]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id)
	,[CustomerId] INT FOREIGN KEY REFERENCES [Customers](Id)
	,[CarId] INT FOREIGN KEY REFERENCES [Cars](Id)
	,[TankLevel] FLOAT
	,[KilometrageStart]INT
	,[KilometrageEnd] INT
	,[TotalKilometrage] INT
	,[StartDate] DATETIME2
	,[EndDate] DATETIME2
	,[TotalDays] INT
	,[RateApplied] INT
	,[TaxRate] FLOAT
	,[OrderStatus] VARCHAR
	,[Notes] VARCHAR
)

INSERT INTO [Categories] ([CategoryName], [MonthlyRate])
		VALUES
			('CAR', 200)
			,('TRUCK', 300)
			,('BUS', 500)


INSERT INTO [Cars]  ([PlateNumber], [Model], [CategoryId], [Doors], [Condition])
		VALUES
			('SC2345MV', 'VW', 1 , 2 ,5)
			,('CB4519KM', 'CITROEN', 2, 4, 10)
			,('PB2920IC','MAN', 3, 3, 20)

INSERT INTO [Employees]([FirstName], [LastName])
		VALUES
			('IVAN', 'IVANOV')
			,('PETYR', 'PETROV')
			,('STOYAN', 'GEORGIEV')

INSERT INTO [Customers]([DriverLicenceNumber], [FullName],[ZIPCode]) 
		VALUES
			(1234, 'IVAN IVANOV', 4000)
			,(5234, 'PETYR IVANOV', 4012)
			,(1324, 'PETYR PETROV', 1000)

INSERT INTO [RentalOrders]([EmployeeId], [CustomerId], [CarId], [TankLevel], [KilometrageStart], [TotalDays], [TaxRate])
		VALUES 
			(1, 1, 1, 100, 200, 3, 300.0)
			,(2, 2, 2, 200, 300, 4, 400.0)
			,(3, 3, 3, 300, 400, 5, 500.0)

SELECT * FROM [RentalOrders]


--15. Hotel Database-----------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE [Hotel]
USE [Hotel]
GO

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[FirstName] VARCHAR(255)
	,[LastName] VARCHAR(255)
	,[Title] VARCHAR(255)
	,[Notes] VARCHAR(MAX)
)



CREATE TABLE [Customers] 
(
	[AccountNumber] INT PRIMARY KEY IDENTITY
	,[FirstName] VARCHAR(255)
	,[LastName] VARCHAR(255)
	,[PhoneNumber] INT
	,[EmergencyName] VARCHAR(255)
	,[EmergencyNumber] INT
	,[Notes] VARCHAR(255)
)




CREATE TABLE [RoomStatus]
(
	[RoomStatus] CHAR (4)
					CHECK([RoomStatus] IN('busy', 'free'))
	,[Notes] VARCHAR(255)
)


CREATE TABLE[RoomTypes]
(
	[RoomType] CHAR (1)
					CHECK([RoomType] IN('A', 'S', 'R'))
	,[Notes] VARCHAR(255)
)


CREATE TABLE [BedTypes]
(
	[BedType] CHAR (8)
				CHECK ([BedType] IN ('1 person','2 person', '3 person'))
	,[Notes] VARCHAR(255)
)


CREATE TABLE [Rooms]
(
	[RoomNumber] INT
	,[RoomType] CHAR (1)
	,[BedType] CHAR (8)
	,[Rate] FLOAT
	,[RoomStatus] CHAR(4)
	,[Notes] VARCHAR(255)

)



CREATE TABLE [Payments]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id)
	,[PaymentDate] DATETIME2
	,[AccountNumber] INT
	,[FirstDateOccupied] DATETIME2
	,[LastDateOccupied] DATETIME2
	,[TotalDays] INT
	,[AmountCharged] DECIMAL(5,2)
	,[TaxRate] DECIMAL(5,2)
	,[TaxAmount] DECIMAL(5,2)
	,[PaymentTotal] DECIMAL(5,2)
	,[Notes] VARCHAR(255)
)



CREATE TABLE[Occupancies]
(
	[Id] INT PRIMARY KEY IDENTITY
	,[EmployeeId] INT FOREIGN KEY REFERENCES [Employees](Id)
	,[DateOccupied] DATETIME2
	,[AccountNumber] INT
	,[RoomNumber] INT
	,[RateApplied] DECIMAL(2,1)
	,[PhoneCharge] DECIMAL(2,1)
	,[Notes] VARCHAR(255)
)
INSERT INTO [Employees] ([FirstName], [LastName])
		VALUES 
			('IVAN', 'IVANOV')
			,('PETYR', 'PETROV')
			,('GEORGI', 'GEORGIEV')

INSERT INTO [Customers] ([FirstName], [LastName], [PhoneNumber])
		VALUES
			('ivan', 'ivanov', 093928)
			,('petyr', 'petrov', 989879)
			,('georgi', 'georgiev', 0932339)

INSERT INTO[RoomStatus] ([RoomStatus])
		VALUES 
			('busy')
			, ('free')

INSERT INTO[RoomTypes] ([RoomType], [Notes])
		VALUES 
			('A', 'APARTAMENT')
			, ('S', 'STUDIO')
			,('R', 'ROOM')

INSERT INTO[BedTypes] ([BedType])
		VALUES 
			('1 person')
			, ('2 person')
			,('3 person')

INSERT INTO [Rooms]([RoomNumber], [RoomType], [BedType], [RoomStatus])
		VALUES
			(12, 'A', '1 person', 'free')
			,(13, 'S', '2 person', 'busy')
			,(14, 'R', '1 person', 'free')

			
INSERT INTO [Payments] ([EmployeeId], [AccountNumber], [TotalDays], [AmountCharged], [PaymentTotal])
		VALUES
			(1, 123, 5, 234.32, 340.45)
			,(2, 124, 6, 236.32, 345.45)
			,(3, 125, 7, 238.32, 350.45)

INSERT INTO [Occupancies]([EmployeeId],[AccountNumber],[RoomNumber], [RateApplied],  [PhoneCharge])
		VALUES 
			(1, 2323, 12, 2.1, 5.1)
			,(1, 4523, 13, 5.1, 8.1)
			,(1, 5523, 13, 7.1, 9.1)

SELECT * FROM [Occupancies]


--16.	Create SoftUni Database------------------------------------------------------------------------------------------------
CREATE DATABASE [SoftUni]
USE SoftUni
GO

CREATE TABLE [Towns]
(
	[Id] INT PRIMARY KEY IDENTITY(1,1)
	,[Name] VARCHAR(255)
)

CREATE TABLE [Addresses]
(
	[Id] INT PRIMARY KEY IDENTITY(1,1)
	,[AddressText] VARCHAR(255)
	,[TownId] INT FOREIGN KEY REFERENCES [Towns](Id)
)

CREATE TABLE [Departments]
(
	[Id] INT PRIMARY KEY IDENTITY(1,1)
	,[Name] VARCHAR(255)
)

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY(1,1)
	,[FirstName] VARCHAR(255)
	,[MidlleName] VARCHAR(255)
	,[LastName] VARCHAR(255)
	,[JobTitle] VARCHAR(255)
	,[DepartmentId] INT FOREIGN KEY REFERENCES [Departments](Id)
	,[HireDate] VARCHAR(255)
	,[Salary] DECIMAL(6,2)
	,[AddressId] INT FOREIGN KEY REFERENCES [Addresses](Id)

)