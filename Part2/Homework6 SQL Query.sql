CREATE DATABASE Academy2
GO
USE Academy2
GO

Create TABLE Curators(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE Faculties(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
)

Create TABLE Departments(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
	FacultyId INT NOT NULL,
	FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
)

Create TABLE Groups(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
	[Year] INT NOT NULL CHECK ([Year] BETWEEN 1 AND 5),
	DepartmentId INT NOT NULL,
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
)

Create TABLE GroupsCurators(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	CuratorId INT NOT NULL,
	GroupId INT NOT NULL,
	FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
	FOREIGN KEY (GroupId) REFERENCES Groups(Id)
)

Create TABLE Subjects(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
)

Create TABLE Teachers(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IsProfessor BIT NOT NULL DEFAULT 0,
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Salary MONEY NOT NULL CHECK (Salary > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE Lectures(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Date] DATE NOT NULL CHECK ([Date] <= GETDATE()),
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE GroupsLectures(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GroupId INT NOT NULL,
	LectureId INT NOT NULL,
	FOREIGN KEY (GroupId) REFERENCES Groups(Id),
	FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
)

Create TABLE Students(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE GroupsStudents(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GroupId INT NOT NULL,
	StudentId INT NOT NULL,
	FOREIGN KEY (GroupId) REFERENCES Groups(Id),
	FOREIGN KEY (StudentId) REFERENCES Students(Id)
)
GO

--INSERTS (evvel esas cedveller, sonra elaqeli cedveller)
INSERT INTO Faculties (Name) VALUES
	('Computer Science'),
	('Economics'),
	('Law')

INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES
	(1, 60000, 'Software Development', 1),
	(1, 55000, 'Computer Science', 1),
	(2, 30000, 'Information Systems', 1),
	(3, 45000, 'Accounting', 2),
	(3, 20000, 'Finance', 2),
	(4, 15000, 'Civil Law', 3),
	(5, 10000, 'Criminal Law', 3)

INSERT INTO Curators (Name, Surname) VALUES
	('Jack', 'Miller'),
	('Emma', 'Clark'),
	('Daniel', 'Wilson'),
	('Olivia', 'Brown'),
	('Peter', 'Hall'),
	('Sophia', 'Young')

INSERT INTO Groups (Name, [Year], DepartmentId) VALUES
	('P107', 5, 1),
	('P108', 5, 1),
	('D221', 3, 2),
	('D222', 2, 2),
	('S301', 4, 3),
	('A105', 5, 4),
	('F201', 1, 5),
	('L401', 2, 6),
	('C101', 1, 7)

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
	(1, 1),
	(2, 1),
	(3, 2),
	(4, 3),
	(5, 3),
	(6, 4),
	(1, 5),
	(2, 6),
	(3, 7),
	(4, 8),
	(5, 9)

INSERT INTO Students (Name, Rating, Surname) VALUES
	('Aysel', 5, 'Aliyeva'),
	('Orxan', 4, 'Mammadov'),
	('Leyla', 5, 'Hasanova'),
	('Rauf', 3, 'Guliyev'),
	('Nigar', 4, 'Ismayilova'),
	('Elvin', 2, 'Jafarov'),
	('Gunel', 3, 'Rzayeva'),
	('Tural', 4, 'Huseynov'),
	('Sevinc', 5, 'Abdullayeva'),
	('Murad', 2, 'Karimov'),
	('Aynur', 3, 'Safarova'),
	('Kamran', 1, 'Nasirov'),
	('Zahra', 4, 'Bagirova'),
	('Farid', 3, 'Mustafayev'),
	('Nurlan', 1, 'Ahmadov'),
	('Samira', 4, 'Valiyeva')

INSERT INTO GroupsStudents (GroupId, StudentId) VALUES
	(1, 1), (1, 2),
	(2, 3), (2, 4),
	(3, 5), (3, 6),
	(4, 7), (4, 8),
	(5, 9), (5, 10),
	(6, 11), (6, 12),
	(7, 13), (7, 14),
	(8, 15),
	(9, 16)

INSERT INTO Teachers (IsProfessor, Name, Salary, Surname) VALUES
	(1, 'Samantha', 3000, 'Adams'),
	(1, 'John', 2800, 'Smith'),
	(0, 'Dave', 3200, 'McQueen'),
	(0, 'Linda', 1800, 'Taylor'),
	(1, 'Mark', 2600, 'Evans'),
	(0, 'Anna', 2000, 'Brown')

INSERT INTO Subjects (Name) VALUES
	('Database Theory'),
	('Programming'),
	('Algorithms'),
	('Accounting Basics'),
	('Civil Law'),
	('Economics')

INSERT INTO Lectures ([Date], SubjectId, TeacherId) VALUES
	('2025-09-01', 1, 1),
	('2025-09-01', 2, 2),
	('2025-09-02', 3, 3),
	('2025-09-02', 1, 1),
	('2025-09-03', 2, 2),
	('2025-09-03', 3, 3),
	('2025-09-04', 1, 1),
	('2025-09-04', 2, 5),
	('2025-09-05', 3, 3),
	('2025-09-05', 1, 1),
	('2025-09-06', 2, 2),
	('2025-09-06', 3, 6),
	('2025-09-10', 4, 4),
	('2025-09-11', 4, 4),
	('2025-09-12', 5, 6),
	('2025-09-15', 6, 5),
	('2025-09-16', 6, 5),
	('2025-09-17', 1, 1),
	('2025-09-18', 4, 6),
	('2025-09-19', 1, 2)

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
	(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
	(1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12),
	(2, 1), (2, 3), (2, 5), (2, 7), (2, 18),
	(3, 16), (3, 17),
	(4, 15),
	(5, 13), (5, 14),
	(6, 19),
	(7, 20),
	(8, 15),
	(9, 16)
GO

--1. Departamentlerinin umumi maliyyesi 100000-den cox olan binalarin nomreleri
SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing) > 100000

--2. Software Development kafedrasinin 5-ci kurs qruplari (ilk hefte 10-dan cox cut ders)
--Her mühazire bir cut ders sayilir, ilk hefte = en ilk mühazire tarixinden 7 gun
SELECT G.Name
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN GroupsLectures GL ON GL.GroupId = G.Id
JOIN Lectures L ON GL.LectureId = L.Id
WHERE G.[Year] = 5
	AND D.Name = 'Software Development'
	AND L.[Date] BETWEEN (SELECT MIN([Date]) FROM Lectures)
		AND DATEADD(DAY, 6, (SELECT MIN([Date]) FROM Lectures))
GROUP BY G.Id, G.Name
HAVING COUNT(*) > 10

--3. Reytinqi D221 qrupunun reytinqinden yuksek olan qruplar
SELECT G.Name
FROM Groups G
JOIN GroupsStudents GS ON GS.GroupId = G.Id
JOIN Students S ON GS.StudentId = S.Id
GROUP BY G.Id, G.Name
HAVING AVG(S.Rating * 1.0) > (
	SELECT AVG(S2.Rating * 1.0)
	FROM Groups G2
	JOIN GroupsStudents GS2 ON GS2.GroupId = G2.Id
	JOIN Students S2 ON GS2.StudentId = S2.Id
	WHERE G2.Name = 'D221'
)

--4. Maasi professorlarin orta maasindan yuksek olan muellimler
SELECT Name + ' ' + Surname AS Teacher_Name
FROM Teachers
WHERE Salary > (
	SELECT AVG(Salary)
	FROM Teachers
	WHERE IsProfessor = 1
)

--5. Birden cox kuratoru olan qruplar
SELECT G.Name
FROM Groups G
JOIN GroupsCurators GC ON GC.GroupId = G.Id
GROUP BY G.Id, G.Name
HAVING COUNT(GC.CuratorId) > 1

--6. Reytinqi 5-ci kurs qruplarinin minimum reytinqinden asagi olan qruplar
SELECT G.Name
FROM Groups G
JOIN GroupsStudents GS ON GS.GroupId = G.Id
JOIN Students S ON GS.StudentId = S.Id
GROUP BY G.Id, G.Name
HAVING AVG(S.Rating * 1.0) < (
	SELECT MIN(Group_Rating)
	FROM (
		SELECT AVG(S2.Rating * 1.0) AS Group_Rating
		FROM Groups G2
		JOIN GroupsStudents GS2 ON GS2.GroupId = G2.Id
		JOIN Students S2 ON GS2.StudentId = S2.Id
		WHERE G2.[Year] = 5
		GROUP BY G2.Id
	) AS Year5_Ratings
)

--7. Kafedralarin umumi maliyyesi Computer Science kafedrasinin maliyyesinden cox olan fakulteler
SELECT F.Name
FROM Faculties F
JOIN Departments D ON D.FacultyId = F.Id
GROUP BY F.Id, F.Name
HAVING SUM(D.Financing) > (
	SELECT Financing
	FROM Departments
	WHERE Name = 'Computer Science'
)

--8. Her fenn uzre en cox mühazire deyen muellim
SELECT S.Name AS Subject_Name, T.Name + ' ' + T.Surname AS Teacher_Name
FROM Lectures L
JOIN Subjects S ON L.SubjectId = S.Id
JOIN Teachers T ON L.TeacherId = T.Id
GROUP BY S.Id, S.Name, T.Id, T.Name, T.Surname
HAVING COUNT(*) = (
	SELECT MAX(Lecture_Count)
	FROM (
		SELECT COUNT(*) AS Lecture_Count
		FROM Lectures L2
		WHERE L2.SubjectId = S.Id
		GROUP BY L2.TeacherId
	) AS Teacher_Counts
)

--9. En az mühazire kecilen fenn
SELECT S.Name
FROM Subjects S
JOIN Lectures L ON L.SubjectId = S.Id
GROUP BY S.Id, S.Name
HAVING COUNT(*) = (
	SELECT MIN(Lecture_Count)
	FROM (
		SELECT COUNT(*) AS Lecture_Count
		FROM Lectures
		GROUP BY SubjectId
	) AS Subject_Counts
)

--10. Software Development kafedrasinda telebe ve fenn sayi
SELECT
	(SELECT COUNT(DISTINCT GS.StudentId)
	 FROM Groups G
	 JOIN Departments D ON G.DepartmentId = D.Id
	 JOIN GroupsStudents GS ON GS.GroupId = G.Id
	 WHERE D.Name = 'Software Development') AS Student_Count,
	(SELECT COUNT(DISTINCT L.SubjectId)
	 FROM Groups G
	 JOIN Departments D ON G.DepartmentId = D.Id
	 JOIN GroupsLectures GL ON GL.GroupId = G.Id
	 JOIN Lectures L ON GL.LectureId = L.Id
	 WHERE D.Name = 'Software Development') AS Subject_Count
