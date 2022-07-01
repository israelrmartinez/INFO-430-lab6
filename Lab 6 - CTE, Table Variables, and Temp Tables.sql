-- Lab 6: Common Table Expressions, Table Variables and Temp Tables

USE UNIVERSITY
GO

/*
1) RANK() + PARTITION
* Write the SQL to determine the 300 students with the lowest GPA (all students/classes)
during years 1975 -1981 partitioned by StudentPermState.
*/
-- CTE
WITH CTE_LOW_GPA (StudentID, StudentFName, StudentLName, StudentPermState, GPA, GPARank)
AS (
SELECT S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
RANK() OVER (PARTITION BY StudentPermState ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits))
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
WHERE C.[YEAR] BETWEEN 1975 AND 1981
GROUP BY S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState
)
SELECT TOP 300 * FROM CTE_LOW_GPA
go

-- Table Variable
DECLARE @LOW_GPA TABLE --> same method as declaring ANY variable INT, varchar(50)
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	PermState varchar(20) not null,
	GPA float not null,
	GPARank INT not null)

INSERT INTO @LOW_GPA (StudentID, FirstName, LastName, PermState, GPA, GPARank)
SELECT S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
DENSE_RANK() OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits))
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1970 AND 1979)
	AND CG.CollegeName = 'Business (Foster)'
GROUP BY S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState
SELECT TOP 300 * FROM @LOW_GPA


-- #temp tables
CREATE TABLE #LOW_GPA--> same method as declaring ANY variable INT, varchar(50)
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	PermState varchar(20) not null,
	GPA float not null,
	GPARank INT not null)

INSERT INTO #LOW_GPA (StudentID, FirstName, LastName, PermState, GPA, GPARank)
SELECT S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
DENSE_RANK() OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits))
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1970 AND 1979)
	AND CG.CollegeName = 'Business (Foster)'
GROUP BY S.StudentID, S.StudentFName, S.StudentLName, S.StudentPermState
SELECT TOP 300 * FROM #LOW_GPA
GO



/*
2) DENSE_RANK()
* Write the SQL to determine the 26th highest GPA during the 1970's for all business classes
*/
-- CTE
WITH CTE_1970s_GPA (StudentID, StudentFName, StudentLName, GPA, GPARank)
AS (
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
DENSE_RANK() OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1970 AND 1979)
	AND (CG.CollegeName = 'Business (Foster)')
GROUP BY S.StudentID, S.StudentFName, S.StudentLName
)
SELECT * FROM CTE_1970s_GPA
WHERE GPARank IN (26)
GO


-- Table Variable
DECLARE @1970s_GPA TABLE --> same method as declaring ANY variable INT, varchar(50)
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	GPA float not null,
	GPARank INT not null)

INSERT INTO @1970s_GPA (StudentID, FirstName, LastName, GPA, GPARank)
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
DENSE_RANK() OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1970 AND 1979)
	AND CG.CollegeName = 'Business (Foster)'
GROUP BY S.StudentID, S.StudentFName, S.StudentLName
SELECT * FROM @1970s_GPA
WHERE GPARank IN (26)
GO


-- #temp tables
CREATE TABLE #1970s_GPA --> same method as declaring ANY variable INT, varchar(50)
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	GPA float not null,
	GPARank INT not null)

INSERT INTO #1970s_GPA (StudentID, FirstName, LastName, GPA, GPARank)
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
DENSE_RANK() OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1970 AND 1979)
	AND CG.CollegeName = 'Business (Foster)'
GROUP BY S.StudentID, S.StudentFName, S.StudentLName
SELECT * FROM #1970s_GPA
WHERE GPARank IN (26)
GO



/*
3) NTILE
* Write the SQL to divide ALL students into 100 groups based on GPA for Arts & Sciences classes during 1980's
*/

-- CTE
WITH CTE_1980s_GPA_Grouped (StudentID, StudentFName, StudentLName, GPA, GPAGroup)
AS (
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
NTILE(100) OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1980 AND 1989)
	AND (CG.CollegeName = 'Arts and Sciences')
GROUP BY S.StudentID, S.StudentFName, S.StudentLName
)
SELECT * FROM CTE_1980s_GPA_Grouped


-- Table Variable
DECLARE @1980s_GPA_Grouped TABLE --> same method as declaring ANY variable INT, varchar(50)
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	GPA float not null,
	GPAGroup INT not null)

INSERT INTO @1980s_GPA_Grouped (StudentID, FirstName, LastName, GPA, GPAGroup)
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
NTILE(100) OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1980 AND 1989)
	AND (CG.CollegeName = 'Arts and Sciences')
GROUP BY S.StudentID, S.StudentFName, S.StudentLName

SELECT * FROM @1980s_GPA_Grouped
GO


-- #temp tables
CREATE TABLE #1980s_GPA_Grouped
	(PKID INT IDENTITY(1,1) primary key,
	StudentID INT not null,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	GPA float not null,
	GPAGroup INT not null)

INSERT INTO #1980s_GPA_Grouped (StudentID, FirstName, LastName, GPA, GPAGroup)
SELECT S.StudentID, S.StudentFName, S.StudentLName, SUM(CS.Credits * CL.Grade) / SUM(CS.Credits),
NTILE(100) OVER (ORDER BY SUM(CS.Credits * CL.Grade) / SUM(CS.Credits) DESC)
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
	JOIN tblCLASS C ON CL.ClassID = C.ClassID
	JOIN tblCOURSE CS ON C.CourseID = CS.CourseID
	JOIN tblDEPARTMENT D ON CS.DeptID = D.DeptID
	JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
WHERE (C.[YEAR] BETWEEN 1980 AND 1989)
	AND (CG.CollegeName = 'Arts and Sciences')
GROUP BY S.StudentID, S.StudentFName, S.StudentLName

SELECT * FROM #1980s_GPA_Grouped
GO
