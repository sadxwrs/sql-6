-- Создание базы данных
CREATE DATABASE PrintingHouseDB;
USE PrintingHouseDB;

-- Создание таблиц
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Materials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialName NVARCHAR(100) NOT NULL,
    CostPerUnit DECIMAL(8,2),
    StockQuantity INT
);

CREATE TABLE Equipment (
    EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
    EquipmentName NVARCHAR(100) NOT NULL,
    PurchaseDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('Работает', 'На обслуживании', 'Выведено из эксплуатации'))
);

CREATE TABLE PrintJobs (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    MaterialID INT FOREIGN KEY REFERENCES Materials(MaterialID),
    EquipmentID INT FOREIGN KEY REFERENCES Equipment(EquipmentID),
    JobDate DATE,
    Quantity INT,
    TotalCost DECIMAL(10,2),
    Status NVARCHAR(20) CHECK (Status IN ('В обработке', 'Завершено', 'Отменено'))
);

-- Вставка данных
INSERT INTO Clients (FirstName, LastName, Email, Phone) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458');

INSERT INTO Materials (MaterialName, CostPerUnit, StockQuantity) VALUES
('Глянцевая бумага', 0.50, 10000),
('Матовая бумага', 0.40, 8000),
('Картон', 1.00, 5000),
('Винил', 2.00, 2000);

INSERT INTO Equipment (EquipmentName, PurchaseDate, Status) VALUES
('Офсетный принтер', '2020-01-01', 'Работает'),
('Цифровой принтер', '2020-06-01', 'Работает'),
('Резальная машина', '2021-01-01', 'На обслуживании'),
('Ламинатор', '2021-06-01', 'Работает');

INSERT INTO PrintJobs (ClientID, MaterialID, EquipmentID, JobDate, Quantity, TotalCost, Status) VALUES
(1, 1, 1, '2025-10-01', 1000, 500.00, 'Завершено'),
(2, 2, 2, '2025-10-02', 2000, 800.00, 'В обработке'),
(3, 3, 3, '2025-10-03', 500, 500.00, 'Завершено'),
(4, 4, 4, '2025-10-04', 300, 600.00, 'В обработке'),
(5, 1, 1, '2025-10-05', 1500, 750.00, 'В обработке'),
(6, 2, 2, '2025-10-06', 2500, 1000.00, 'Завершено'),
(7, 3, 3, '2025-10-07', 700, 700.00, 'В обработке'),
(8, 4, 4, '2025-10-08', 400, 800.00, 'Завершено');

-- Запросы
SELECT 
    c.FirstName,
    c.LastName,
    m.MaterialName,
    (SELECT SUM(pj2.Quantity) 
     FROM PrintJobs pj2 
     WHERE pj2.ClientID = c.ClientID) AS TotalQuantity
FROM Clients c
JOIN PrintJobs pj ON c.ClientID = pj.ClientID
JOIN Materials m ON pj.MaterialID = m.MaterialID
WHERE (SELECT SUM(pj2.Quantity) 
       FROM PrintJobs pj2 
       WHERE pj2.ClientID = c.ClientID) > 
      (SELECT AVG(CAST(SUM(pj3.Quantity) AS FLOAT)) 
       FROM PrintJobs pj3 
       GROUP BY pj3.ClientID)
ORDER BY TotalQuantity DESC;

SELECT DISTINCT
    c.FirstName,
    c.LastName
FROM Clients c
WHERE c.ClientID IN (
    SELECT pj.ClientID
    FROM PrintJobs pj
    WHERE pj.Status = 'Завершено'
);

SELECT 
    c.FirstName,
    c.LastName,
    e.EquipmentName,
    pj.JobDate
FROM Clients c
JOIN PrintJobs pj ON c.ClientID = pj.ClientID
JOIN Equipment e ON pj.EquipmentID = e.EquipmentID
WHERE pj.JobDate > (
    SELECT AVG(pj2.JobDate)
    FROM PrintJobs pj2
    JOIN Equipment e2 ON pj2.EquipmentID = e2.EquipmentID
    WHERE e2.EquipmentID = e.EquipmentID
);

SELECT DISTINCT
    c.FirstName,
    c.LastName,
    c.Email
FROM Clients c
WHERE EXISTS (
    SELECT 1
    FROM PrintJobs pj
    JOIN Materials m ON pj.MaterialID = m.MaterialID
    WHERE pj.ClientID = c.ClientID 
    AND m.MaterialName = 'Глянцевая бумага'
);

-- Курсоры
DECLARE @ClientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @JobCount INT;

DECLARE client_cursor CURSOR FOR
SELECT 
    c.ClientID,
    c.FirstName, 
    c.LastName,
    COUNT(pj.JobID) AS JobCount
FROM Clients c
LEFT JOIN PrintJobs pj ON c.ClientID = pj.ClientID
GROUP BY c.ClientID, c.FirstName, c.LastName
ORDER BY c.LastName;

OPEN client_cursor;

FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @JobCount;

PRINT 'ОТЧЁТ ПО ЗАКАЗАМ КЛИЕНТОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @JobCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + ') - Нет заказов';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + 
              ') - Количество заказов: ' + CAST(@JobCount AS VARCHAR);

    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @JobCount;
END;

CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @MaterialID INT, @MaterialName NVARCHAR(100);
DECLARE @ClFirstName NVARCHAR(50), @ClLastName NVARCHAR(50), @ClEmail NVARCHAR(100);

DECLARE material_cursor CURSOR FOR
SELECT MaterialID, MaterialName
FROM Materials
ORDER BY MaterialName;

OPEN material_cursor;
FETCH NEXT FROM material_cursor INTO @MaterialID, @MaterialName;

PRINT 'КЛИЕНТЫ ПО МАТЕРИАЛАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'МАТЕРИАЛ: ' + @MaterialName;
    PRINT '----------------------------------------';

    DECLARE client_material_cursor CURSOR LOCAL FOR
    SELECT c.FirstName, c.LastName, c.Email
    FROM Clients c
    JOIN PrintJobs pj ON c.ClientID = pj.ClientID
    WHERE pj.MaterialID = @MaterialID AND pj.Status = 'Завершено'
    ORDER BY c.LastName;

    OPEN client_material_cursor;
    FETCH NEXT FROM client_material_cursor INTO @ClFirstName, @ClLastName, @ClEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет клиентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @ClLastName + ' ' + @ClFirstName + ' - ' + ISNULL(@ClEmail, 'Нет email');
        FETCH NEXT FROM client_material_cursor INTO @ClFirstName, @ClLastName, @ClEmail;
    END;

    CLOSE client_material_cursor;
    DEALLOCATE client_material_cursor;

    FETCH NEXT FROM material_cursor INTO @MaterialID, @MaterialName;
END;

CLOSE material_cursor;
DEALLOCATE material_cursor;

DECLARE @JobID INT, @JobDate DATE;

DECLARE job_cursor CURSOR FOR
SELECT JobID, JobDate
FROM PrintJobs
WHERE Status = 'В обработке' AND JobDate <= DATEADD(DAY, -30, GETDATE());

OPEN job_cursor;
FETCH NEXT FROM job_cursor INTO @JobID, @JobDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ЗАКАЗОВ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE PrintJobs
    SET Status = 'Отменено'
    WHERE JobID = @JobID;

    PRINT 'Заказ ID ' + CAST(@JobID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM job_cursor INTO @JobID, @JobDate;
END;

CLOSE job_cursor;
DEALLOCATE job_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Clients_Phone ON Clients(Phone);
CREATE INDEX IX_PrintJobs_ClientID ON PrintJobs(ClientID);
CREATE INDEX IX_PrintJobs_MaterialID ON PrintJobs(MaterialID);
CREATE INDEX IX_PrintJobs_EquipmentID ON PrintJobs(EquipmentID);
CREATE INDEX IX_PrintJobs_JobDate ON PrintJobs(JobDate);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE job_cursor_perf CURSOR FOR SELECT JobID FROM PrintJobs WHERE Status = 'Завершено';
OPEN job_cursor_perf;
FETCH NEXT FROM job_cursor_perf INTO @JobID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM job_cursor_perf INTO @JobID;
END;
CLOSE job_cursor_perf;
DEALLOCATE job_cursor_perf;

PRINT 'Курсор - количество завершённых заказов: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM PrintJobs WHERE Status = 'Завершено';
PRINT 'Множественный запрос - количество завершённых заказов: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;