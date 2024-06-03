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
 

SELECT * FROM Minions