-- Создание базы данных
CREATE DATABASE EmploymentCenterDB;
USE EmploymentCenterDB;

-- Создание таблиц
CREATE TABLE JobSeekers (
    JobSeekerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE Employers (
    EmployerID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Vacancies (
    VacancyID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT FOREIGN KEY REFERENCES Employers(EmployerID),
    JobTitle NVARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2),
    RequiredExperienceYears INT,
    Status NVARCHAR(20) CHECK (Status IN ('Открыта', 'Закрыта', 'Приостановлена'))
);

CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    DurationHours INT,
    StartDate DATE,
    Cost DECIMAL(8,2)
);

CREATE TABLE CourseEnrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    JobSeekerID INT FOREIGN KEY REFERENCES JobSeekers(JobSeekerID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    EnrollmentDate DATE,
    CompletionStatus NVARCHAR(20) CHECK (CompletionStatus IN ('Записан', 'Завершено', 'Отменено'))
);

-- Вставка данных
INSERT INTO JobSeekers (FirstName, LastName, Email, Phone, RegistrationDate) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '2025-01-15'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '2025-02-20'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '2025-03-10'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '2025-04-25'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '2025-05-18'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '2025-06-28'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '2025-07-05'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '2025-08-10');

INSERT INTO Employers (CompanyName, ContactPerson, Email, Phone) VALUES
('ООО ТехноПрогресс', 'Анна Смирнова', 'anna.smirnova@technoprogress.ru', '+79123456701'),
('ЗАО СтройИнвест', 'Иван Петров', 'ivan.petrov@stroyinvest.ru', '+79123456702'),
('ИП Консалт', 'Екатерина Иванова', 'ekaterina.ivanova@ipconsult.ru', '+79123456703'),
('ООО ГлобалТрейд', 'Михаил Козлов', 'mikhail.kozlov@globaltrade.ru', '+79123456704');

INSERT INTO Vacancies (EmployerID, JobTitle, Salary, RequiredExperienceYears, Status) VALUES
(1, 'Программист', 80000.00, 2, 'Открыта'),
(2, 'Инженер-строитель', 75000.00, 3, 'Открыта'),
(3, 'Бухгалтер', 60000.00, 1, 'Закрыта'),
(4, 'Менеджер по продажам', 70000.00, 2, 'Открыта');

INSERT INTO Courses (CourseName, DurationHours, StartDate, Cost) VALUES
('Основы программирования', 120, '2025-10-01', 15000.00),
('Строительные технологии', 80, '2025-10-15', 10000.00),
('Бухгалтерский учёт', 100, '2025-11-01', 12000.00),
('Техники продаж', 60, '2025-11-15', 8000.00);

INSERT INTO CourseEnrollments (JobSeekerID, CourseID, EnrollmentDate, CompletionStatus) VALUES
(1, 1, '2025-09-01', 'Записан'),
(2, 2, '2025-09-02', 'Записан'),
(3, 3, '2025-09-03', 'Завершено'),
(4, 4, '2025-09-04', 'Записан'),
(5, 1, '2025-09-05', 'Записан'),
(6, 2, '2025-09-06', 'Завершено'),
(7, 3, '2025-09-07', 'Записан'),
(8, 4, '2025-09-08', 'Завершено');

-- Запросы
SELECT 
    j.FirstName,
    j.LastName,
    c.CourseName,
    (SELECT COUNT(*) 
     FROM CourseEnrollments ce2 
     WHERE ce2.JobSeekerID = j.JobSeekerID) AS TotalEnrollments
FROM JobSeekers j
JOIN CourseEnrollments ce ON j.JobSeekerID = ce.JobSeekerID
JOIN Courses c ON ce.CourseID = c.CourseID
WHERE (SELECT COUNT(*) 
       FROM CourseEnrollments ce2 
       WHERE ce2.JobSeekerID = j.JobSeekerID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM CourseEnrollments ce3 
       GROUP BY ce3.JobSeekerID)
ORDER BY TotalEnrollments DESC;

SELECT DISTINCT
    e.CompanyName,
    e.ContactPerson
FROM Employers e
WHERE e.EmployerID IN (
    SELECT v.EmployerID
    FROM Vacancies v
    WHERE v.Status = 'Открыта'
);

SELECT 
    j.FirstName,
    j.LastName,
    v.JobTitle,
    v.Salary
FROM JobSeekers j
JOIN CourseEnrollments ce ON j.JobSeekerID = ce.JobSeekerID
JOIN Courses c ON ce.CourseID = c.CourseID
CROSS JOIN Vacancies v
WHERE v.Salary > (
    SELECT AVG(v2.Salary)
    FROM Vacancies v2
    WHERE v2.Status = 'Открыта'
);

SELECT DISTINCT
    j.FirstName,
    j.LastName,
    j.Email
FROM JobSeekers j
WHERE EXISTS (
    SELECT 1
    FROM CourseEnrollments ce
    JOIN Courses c ON ce.CourseID = c.CourseID
    WHERE ce.JobSeekerID = j.JobSeekerID 
    AND c.CourseName = 'Основы программирования'
);

-- Курсоры
DECLARE @JobSeekerID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @EnrollmentCount INT;

DECLARE jobseeker_cursor CURSOR FOR
SELECT 
    j.JobSeekerID,
    j.FirstName, 
    j.LastName,
    COUNT(ce.EnrollmentID) AS EnrollmentCount
FROM JobSeekers j
LEFT JOIN CourseEnrollments ce ON j.JobSeekerID = ce.JobSeekerID
GROUP BY j.JobSeekerID, j.FirstName, j.LastName
ORDER BY j.LastName;

OPEN jobseeker_cursor;

FETCH NEXT FROM jobseeker_cursor INTO @JobSeekerID, @FirstName, @LastName, @EnrollmentCount;

PRINT 'ОТЧЁТ ПО ЗАПИСЯМ НА КУРСЫ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @EnrollmentCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@JobSeekerID AS VARCHAR) + ') - Нет записей на курсы';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@JobSeekerID AS VARCHAR) + 
              ') - Количество записей: ' + CAST(@EnrollmentCount AS VARCHAR);

    FETCH NEXT FROM jobseeker_cursor INTO @JobSeekerID, @FirstName, @LastName, @EnrollmentCount;
END;

CLOSE jobseeker_cursor;
DEALLOCATE jobseeker_cursor;

DECLARE @CourseID INT, @CourseName NVARCHAR(100);
DECLARE @JsFirstName NVARCHAR(50), @JsLastName NVARCHAR(50), @JsEmail NVARCHAR(100);

DECLARE course_cursor CURSOR FOR
SELECT CourseID, CourseName
FROM Courses
ORDER BY CourseName;

OPEN course_cursor;
FETCH NEXT FROM course_cursor INTO @CourseID, @CourseName;

PRINT 'БЕЗРАБОТНЫЕ ПО КУРСАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'КУРС: ' + @CourseName;
    PRINT '----------------------------------------';

    DECLARE jobseeker_course_cursor CURSOR LOCAL FOR
    SELECT j.FirstName, j.LastName, j.Email
    FROM JobSeekers j
    JOIN CourseEnrollments ce ON j.JobSeekerID = ce.JobSeekerID
    WHERE ce.CourseID = @CourseID AND ce.CompletionStatus = 'Завершено'
    ORDER BY j.LastName;

    OPEN jobseeker_course_cursor;
    FETCH NEXT FROM jobseeker_course_cursor INTO @JsFirstName, @JsLastName, @JsEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет участников';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @JsLastName + ' ' + @JsFirstName + ' - ' + ISNULL(@JsEmail, 'Нет email');
        FETCH NEXT FROM jobseeker_course_cursor INTO @JsFirstName, @JsLastName, @JsEmail;
    END;

    CLOSE jobseeker_course_cursor;
    DEALLOCATE jobseeker_course_cursor;

    FETCH NEXT FROM course_cursor INTO @CourseID, @CourseName;
END;

CLOSE course_cursor;
DEALLOCATE course_cursor;

DECLARE @EnrollmentID INT, @EnrollmentDate DATE;

DECLARE enrollment_cursor CURSOR FOR
SELECT EnrollmentID, EnrollmentDate
FROM CourseEnrollments
WHERE CompletionStatus = 'Записан' AND EnrollmentDate <= DATEADD(DAY, -30, GETDATE());

OPEN enrollment_cursor;
FETCH NEXT FROM enrollment_cursor INTO @EnrollmentID, @EnrollmentDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ЗАПИСЕЙ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE CourseEnrollments
    SET CompletionStatus = 'Отменено'
    WHERE EnrollmentID = @EnrollmentID;

    PRINT 'Запись ID ' + CAST(@EnrollmentID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM enrollment_cursor INTO @EnrollmentID, @EnrollmentDate;
END;

CLOSE enrollment_cursor;
DEALLOCATE enrollment_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_JobSeekers_Phone ON JobSeekers(Phone);
CREATE INDEX IX_Vacancies_EmployerID ON Vacancies(EmployerID);
CREATE INDEX IX_CourseEnrollments_JobSeekerID ON CourseEnrollments(JobSeekerID);
CREATE INDEX IX_CourseEnrollments_CourseID ON CourseEnrollments(CourseID);
CREATE INDEX IX_CourseEnrollments_EnrollmentDate ON CourseEnrollments(EnrollmentDate);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE enrollment_cursor_perf CURSOR FOR SELECT EnrollmentID FROM CourseEnrollments WHERE CompletionStatus = 'Завершено';
OPEN enrollment_cursor_perf;
FETCH NEXT FROM enrollment_cursor_perf INTO @EnrollmentID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM enrollment_cursor_perf INTO @EnrollmentID;
END;
CLOSE enrollment_cursor_perf;
DEALLOCATE enrollment_cursor_perf;

PRINT 'Курсор - количество завершённых записей: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM CourseEnrollments WHERE CompletionStatus = 'Завершено';
PRINT 'Множественный запрос - количество завершённых записей: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;