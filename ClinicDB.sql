-- Создание базы данных
CREATE DATABASE ClinicDB;
USE ClinicDB;

-- Создание таблиц
CREATE TABLE Specialties (
    SpecialtyID INT IDENTITY(1,1) PRIMARY KEY,
    SpecialtyName NVARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    SpecialtyID INT FOREIGN KEY REFERENCES Specialties(SpecialtyID)
);

CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    BirthDate DATE
);

CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    AppointmentDateTime DATETIME,
    Status NVARCHAR(20) CHECK (Status IN ('Запланировано', 'Завершено', 'Отменено'))
);

CREATE TABLE Referrals (
    ReferralID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    ReferralDate DATE,
    SpecialtyID INT FOREIGN KEY REFERENCES Specialties(SpecialtyID)
);

CREATE TABLE Tests (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    TestDate DATE,
    TestType NVARCHAR(100),
    Result NVARCHAR(200)
);

-- Вставка данных
INSERT INTO Specialties (SpecialtyName) VALUES
('Терапия'),
('Кардиология'),
('Неврология'),
('Ортопедия');

INSERT INTO Doctors (FirstName, LastName, Email, Phone, SpecialtyID) VALUES
('Анна', 'Смирнова', 'anna.smirnova@email.com', '+79123456701', 1),
('Иван', 'Петров', 'ivan.petrov@email.com', '+79123456702', 2),
('Екатерина', 'Иванова', 'ekaterina.ivanova@email.com', '+79123456703', 3),
('Михаил', 'Козлов', 'mikhail.kozlov@email.com', '+79123456704', 4);

INSERT INTO Patients (FirstName, LastName, Email, Phone, BirthDate) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '1985-05-15'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '1978-03-20'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '1990-07-10'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '1982-11-25'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '1995-02-18'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '1980-06-28'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '1988-09-05'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '1975-12-10');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDateTime, Status) VALUES
(1, 1, '2025-10-01 10:00:00', 'Завершено'),
(2, 2, '2025-10-02 12:00:00', 'Запланировано'),
(3, 3, '2025-10-03 14:00:00', 'Завершено'),
(4, 4, '2025-10-04 16:00:00', 'Запланировано');

INSERT INTO Referrals (PatientID, DoctorID, ReferralDate, SpecialtyID) VALUES
(1, 2, '2025-09-01', 2),
(2, 3, '2025-09-02', 3),
(3, 4, '2025-09-03', 4),
(4, 1, '2025-09-04', 1);

INSERT INTO Tests (PatientID, DoctorID, TestDate, TestType, Result) VALUES
(1, 1, '2025-09-05', 'Общий анализ крови', 'Норма'),
(2, 2, '2025-09-06', 'ЭКГ', 'Норма'),
(3, 3, '2025-09-07', 'МРТ', 'Незначительные изменения'),
(4, 4, '2025-09-08', 'Рентген', 'Норма');

-- Запросы
SELECT 
    p.FirstName,
    p.LastName,
    s.SpecialtyName,
    (SELECT COUNT(*) 
     FROM Appointments a2 
     WHERE a2.PatientID = p.PatientID) AS TotalAppointments
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Specialties s ON d.SpecialtyID = s.SpecialtyID
WHERE (SELECT COUNT(*) 
       FROM Appointments a2 
       WHERE a2.PatientID = p.PatientID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Appointments a3 
       GROUP BY a3.PatientID)
ORDER BY TotalAppointments DESC;

SELECT DISTINCT
    d.FirstName,
    d.LastName
FROM Doctors d
WHERE d.DoctorID IN (
    SELECT a.DoctorID
    FROM Appointments a
    WHERE a.Status = 'Завершено'
);

SELECT 
    p.FirstName,
    p.LastName,
    s.SpecialtyName,
    a.AppointmentDateTime
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Specialties s ON d.SpecialtyID = s.SpecialtyID
WHERE a.AppointmentDateTime > (
    SELECT AVG(a2.AppointmentDateTime)
    FROM Appointments a2
    JOIN Doctors d2 ON a2.DoctorID = d2.DoctorID
    WHERE d2.SpecialtyID = s.SpecialtyID
);

SELECT DISTINCT
    p.FirstName,
    p.LastName,
    p.Email
FROM Patients p
WHERE EXISTS (
    SELECT 1
    FROM Referrals r
    JOIN Specialties s ON r.SpecialtyID = s.SpecialtyID
    WHERE r.PatientID = p.PatientID 
    AND s.SpecialtyName = 'Кардиология'
);

-- Курсоры
DECLARE @PatientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @AppointmentCount INT;

DECLARE patient_cursor CURSOR FOR
SELECT 
    p.PatientID,
    p.FirstName, 
    p.LastName,
    COUNT(a.AppointmentID) AS AppointmentCount
FROM Patients p
LEFT JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName
ORDER BY p.LastName;

OPEN patient_cursor;

FETCH NEXT FROM patient_cursor INTO @PatientID, @FirstName, @LastName, @AppointmentCount;

PRINT 'ОТЧЁТ ПО ПРИЁМАМ ПАЦИЕНТОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @AppointmentCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@PatientID AS VARCHAR) + ') - Нет приёмов';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@PatientID AS VARCHAR) + 
              ') - Количество приёмов: ' + CAST(@AppointmentCount AS VARCHAR);

    FETCH NEXT FROM patient_cursor INTO @PatientID, @FirstName, @LastName, @AppointmentCount;
END;

CLOSE patient_cursor;
DEALLOCATE patient_cursor;

DECLARE @SpecialtyID INT, @SpecialtyName NVARCHAR(100);
DECLARE @PtFirstName NVARCHAR(50), @PtLastName NVARCHAR(50), @PtEmail NVARCHAR(100);

DECLARE specialty_cursor CURSOR FOR
SELECT SpecialtyID, SpecialtyName
FROM Specialties
ORDER BY SpecialtyName;

OPEN specialty_cursor;
FETCH NEXT FROM specialty_cursor INTO @SpecialtyID, @SpecialtyName;

PRINT 'ПАЦИЕНТЫ ПО СПЕЦИАЛЬНОСТЯМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'СПЕЦИАЛЬНОСТЬ: ' + @SpecialtyName;
    PRINT '----------------------------------------';

    DECLARE patient_specialty_cursor CURSOR LOCAL FOR
    SELECT p.FirstName, p.LastName, p.Email
    FROM Patients p
    JOIN Appointments a ON p.PatientID = a.PatientID
    JOIN Doctors d ON a.DoctorID = d.DoctorID
    WHERE d.SpecialtyID = @SpecialtyID
    ORDER BY p.LastName;

    OPEN patient_specialty_cursor;
    FETCH NEXT FROM patient_specialty_cursor INTO @PtFirstName, @PtLastName, @PtEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет пациентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @PtLastName + ' ' + @PtFirstName + ' - ' + ISNULL(@PtEmail, 'Нет email');
        FETCH NEXT FROM patient_specialty_cursor INTO @PtFirstName, @PtLastName, @PtEmail;
    END;

    CLOSE patient_specialty_cursor;
    DEALLOCATE patient_specialty_cursor;

    FETCH NEXT FROM specialty_cursor INTO @SpecialtyID, @SpecialtyName;
END;

CLOSE specialty_cursor;
DEALLOCATE specialty_cursor;

DECLARE @AppointmentID INT, @AppointmentDateTime DATETIME;

DECLARE appointment_cursor CURSOR FOR
SELECT AppointmentID, AppointmentDateTime
FROM Appointments
WHERE Status = 'Запланировано' AND AppointmentDateTime <= DATEADD(DAY, -7, GETDATE());

OPEN appointment_cursor;
FETCH NEXT FROM appointment_cursor INTO @AppointmentID, @AppointmentDateTime;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ПРИЁМОВ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Appointments
    SET Status = 'Отменено'
    WHERE AppointmentID = @AppointmentID;

    PRINT 'Приём ID ' + CAST(@AppointmentID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM appointment_cursor INTO @AppointmentID, @AppointmentDateTime;
END;

CLOSE appointment_cursor;
DEALLOCATE appointment_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Patients_Phone ON Patients(Phone);
CREATE INDEX IX_Appointments_PatientID ON Appointments(PatientID);
CREATE INDEX IX_Appointments_DoctorID ON Appointments(DoctorID);
CREATE INDEX IX_Referrals_PatientID ON Referrals(PatientID);
CREATE INDEX IX_Tests_TestDate ON Tests(TestDate);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE appointment_cursor_perf CURSOR FOR SELECT AppointmentID FROM Appointments WHERE Status = 'Завершено';
OPEN appointment_cursor_perf;
FETCH NEXT FROM appointment_cursor_perf INTO @AppointmentID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM appointment_cursor_perf INTO @AppointmentID;
END;
CLOSE appointment_cursor_perf;
DEALLOCATE appointment_cursor_perf;

PRINT 'Курсор - количество завершённых приёмов: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Appointments WHERE Status = 'Завершено';
PRINT 'Множественный запрос - количество завершённых приёмов: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;