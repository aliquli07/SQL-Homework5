CREATE DATABASE Course
GO
USE Course
GO

Create TABLE Curators(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE Faculties(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
)

Create TABLE Departments(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
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
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Salary MONEY NOT NULL CHECK (Salary > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE Lectures(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	LectureRoom NVARCHAR(MAX) NOT NULL CHECK (LEN(LectureRoom) > 0),
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
GO

--INSERTS (ardicilliq vacibdir: evvel esas cedveller, sonra elaqeli cedveller)
INSERT INTO Faculties (Financing, Name) VALUES
	(30000, 'Computer Science'),
	(25000, 'Economics'),
	(20000, 'Law')

INSERT INTO Departments (Financing, Name, FacultyId) VALUES
	(35000, 'Software Development', 1),
	(12000, 'Information Systems', 1),
	(9000, 'Accounting', 2),
	(40000, 'Finance', 2),
	(8000, 'Civil Law', 3)

INSERT INTO Curators (Name, Surname) VALUES
	('Jack', 'Miller'),
	('Emma', 'Clark'),
	('Daniel', 'Wilson'),
	('Olivia', 'Brown')

INSERT INTO Groups (Name, [Year], DepartmentId) VALUES
	('P107', 5, 1),
	('P101', 1, 1),
	('S201', 2, 2),
	('E305', 3, 3),
	('F501', 5, 4),
	('L402', 4, 5)

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(1, 5),
	(2, 6)

INSERT INTO Teachers (Name, Salary, Surname) VALUES
	('Samantha', 2500, 'Adams'),
	('John', 1800, 'Smith'),
	('Dave', 2200, 'McQueen'),
	('Linda', 1500, 'Taylor'),
	('Mark', 1900, 'Evans')

INSERT INTO Subjects (Name) VALUES
	('Database Theory'),
	('Programming'),
	('Algorithms'),
	('Accounting Basics'),
	('Civil Law')

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES
	('B103', 1, 1),
	('A101', 2, 2),
	('B103', 3, 3),
	('C202', 4, 4),
	('D404', 5, 5),
	('A101', 1, 1)

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
	(1, 1),
	(1, 2),
	(2, 3),
	(3, 1),
	(4, 4),
	(5, 5),
	(6, 6)
GO

--1. Muellim ve qrup cutlerinin hamisi
SELECT T.Name AS Teacher_Name, T.Surname AS Teacher_Surname, G.Name AS Group_Name
FROM Teachers T
CROSS JOIN Groups G

--2. Kafedra maliyyesi fakulte maliyyesini kecen fakulteler
SELECT DISTINCT F.Name
FROM Faculties F
JOIN Departments D ON D.FacultyId = F.Id
WHERE D.Financing > F.Financing

--3. Kuratorlar ve baxdiqlari qruplar
SELECT C.Name + ' ' + C.Surname AS Curator_Name, G.Name AS Group_Name
FROM GroupsCurators GC
JOIN Curators C ON GC.CuratorId = C.Id
JOIN Groups G ON GC.GroupId = G.Id

--4. P107 qrupunda ders deyen muellimler
SELECT DISTINCT T.Name + ' ' + T.Surname AS Teacher_Name
FROM Lectures L
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
JOIN Teachers T ON L.TeacherId = T.Id
WHERE G.Name = 'P107'

--5. Muellimler ve ders dediyi fakulteler
SELECT DISTINCT T.Name + ' ' + T.Surname AS Teacher_Name, F.Name AS Faculty_Name
FROM Lectures L
JOIN Teachers T ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id

--6. Kafedralar ve onlara aid qruplar
SELECT D.Name AS Department_Name, G.Name AS Group_Name
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id

--7. Samantha Adams-in dersleri
SELECT DISTINCT S.Name AS Subject_Name
FROM Lectures L
JOIN Subjects S ON L.SubjectId = S.Id
JOIN Teachers T ON L.TeacherId = T.Id
WHERE T.Name = 'Samantha' AND T.Surname = 'Adams'

--8. Database Theory dersi kecilen kafedralar
SELECT DISTINCT D.Name AS Department_Name
FROM Lectures L
JOIN Subjects S ON L.SubjectId = S.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
JOIN Departments D ON G.DepartmentId = D.Id
WHERE S.Name = 'Database Theory'

--9. Computer Science fakultesinin qruplari
SELECT G.Name AS Group_Name
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'Computer Science'

--10. 5-ci kurs qruplari ve fakulteleri
SELECT G.Name AS Group_Name, F.Name AS Faculty_Name
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE G.[Year] = 5

--11. B103 auditoriyasinda kecilen dersler
SELECT T.Name + ' ' + T.Surname AS Teacher_Name, S.Name AS Subject_Name, G.Name AS Group_Name
FROM Lectures L
JOIN Teachers T ON L.TeacherId = T.Id
JOIN Subjects S ON L.SubjectId = S.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
WHERE L.LectureRoom = 'B103'
