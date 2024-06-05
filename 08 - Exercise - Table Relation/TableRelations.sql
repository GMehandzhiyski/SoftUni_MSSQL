CREATE DATABASE Relations
USE Relations
--01.
CREATE TABLE [Passports]
(	
	[PassportID] INT PRIMARY KEY IDENTITY(101,1),
	[PassportNumber] VARCHAR(32) NOT NULL
)

CREATE TABLE [Persons]
(
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(32) NOT NULL,
	[Salary] DECIMAL(10,2),
	[PassportID] INT FOREIGN KEY REFERENCES [Passports]
)

INSERT INTO [Passports] ([PassportNumber])
		VALUES('N34FG21B'),
			 ('K65LO4R7'),
			 ('ZE657QP2')

INSERT INTO [Persons] ([FirstName], [Salary], [PassportID] )
		VALUES('Roberto',43300,102),
			 ('Tom',56100, 103),
			 ('Yana', 60200,101)

--02.
CREATE TABLE [Manufacturers]
(
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(20),
	[EstablishedOn] DATETIME2
)

CREATE TABLE [Models]
(
	[ModelID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30),
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]
)

INSERT INTO [Manufacturers]
	VALUES ('BMW', '07/03/1916'),
			('Tesla', '01/01/2003'),
			('Lada', '01/05/1966')

INSERT INTO[Models]
	VALUES ('X1', 1),
			('i6', 1),
			('Model S', 2),
			('Model X', 2),
			('Model 3', 2),
			('Nova', 3)

--03.
CREATE TABLE [Students]
(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(20) 
)

CREATE TABLE [Exams]
(
	[ExamID] INT PRIMARY KEY IDENTITY(101,1),
	[Name] VARCHAR(20),
)

CREATE TABLE [StudentsExams]
(
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID])
	CONSTRAINT PK_StudentsExams PRIMARY KEY([StudentID],[ExamID]) -- COMPOSITE KEY
)

INSERT INTO [Students] 
		VALUES('Mila'),
			 ('Toni'),
			 ('Ron')

INSERT INTO [Exams] 
		VALUES('SpringMVC'),
			 ('Neo4j'),
			 ('Oracle 11g')

INSERT INTO [StudentsExams] 
		VALUES(1,101),
			 (1,102),
			 (2,101),
			 (3,103),
			 (2,102),
			 (2,103)
	
select * from StudentsExams