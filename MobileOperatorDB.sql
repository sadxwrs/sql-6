-- 1
CREATE DATABASE MobileOperatorDB;
USE MobileOperatorDB;

-- 2
CREATE TABLE Tariffs (
    TariffID INT IDENTITY(1,1) PRIMARY KEY,
    TariffName NVARCHAR(100) NOT NULL,
    MonthlyFee DECIMAL(8,2),
    DataLimitGB INT,
    MinutesIncluded INT,
    SMSIncluded INT
);

CREATE TABLE Subscribers (
    SubscriberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    PhoneNumber NVARCHAR(20) NOT NULL,
    RegistrationDate DATE,
    TariffID INT FOREIGN KEY REFERENCES Tariffs(TariffID)
);

CREATE TABLE Calls (
    CallID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT FOREIGN KEY REFERENCES Subscribers(SubscriberID),
    CallDateTime DATETIME,
    DurationSeconds INT,
    DestinationNumber NVARCHAR(20)
);

CREATE TABLE SMS (
    SMSID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT FOREIGN KEY REFERENCES Subscribers(SubscriberID),
    SMSDateTime DATETIME,
    DestinationNumber NVARCHAR(20),
    MessageLength INT
);

CREATE TABLE InternetUsage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT FOREIGN KEY REFERENCES Subscribers(SubscriberID),
    UsageDateTime DATETIME,
    DataUsedMB DECIMAL(10,2)
);

-- 2
INSERT INTO Tariffs (TariffName, MonthlyFee, DataLimitGB, MinutesIncluded, SMSIncluded) VALUES
('Базовый', 10.00, 5, 200, 100),
('Стандартный', 20.00, 10, 500, 300),
('Премиум', 30.00, 20, 1000, 500),
('Безлимитный', 50.00, 50, 2000, 1000);

INSERT INTO Subscribers (FirstName, LastName, Email, PhoneNumber, RegistrationDate, TariffID) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '2023-01-15', 1),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '2023-02-20', 2),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '2023-03-10', 3),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '2023-04-25', 4),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '2023-05-18', 1),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '2023-06-28', 2),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '2023-07-05', 3),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '2023-08-10', 4),
('Лидия', 'Мартынова', 'lidiya.martynova@email.com', '+6598765434', '2023-09-17', 1),
('Алексей', 'Попов', 'alexey.popov@email.com', '+79123456784', '2023-10-20', 2),
('Светлана', 'Волкова', 'svetlana.volkova@email.com', '+12025550126', '2023-11-11', 3),
('Анастасия', 'Козлова', 'anastasia.kozlova@email.com', '+447911123459', '2023-12-25', 4),
('Роберт', 'Алленов', 'robert.allenov@email.com', '+6598765435', '2024-01-30', 1),
('Наталья', 'Смирнова', 'natalia.smirnova@email.com', '+79123456783', '2024-02-15', 2),
('Виктор', 'Молодцов', 'viktor.molodtsov@email.com', '+12025550127', '2024-03-22', 3),
('Виктория', 'Королёва', 'viktoria.koroleva@email.com', '+447911123460', '2024-04-08', 4),
('Дмитрий', 'Волков', 'dmitry.volkov@email.com', '+79123456782', '2024-05-14', 1),
('Лариса', 'Скворцова', 'larisa.skvortsova@email.com', '+12025550128', '2024-06-01', 2),
('Павел', 'Зелёный', 'pavel.zeleny@email.com', '+447911123461', '2024-07-27', 3),
('Екатерина', 'Фёдорова', 'ekaterina.fedorova@email.com', '+79123456781', '2024-08-19', 4),
('Георгий', 'Бакланов', 'georgiy.baklanov@email.com', '+6598765436', '2024-09-05', 1),
('Анастасия', 'Смирнова', 'anastasia.smirnova2@email.com', '+79123456780', '2024-10-12', 2),
('Чарльз', 'Харрисов', 'charles.harrisov@email.com', '+12025550129', '2024-11-20', 3),
('Марина', 'Гусева', 'marina.guseva@email.com', '+79123456779', '2024-12-15', 4),
('Геннадий', 'Левин', 'gennadiy.levin@email.com', '+447911123462', '2025-01-10', 1),
('Светлана', 'Васильева', 'svetlana.vasilieva@email.com', '+79123456778', '2025-02-25', 2),
('Эдуард', 'Волков', 'eduard.volkov@email.com', '+12025550130', '2025-03-30', 3),
('Ирина', 'Михайлова', 'irina.mikhailova@email.com', '+79123456777', '2025-04-22', 4),
('Степан', 'Белый', 'stepan.bely@email.com', '+447911123463', '2025-05-17', 1),
('Ольга', 'Коваленко', 'olga.kovalenko@email.com', '+79123456776', '2025-06-05', 2),
('Ричард', 'Кларков', 'richard.clarkov@email.com', '+12025550131', '2025-07-20', 3),
('Татьяна', 'Лебедева', 'tatiana.lebedeva@email.com', '+79123456775', '2025-08-15', 4),
('Даниил', 'Холмов', 'daniil.holmov@email.com', '+447911123464', '2025-09-25', 1),
('Елена', 'Романова', 'elena.romanova@email.com', '+79123456774', '2025-10-10', 2),
('Марк', 'Турнов', 'mark.turnov@email.com', '+12025550132', '2025-11-01', 3),
('Юлия', 'Соколова', 'yulia.sokolova@email.com', '+79123456773', '2025-12-15', 4),
('Андрей', 'Морозов', 'andrey.morozov@email.com', '+447911123465', '2025-01-20', 1),
('Марина', 'Беляева', 'marina.belyaeva@email.com', '+79123456772', '2025-02-10', 2),
('Пётр', 'Райт', 'petr.rayt@email.com', '+12025550133', '2025-03-05', 3),
('Анна', 'Зайцева', 'anna.zaytseva@email.com', '+79123456771', '2025-04-28', 4),
('Фома', 'Хьюзов', 'foma.huzov@email.com', '+447911123466', '2025-05-15', 1),
('София', 'Козлова', 'sofia.kozlova2@email.com', '+79123456770', '2025-06-20', 2),
('Яков', 'Парков', 'yakov.parkov@email.com', '+12025550134', '2025-07-10', 3),
('Вера', 'Орлова', 'vera.orlova@email.com', '+79123456769', '2025-08-25', 4),
('Михаил', 'Кук', 'mikhail.kuk@email.com', '+447911123467', '2025-09-30', 1),
('Наталья', 'Гусева', 'natalia.guseva@email.com', '+79123456768', '2025-10-15', 2),
('Давид', 'Коричневый', 'david.korichnevy@email.com', '+12025550135', '2025-11-20', 3),
('Елена', 'Попова', 'elena.popova@email.com', '+79123456767', '2025-12-15', 4),
('Иван', 'Тайлоров', 'ivan.taylorov@email.com', '+447911123468', '2025-01-10', 1),
('Мария', 'Иванова', 'maria.ivanova@email.com', '+79123456766', '2025-02-25', 2);

INSERT INTO Calls (SubscriberID, CallDateTime, DurationSeconds, DestinationNumber) VALUES
(1, '2025-10-01 10:00:00', 300, '+79123456788'),
(2, '2025-10-01 12:00:00', 600, '+6598765433'),
(3, '2025-10-02 14:00:00', 450, '+447911123458'),
(4, '2025-10-02 16:00:00', 1200, '+12025550125'),
(5, '2025-10-03 11:00:00', 200, '+79123456789'),
(6, '2025-10-03 13:00:00', 800, '+6598765434'),
(7, '2025-10-04 09:00:00', 500, '+447911123459'),
(8, '2025-10-04 11:00:00', 700, '+12025550126'),
(9, '2025-10-05 10:00:00', 400, '+79123456790'),
(10, '2025-10-05 12:00:00', 900, '+6598765435'),
(11, '2025-10-06 14:00:00', 600, '+447911123460'),
(12, '2025-10-06 16:00:00', 1100, '+12025550127'),
(13, '2025-10-07 11:00:00', 300, '+79123456791'),
(14, '2025-10-07 13:00:00', 700, '+6598765436'),
(15, '2025-10-08 09:00:00', 500, '+447911123461'),
(16, '2025-10-08 11:00:00', 800, '+12025550128'),
(17, '2025-10-09 10:00:00', 400, '+79123456792'),
(18, '2025-10-09 12:00:00', 900, '+6598765437'),
(19, '2025-10-10 14:00:00', 600, '+447911123462'),
(20, '2025-10-10 16:00:00', 1000, '+12025550129'),
(21, '2025-10-11 11:00:00', 300, '+79123456793'),
(22, '2025-10-11 13:00:00', 700, '+6598765438'),
(23, '2025-10-12 09:00:00', 500, '+447911123463'),
(24, '2025-10-12 11:00:00', 800, '+12025550130'),
(25, '2025-10-13 10:00:00', 400, '+79123456794'),
(26, '2025-10-13 12:00:00', 900, '+6598765439'),
(27, '2025-10-14 14:00:00', 600, '+447911123464'),
(28, '2025-10-14 16:00:00', 1000, '+12025550131'),
(29, '2025-10-15 11:00:00', 300, '+79123456795'),
(30, '2025-10-15 13:00:00', 700, '+6598765440'),
(31, '2025-10-16 09:00:00', 500, '+447911123465'),
(32, '2025-10-16 11:00:00', 800, '+12025550132'),
(33, '2025-10-17 10:00:00', 400, '+79123456796'),
(34, '2025-10-17 12:00:00', 900, '+6598765441'),
(35, '2025-10-18 14:00:00', 600, '+447911123466'),
(36, '2025-10-18 16:00:00', 1000, '+12025550133'),
(37, '2025-10-19 11:00:00', 300, '+79123456797'),
(38, '2025-10-19 13:00:00', 700, '+6598765442'),
(39, '2025-10-20 09:00:00', 500, '+447911123467'),
(40, '2025-10-20 11:00:00', 800, '+12025550134'),
(41, '2025-10-21 10:00:00', 400, '+79123456798'),
(42, '2025-10-21 12:00:00', 900, '+6598765443'),
(43, '2025-10-22 14:00:00', 600, '+447911123468'),
(44, '2025-10-22 16:00:00', 1000, '+12025550135'),
(45, '2025-10-23 11:00:00', 300, '+79123456799'),
(46, '2025-10-23 13:00:00', 700, '+6598765444'),
(47, '2025-10-24 09:00:00', 500, '+447911123469'),
(48, '2025-10-24 11:00:00', 800, '+12025550136'),
(49, '2025-10-25 10:00:00', 400, '+79123456800'),
(50, '2025-10-25 12:00:00', 900, '+6598765445');

INSERT INTO SMS (SubscriberID, SMSDateTime, DestinationNumber, MessageLength) VALUES
(1, '2025-10-01 10:30:00', '+79123456788', 120),
(2, '2025-10-01 12:30:00', '+6598765433', 150),
(3, '2025-10-02 14:30:00', '+447911123458', 100),
(4, '2025-10-02 16:30:00', '+12025550125', 180),
(5, '2025-10-03 11:30:00', '+79123456789', 130),
(6, '2025-10-03 13:30:00', '+6598765434', 160),
(7, '2025-10-04 09:30:00', '+447911123459', 110),
(8, '2025-10-04 11:30:00', '+12025550126', 170),
(9, '2025-10-05 10:30:00', '+79123456790', 140),
(10, '2025-10-05 12:30:00', '+6598765435', 150);

INSERT INTO InternetUsage (SubscriberID, UsageDateTime, DataUsedMB) VALUES
(1, '2025-10-01 11:00:00', 500.50),
(2, '2025-10-01 13:00:00', 1200.75),
(3, '2025-10-02 15:00:00', 800.25),
(4, '2025-10-02 17:00:00', 2000.00),
(5, '2025-10-03 12:00:00', 600.30),
(6, '2025-10-03 14:00:00', 1500.50),
(7, '2025-10-04 10:00:00', 700.40),
(8, '2025-10-04 12:00:00', 1800.60),
(9, '2025-10-05 11:00:00', 900.70),
(10, '2025-10-05 13:00:00', 2200.80);

-- 3
SELECT 
    s.FirstName,
    s.LastName,
    t.TariffName,
    (SELECT SUM(i.DataUsedMB) 
     FROM InternetUsage i 
     WHERE i.SubscriberID = s.SubscriberID) AS TotalDataUsedMB
FROM Subscribers s
JOIN Tariffs t ON s.TariffID = t.TariffID
WHERE (SELECT SUM(i.DataUsedMB) 
       FROM InternetUsage i 
       WHERE i.SubscriberID = s.SubscriberID) > 
      (SELECT AVG(CAST(SUM(i2.DataUsedMB) AS FLOAT)) 
       FROM InternetUsage i2 
       GROUP BY i2.SubscriberID)
ORDER BY TotalDataUsedMB DESC;

-- 3
SELECT DISTINCT
    s.FirstName,
    s.LastName
FROM Subscribers s
WHERE s.SubscriberID IN (
    SELECT c.SubscriberID
    FROM Calls c
    WHERE c.DurationSeconds > 600
);

-- 3
SELECT 
    s.FirstName,
    s.LastName,
    t.TariffName,
    c.CallDateTime
FROM Subscribers s
JOIN Calls c ON s.SubscriberID = c.SubscriberID
JOIN Tariffs t ON s.TariffID = t.TariffID
WHERE c.DurationSeconds > (
    SELECT AVG(CAST(c2.DurationSeconds AS FLOAT))
    FROM Calls c2
    JOIN Subscribers s2 ON c2.SubscriberID = s2.SubscriberID
    WHERE s2.TariffID = t.TariffID
);

-- 4
SELECT DISTINCT
    s.FirstName,
    s.LastName,
    s.Email
FROM Subscribers s
WHERE EXISTS (
    SELECT 1
    FROM InternetUsage i
    WHERE i.SubscriberID = s.SubscriberID 
    AND i.DataUsedMB > 1000
);

-- 1
DECLARE @SubscriberID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @TotalDataUsed DECIMAL(10,2);

DECLARE subscriber_cursor CURSOR FOR
SELECT 
    s.SubscriberID,
    s.FirstName, 
    s.LastName,
    SUM(i.DataUsedMB) AS TotalDataUsed
FROM Subscribers s
LEFT JOIN InternetUsage i ON s.SubscriberID = i.SubscriberID
GROUP BY s.SubscriberID, s.FirstName, s.LastName
ORDER BY s.LastName;

OPEN subscriber_cursor;

FETCH NEXT FROM subscriber_cursor INTO @SubscriberID, @FirstName, @LastName, @TotalDataUsed;

PRINT 'ОТЧЁТ ПО ИСПОЛЬЗОВАНИЮ ДАННЫХ АБОНЕНТАМИ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @TotalDataUsed IS NULL
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@SubscriberID AS VARCHAR) + ') - Нет использования данных';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@SubscriberID AS VARCHAR) + 
              ') - Общий объём данных: ' + CAST(ROUND(@TotalDataUsed, 2) AS VARCHAR) + ' МБ';

    FETCH NEXT FROM subscriber_cursor INTO @SubscriberID, @FirstName, @LastName, @TotalDataUsed;
END;

CLOSE subscriber_cursor;
DEALLOCATE subscriber_cursor;

-- 2
DECLARE @TariffID INT, @TariffName NVARCHAR(100);
DECLARE @SbFirstName NVARCHAR(50), @SbLastName NVARCHAR(50), @SbEmail NVARCHAR(100);

DECLARE tariff_cursor CURSOR FOR
SELECT TariffID, TariffName
FROM Tariffs
ORDER BY TariffName;

OPEN tariff_cursor;
FETCH NEXT FROM tariff_cursor INTO @TariffID, @TariffName;

PRINT 'АБОНЕНТЫ ПО ТАРИФАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'ТАРИФ: ' + @TariffName;
    PRINT '----------------------------------------';

    DECLARE subscriber_tariff_cursor CURSOR LOCAL FOR
    SELECT s.FirstName, s.LastName, s.Email
    FROM Subscribers s
    JOIN Calls c ON s.SubscriberID = c.SubscriberID
    WHERE s.TariffID = @TariffID
    ORDER BY s.LastName;

    OPEN subscriber_tariff_cursor;
    FETCH NEXT FROM subscriber_tariff_cursor INTO @SbFirstName, @SbLastName, @SbEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет абонентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @SbLastName + ' ' + @SbFirstName + ' - ' + ISNULL(@SbEmail, 'Нет email');
        FETCH NEXT FROM subscriber_tariff_cursor INTO @SbFirstName, @SbLastName, @SbEmail;
    END;

    CLOSE subscriber_tariff_cursor;
    DEALLOCATE subscriber_tariff_cursor;

    FETCH NEXT FROM tariff_cursor INTO @TariffID, @TariffName;
END;

CLOSE tariff_cursor;
DEALLOCATE tariff_cursor;

-- 3
DECLARE @CallID INT, @CallDateTime DATETIME;

DECLARE call_cursor CURSOR FOR
SELECT CallID, CallDateTime
FROM Calls
WHERE CallDateTime <= DATEADD(DAY, -365, GETDATE());

OPEN call_cursor;
FETCH NEXT FROM call_cursor INTO @CallID, @CallDateTime;

PRINT 'АРХИВАЦИЯ СТАРЫХ ЗАПИСЕЙ ЗВОНКОВ';
PRINT '================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Calls
    SET DestinationNumber = 'Архивировано'
    WHERE CallID = @CallID;

    PRINT 'Звонок ID ' + CAST(@CallID AS VARCHAR) + ' - номер назначения изменён на "Архивировано"';

    FETCH NEXT FROM call_cursor INTO @CallID, @CallDateTime;
END;

CLOSE call_cursor;
DEALLOCATE call_cursor;

PRINT 'Обновление завершено.';

-- 5
CREATE INDEX IX_Subscribers_PhoneNumber ON Subscribers(PhoneNumber);
CREATE INDEX IX_Calls_SubscriberID ON Calls(SubscriberID);
CREATE INDEX IX_SMS_SubscriberID ON SMS(SubscriberID);
CREATE INDEX IX_InternetUsage_SubscriberID ON InternetUsage(SubscriberID);
CREATE INDEX IX_InternetUsage_UsageDateTime ON InternetUsage(UsageDateTime);

-- 6
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE internet_cursor_perf CURSOR FOR SELECT UsageID FROM InternetUsage WHERE DataUsedMB > 1000;
OPEN internet_cursor_perf;
FETCH NEXT FROM internet_cursor_perf INTO @UsageID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM internet_cursor_perf INTO @UsageID;
END;
CLOSE internet_cursor_perf;
DEALLOCATE internet_cursor_perf;

PRINT 'Курсор - количество записей с высоким использованием данных: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM InternetUsage WHERE DataUsedMB > 1000;
PRINT 'Множественный запрос - количество записей с высоким использованием данных: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;