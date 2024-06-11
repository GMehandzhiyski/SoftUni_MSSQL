CREATE DATABASE Zoo
USE Zoo
GO

--01.
CREATE TABLE Owners(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
Address VARCHAR(50)
)

CREATE TABLE AnimalTypes(
Id INT IDENTITY PRIMARY KEY,
AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages(
Id INT IDENTITY PRIMARY KEY,
AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id),
)

CREATE TABLE Animals(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(30) NOT NULL,
BirthDate DATE NOT NULL,
OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages(
CageId INT NOT NULL FOREIGN KEY REFERENCES Cages(Id),
AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id),
PRIMARY KEY (CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments(
Id INT IDENTITY PRIMARY KEY,
DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
Id INT IDENTITY PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
Address VARCHAR(50),
AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)

--02. 
INSERT INTO Volunteers(Name, PhoneNumber, Address, AnimalId, DepartmentId) VALUES
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals(Name, BirthDate, OwnerId, AnimalTypeId) VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)

--03.

UPDATE Animals
	SET OwnerId =
		(
			SELECT
				Id
			FROM 
				Owners
			WHERE [Name] =  'Kaloqn Stoqnov '
		)
WHERE OwnerId IS NULL

--04.
SELECT Id FROM
	VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

BEGIN TRANSACTION

DELETE
FROM 
	Volunteers
WHERE DepartmentId IN
(
SELECT Id FROM
	VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'
)

DELETE
FROM
	VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

ROLLBACK TRANSACTION
	
SELECT 
*
FROM 
	VolunteersDepartments



--05.
SELECT 
	[Name] ,
	PhoneNumber,
	[Address],
	AnimalId,
	DepartmentId
FROM
	Volunteers
ORDER BY
	[Name],
	AnimalId,
	DepartmentId

--06.
SELECT 
	an.[Name],
	aty.AnimalType,
	FORMAT(BirthDate, 'dd.MM.yyyy') AS BirthDate
FROM 
	Animals AS an
	JOIN AnimalTypes AS aty ON an.AnimalTypeId = aty.Id
ORDER BY 
	an.[Name]

--07.
SELECT top 5
	 ow.[Name] AS [Owner],
	COUNT(an.[Name]) AS CountOfAnimals
FROM
	Owners AS ow
	JOIN Animals AS an ON ow.Id = an.OwnerId
--WHERE [ow.Name] = 'Kaloqn Stoqnov' 
GROUP BY
	ow.[Name]
ORDER BY 
	CountOfAnimals DESC,
	[Owner]

--08.
SELECT
	CONCAT_WS('-', ow.[Name], an.[Name]) as OwnersAnimals,
	ow.PhoneNumber,
	ac.CageId AS CageId

FROM
	Owners AS ow
	JOIN Animals AS an ON ow.Id = an.OwnerId
	JOIN AnimalTypes AS aty ON an.AnimalTypeId = aty.Id
	JOIN AnimalsCages AS ac ON an.Id = ac.AnimalId
WHERE aty.AnimalType = 'mammals'
ORDER BY
	ow.[Name],
	an.[Name] DESC
	

SELECT
*
FROM
AnimalsCages











