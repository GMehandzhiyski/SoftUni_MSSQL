CREATE DATABASE LibraryDb
USE LibraryDb
GO

--01.
CREATE TABLE Contacts
(
    Id INT PRIMARY KEY IDENTITY,
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    PostAddress NVARCHAR(200),
    Website NVARCHAR(50)
);

CREATE TABLE Authors
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
);

CREATE TABLE Genres
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(30) NOT NULL
);

CREATE TABLE Libraries
(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
);

CREATE TABLE Books
(
    Id INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100) NOT NULL,
    YearPublished INT NOT NULL,
    ISBN NVARCHAR(13) UNIQUE NOT NULL,
    AuthorId INT NOT NULL,
    GenreId INT NOT NULL,
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
    FOREIGN KEY (GenreId) REFERENCES Genres(Id)
);

CREATE TABLE LibrariesBooks
(
    LibraryId INT NOT NULL,
    BookId INT NOT NULL,
    PRIMARY KEY (LibraryId, BookId),
    FOREIGN KEY (LibraryId) REFERENCES Libraries(Id),
    FOREIGN KEY (BookId) REFERENCES Books(Id)
);


--02.
SET IDENTITY_INSERT Contacts ON;

INSERT INTO Contacts (Id,	Email,	PhoneNumber, PostAddress,	Website)
	VALUES
(21,	NULL,	NULL,	NULL,	NULL),
(22,	NULL,	NULL,	NULL,	NULL),
(23,	'stephen.king@example.com',	'+4445556666',	'15 Fiction Ave, Bangor, ME',	'www.stephenking.com'),
(24,	'suzanne.collins@example.com',	'+7778889999',	'10 Mockingbird Ln, NY, NY',	'www.suzannecollins.com')

SET IDENTITY_INSERT Contacts OFF;


SET IDENTITY_INSERT Authors ON;
INSERT INTO Authors(Id,	Name,	ContactId)
	VALUES
(16,	'George Orwell',	21),
(17,	'Aldous Huxley',	22),
(18,	'Stephen King',	23),
(19,	'Suzanne Collins',	24)
SET IDENTITY_INSERT Authors OFF;

SET IDENTITY_INSERT Books ON;
INSERT INTO Books(Id,	Title,	YearPublished,	ISBN,	AuthorId,	GenreId)
	VALUES
(36,	'1984',	1949,	'9780451524935',	16,	2),
(37,	'Animal Farm',	1945,	'9780451526342',		16,	2),
(38,	'Brave New World',	1932,	'9780060850524',	17,	2),
(39,	'The Doors of Perception',	1954,	'9780060850531',	17,	2),
(40,	'The Shining',	1977,	'9780307743657',	18,	9),
(41,	'It',	1986,	'9781501142970',	18,	9),
(42,	'The Hunger Games',	2008,	'9780439023481',	19,	7),
(43,	'Catching Fire',	2009,	'9780439023498',	19,	7),
(44,	'Mockingjay',	2010,	'9780439023511',	19,	7)
SET IDENTITY_INSERT Books OFF;

INSERT INTO LibrariesBooks(LibraryId,	BookId)
	VALUES
(1,	36),
(1,	37),
(2,	38),
(2,	39),
(3,	40),
(3,	41),
(4,	42),
(4,	43),
(5,	44)


--03.

BEGIN TRANSACTION

UPDATE c
	SET c.Website = 'www.' + LOWER(REPLACE(a.Name, ' ', '')) + '.com'
FROM Contacts c
	JOIN Authors a ON c.Id = a.ContactId
WHERE c.Website IS NULL

ROLLBACK TRANSACTION

--04.
BEGIN TRANSACTION
DELETE LibrariesBooks
WHERE BookId = (SELECT Id FROM Authors WHERE Name = 'Alex Michaelides' )

DELETE Books
WHERE AuthorId = (SELECT Id FROM Authors WHERE Name = 'Alex Michaelides' )

DELETE Authors
WHERE Name = 'Alex Michaelides' 

ROLLBACK TRANSACTION

SELECT * FROM Authors WHERE Name = 'Alex Michaelides' 

--05.
SELECT
	Title,
	ISBN,
	YearPublished
FROM 
	Books
ORDER BY 
	YearPublished DESC,
	Title

--06.
SELECT
	b.Id,
	b.Title,
	b.ISBN,
	g.Name
FROM
	Books AS b
	JOIN Genres AS g ON b.GenreId = g.Id
WHERE g.Name = 'Biography' 
		OR g.Name = 'Historical Fiction' 
ORDER BY
	g.Name, 
	b.Title

--07.
SELECT 
	l.Name,
	c.Email
FROM 
	Libraries l
	JOIN Contacts c ON l.ContactId = c.Id
WHERE l.Id NOT IN (SELECT lb.LibraryId FROM LibrariesBooks lb
										JOIN Books b ON lb.BookId = b.Id
										JOIN Genres g ON b.GenreId = g.Id
										WHERE g.Name = 'Mystery')
ORDER BY 
	l.Name ASC

--08.
SELECT TOP 3
	b.Title,
	b.YearPublished,
	g.Name
FROM 
	Books AS b
	JOIN Genres AS g ON b.GenreId = g.Id
WHERE (b.YearPublished > 2000 AND b.Title LIKE '%a%')
		OR (b.YearPublished < 1950 AND g.Name LIKE '%Fantasy%')
ORDER BY
	b.Title,
	YearPublished DESC

--09.
SELECT 
	a.Name,
	c.Email,
	c.PostAddress
FROM 
	Authors AS a
	JOIN Contacts AS c ON a.ContactId = c.Id
WHERE c.PostAddress LIKE '%UK%'
ORDER BY
	a.Name

--10.
SELECT
	a.Name,
	b.Title,
	l.Name,
	c.PostAddress
FROM 
	Books AS b
	JOIN Genres AS g ON b.GenreId = g.Id
	JOIN LibrariesBooks AS lb ON b.Id = lb.BookId
	JOIN Libraries AS l ON lb.LibraryId = l.Id
	JOIN Contacts AS c ON l.ContactId = c.Id
	JOIN Authors AS a ON b.AuthorId = a.Id

WHERE g.Name = 'Fiction'
		AND c.PostAddress LIKE '%Denver%'
ORDER BY
	b.Title

--11.
CREATE FUNCTION udf_AuthorsWithBooks(@name VARCHAR (120)) 
RETURNS INT
AS
BEGIN 
	DECLARE @result INT
	SELECT
		@result = COUNT(lb.BookId)
	FROM
		Books AS b
		JOIN LibrariesBooks AS lb ON b.Id = lb.BookId
		JOIN Libraries AS l ON lb.LibraryId = l.Id
		JOIN Authors AS a ON b.AuthorId = a.Id
	WHERE a.Name = @name
	
	RETURN @result
END

SELECT dbo.udf_AuthorsWithBooks('J.K. Rowling')

--12.
CREATE PROCEDURE usp_SearchByGenre(@genreName VARCHAR(120))
AS
BEGIN
	SELECT 
		b.Title,
		b.YearPublished,
		b.ISBN,
		a.Name,
		g.Name
	FROM
		Books AS b
		JOIN Genres AS g ON b.GenreId = g.Id
		JOIN Authors AS a ON b.AuthorId = a.Id
	WHERE g.Name = @genreName
	ORDER BY
		b.Title
END
EXEC usp_SearchByGenre 'Fantasy'