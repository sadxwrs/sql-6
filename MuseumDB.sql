-- Создание базы данных
CREATE DATABASE MuseumDB;
USE MuseumDB;

-- Создание таблиц
CREATE TABLE Halls (
    HallID INT IDENTITY(1,1) PRIMARY KEY,
    HallName NVARCHAR(100) NOT NULL,
    Capacity INT
);

CREATE TABLE Exhibits (
    ExhibitID INT IDENTITY(1,1) PRIMARY KEY,
    ExhibitName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CreationYear INT,
    HallID INT FOREIGN KEY REFERENCES Halls(HallID)
);

CREATE TABLE Visitors (
    VisitorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Exhibitions (
    ExhibitionID INT IDENTITY(1,1) PRIMARY KEY,
    ExhibitionName NVARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    HallID INT FOREIGN KEY REFERENCES Halls(HallID)
);

CREATE TABLE Tours (
    TourID INT IDENTITY(1,1) PRIMARY KEY,
    ExhibitionID INT FOREIGN KEY REFERENCES Exhibitions(ExhibitionID),
    VisitorID INT FOREIGN KEY REFERENCES Visitors(VisitorID),
    TourDateTime DATETIME,
    Status NVARCHAR(20) CHECK (Status IN ('Запланировано', 'Проведено', 'Отменено'))
);

-- Вставка данных
INSERT INTO Halls (HallName, Capacity) VALUES
('Зал Древностей', 100),
('Зал Средневековья', 80),
('Зал Современности', 120),
('Зал Искусств', 60);

INSERT INTO Exhibits (ExhibitName, Description, CreationYear, HallID) VALUES
('Ваза Древней Греции', 'Керамическая ваза с орнаментами, V век до н.э.', -500, 1),
('Рыцарские доспехи', 'Полный комплект доспехов XIV века', 1350, 2),
('Картина "Утро"', 'Современная живопись, акрил', 2020, 3),
('Скульптура Венеры', 'Мраморная статуя XVIII века', 1750, 4);

INSERT INTO Visitors (FirstName, LastName, Email, Phone) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458');

INSERT INTO Exhibitions (ExhibitionName, StartDate, EndDate, HallID) VALUES
('Древний мир', '2025-09-01', '2025-12-01', 1),
('Средневековые сокровища', '2025-10-01', '2026-01-01', 2),
('Современное искусство', '2025-11-01', '2026-02-01', 3),
('Классическая скульптура', '2025-12-01', '2026-03-01', 4);

INSERT INTO Tours (ExhibitionID, VisitorID, TourDateTime, Status) VALUES
(1, 1, '2025-10-01 10:00:00', 'Проведено'),
(2, 2, '2025-10-02 12:00:00', 'Запланировано'),
(3, 3, '2025-10-03 14:00:00', 'Проведено'),
(4, 4, '2025-10-04 16:00:00', 'Запланировано'),
(1, 5, '2025-10-05 10:00:00', 'Запланировано'),
(2, 6, '2025-10-06 12:00:00', 'Проведено'),
(3, 7, '2025-10-07 14:00:00', 'Запланировано'),
(4, 8, '2025-10-08 16:00:00', 'Проведено');

-- Запросы
SELECT 
    v.FirstName,
    v.LastName,
    e.ExhibitionName,
    (SELECT COUNT(*) 
     FROM Tours t2 
     WHERE t2.VisitorID = v.VisitorID) AS TotalTours
FROM Visitors v
JOIN Tours t ON v.VisitorID = t.VisitorID
JOIN Exhibitions e ON t.ExhibitionID = e.ExhibitionID
WHERE (SELECT COUNT(*) 
       FROM Tours t2 
       WHERE t2.VisitorID = v.VisitorID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Tours t3 
       GROUP BY t3.VisitorID)
ORDER BY TotalTours DESC;

SELECT DISTINCT
    v.FirstName,
    v.LastName
FROM Visitors v
WHERE v.VisitorID IN (
    SELECT t.VisitorID
    FROM Tours t
    WHERE t.Status = 'Проведено'
);

SELECT 
    v.FirstName,
    v.LastName,
    h.HallName,
    t.TourDateTime
FROM Visitors v
JOIN Tours t ON v.VisitorID = t.VisitorID
JOIN Exhibitions e ON t.ExhibitionID = e.ExhibitionID
JOIN Halls h ON e.HallID = h.HallID
WHERE t.TourDateTime > (
    SELECT AVG(t2.TourDateTime)
    FROM Tours t2
    JOIN Exhibitions e2 ON t2.ExhibitionID = e2.ExhibitionID
    WHERE e2.HallID = h.HallID
);

SELECT DISTINCT
    v.FirstName,
    v.LastName,
    v.Email
FROM Visitors v
WHERE EXISTS (
    SELECT 1
    FROM Tours t
    JOIN Exhibitions e ON t.ExhibitionID = e.ExhibitionID
    WHERE t.VisitorID = v.VisitorID 
    AND e.ExhibitionName = 'Древний мир'
);

-- Курсоры
DECLARE @VisitorID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @TourCount INT;

DECLARE visitor_cursor CURSOR FOR
SELECT 
    v.VisitorID,
    v.FirstName, 
    v.LastName,
    COUNT(t.TourID) AS TourCount
FROM Visitors v
LEFT JOIN Tours t ON v.VisitorID = t.VisitorID
GROUP BY v.VisitorID, v.FirstName, v.LastName
ORDER BY v.LastName;

OPEN visitor_cursor;

FETCH NEXT FROM visitor_cursor INTO @VisitorID, @FirstName, @LastName, @TourCount;

PRINT 'ОТЧЁТ ПО ЭКСКУРСИЯМ ПОСЕТИТЕЛЕЙ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @TourCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@VisitorID AS VARCHAR) + ') - Нет экскурсий';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@VisitorID AS VARCHAR) + 
              ') - Количество экскурсий: ' + CAST(@TourCount AS VARCHAR);

    FETCH NEXT FROM visitor_cursor INTO @VisitorID, @FirstName, @LastName, @TourCount;
END;

CLOSE visitor_cursor;
DEALLOCATE visitor_cursor;

DECLARE @ExhibitionID INT, @ExhibitionName NVARCHAR(100);
DECLARE @VsFirstName NVARCHAR(50), @VsLastName NVARCHAR(50), @VsEmail NVARCHAR(100);

DECLARE exhibition_cursor CURSOR FOR
SELECT ExhibitionID, ExhibitionName
FROM Exhibitions
ORDER BY ExhibitionName;

OPEN exhibition_cursor;
FETCH NEXT FROM exhibition_cursor INTO @ExhibitionID, @ExhibitionName;

PRINT 'ПОСЕТИТЕЛИ ПО ВЫСТАВКАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'ВЫСТАВКА: ' + @ExhibitionName;
    PRINT '----------------------------------------';

    DECLARE visitor_exhibition_cursor CURSOR LOCAL FOR
    SELECT v.FirstName, v.LastName, v.Email
    FROM Visitors v
    JOIN Tours t ON v.VisitorID = t.VisitorID
    WHERE t.ExhibitionID = @ExhibitionID AND t.Status = 'Проведено'
    ORDER BY v.LastName;

    OPEN visitor_exhibition_cursor;
    FETCH NEXT FROM visitor_exhibition_cursor INTO @VsFirstName, @VsLastName, @VsEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет посетителей';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @VsLastName + ' ' + @VsFirstName + ' - ' + ISNULL(@VsEmail, 'Нет email');
        FETCH NEXT FROM visitor_exhibition_cursor INTO @VsFirstName, @VsLastName, @VsEmail;
    END;

    CLOSE visitor_exhibition_cursor;
    DEALLOCATE visitor_exhibition_cursor;

    FETCH NEXT FROM exhibition_cursor INTO @ExhibitionID, @ExhibitionName;
END;

CLOSE exhibition_cursor;
DEALLOCATE exhibition_cursor;

DECLARE @TourID INT, @TourDateTime DATETIME;

DECLARE tour_cursor CURSOR FOR
SELECT TourID, TourDateTime
FROM Tours
WHERE Status = 'Запланировано' AND TourDateTime <= DATEADD(DAY, -7, GETDATE());

OPEN tour_cursor;
FETCH NEXT FROM tour_cursor INTO @TourID, @TourDateTime;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ЭКСКУРСИЙ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Tours
    SET Status = 'Отменено'
    WHERE TourID = @TourID;

    PRINT 'Экскурсия ID ' + CAST(@TourID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM tour_cursor INTO @TourID, @TourDateTime;
END;

CLOSE tour_cursor;
DEALLOCATE tour_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Visitors_Phone ON Visitors(Phone);
CREATE INDEX IX_Exhibits_HallID ON Exhibits(HallID);
CREATE INDEX IX_Exhibitions_HallID ON Exhibitions(HallID);
CREATE INDEX IX_Tours_VisitorID ON Tours(VisitorID);
CREATE INDEX IX_Tours_ExhibitionID ON Tours(ExhibitionID);
CREATE INDEX IX_Tours_TourDateTime ON Tours(TourDateTime);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE tour_cursor_perf CURSOR FOR SELECT TourID FROM Tours WHERE Status = 'Проведено';
OPEN tour_cursor_perf;
FETCH NEXT FROM tour_cursor_perf INTO @TourID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM tour_cursor_perf INTO @TourID;
END;
CLOSE tour_cursor_perf;
DEALLOCATE tour_cursor_perf;

PRINT 'Курсор - количество проведённых экскурсий: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Tours WHERE Status = 'Проведено';
PRINT 'Множественный запрос - количество проведённых экскурсий: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;