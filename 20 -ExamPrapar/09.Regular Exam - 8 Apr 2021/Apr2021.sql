CREATE DATABASE Service
USE Service
GO

--01.

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(50) NOT NULL,
	Name VARCHAR(50),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 14 AND 110),
	Email VARCHAR(50) NOT NULL
);

CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
);


CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate  DATETIME,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT, 
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL,
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


CREATE TABLE Status
(
	Id INT PRIMARY KEY IDENTITY,
	Label VARCHAR(20) NOT NULL
);

CREATE TABLE Reports
(
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT NOT NULL,
	FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	StatusId INT NOT NULL,
	FOREIGN KEY (StatusId) REFERENCES Status(Id),
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	Description VARCHAR(200)NOT NULL,
	UserId INT  NOT NULL,
	FOREIGN KEY (UserId) REFERENCES Users(Id),
	EmployeeId INT,
	FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
);

--02.