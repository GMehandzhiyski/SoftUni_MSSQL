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
	,[LastLoginTime] DATETIME2
	,[IsDeleted] BIT
)

INSERT INTO [Users] ([Username], [Password])
			VALUES ('Georgi', 'ggg')
					,('Pesho', 'cgg')
					,('Tosho', 'agg')
					,('Georgi', 'sgg')
					,('Ivan', 'hgg')

SELECT * FROM [Users]