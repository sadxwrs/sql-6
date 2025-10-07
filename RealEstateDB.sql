-- Создание базы данных
CREATE DATABASE RealEstateDB;
USE RealEstateDB;

-- Создание таблиц
CREATE TABLE PropertyTypes (
    TypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL
);

CREATE TABLE Agents (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);

CREATE TABLE Properties (
    PropertyID INT IDENTITY(1,1) PRIMARY KEY,
    TypeID INT FOREIGN KEY REFERENCES PropertyTypes(TypeID),
    Address NVARCHAR(200) NOT NULL,
    Price DECIMAL(12,2),
    Area INT,
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID)
);

CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT FOREIGN KEY REFERENCES Properties(PropertyID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    AgentID INT FOREIGN KEY REFERENCES Agents(AgentID),
    TransactionDate DATE,
    TransactionAmount DECIMAL(12,2),
    Status NVARCHAR(20) CHECK (Status IN ('Завершено', 'В процессе', 'Отменено'))
);

CREATE TABLE Viewings (
    ViewingID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT FOREIGN KEY REFERENCES Properties(PropertyID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    ViewingDate DATETIME
);

-- Вставка данных
INSERT INTO PropertyTypes (TypeName) VALUES
('Квартира'),
('Дом'),
('Коммерческая недвижимость'),
('Земельный участок');

INSERT INTO Agents (FirstName, LastName, Email, Phone) VALUES
('Анна', 'Смирнова', 'anna.smirnova@email.com', '+79123456701'),
('Иван', 'Петров', 'ivan.petrov@email.com', '+79123456702'),
('Екатерина', 'Иванова', 'ekaterina.ivanova@email.com', '+79123456703'),
('Михаил', 'Козлов', 'mikhail.kozlov@email.com', '+79123456704');

INSERT INTO Clients (FirstName, LastName, Email, Phone) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458');

INSERT INTO Properties (TypeID, Address, Price, Area, AgentID) VALUES
(1, 'ул. Ленина, 10, Москва', 150000.00, 75, 1),
(2, 'ул. Садовая, 5, Подмосковье', 250000.00, 150, 2),
(3, 'ул. Тверская, 20, Москва', 500000.00, 200, 3),
(4, 'ул. Полевая, 15, Подмосковье', 80000.00, 1000, 4);

INSERT INTO Transactions (PropertyID, ClientID, AgentID, TransactionDate, TransactionAmount, Status) VALUES
(1, 1, 1, '2025-09-01', 145000.00, 'Завершено'),
(2, 2, 2, '2025-09-02', 240000.00, 'В процессе'),
(3, 3, 3, '2025-09-03', 490000.00, 'Завершено'),
(4, 4, 4, '2025-09-04', 75000.00, 'В процессе');

INSERT INTO Viewings (PropertyID, ClientID, ViewingDate) VALUES
(1, 1, '2025-08-20 10:00:00'),
(2, 2, '2025-08-21 12:00:00'),
(3, 3, '2025-08-22 14:00:00'),
(4, 4, '2025-08-23 16:00:00');

-- Запросы
SELECT 
    c.FirstName,
    c.LastName,
    p.Address,
    (SELECT COUNT(*) 
     FROM Viewings v2 
     WHERE v2.ClientID = c.ClientID) AS TotalViewings
FROM Clients c
JOIN Viewings v ON c.ClientID = v.ClientID
JOIN Properties p ON v.PropertyID = p.PropertyID
WHERE (SELECT COUNT(*) 
       FROM Viewings v2 
       WHERE v2.ClientID = c.ClientID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Viewings v3 
       GROUP BY v3.ClientID)
ORDER BY TotalViewings DESC;

SELECT DISTINCT
    a.FirstName,
    a.LastName
FROM Agents a
WHERE a.AgentID IN (
    SELECT t.AgentID
    FROM Transactions t
    WHERE t.Status = 'Завершено'
);

SELECT 
    c.FirstName,
    c.LastName,
    pt.TypeName,
    t.TransactionDate
FROM Clients c
JOIN Transactions t ON c.ClientID = t.ClientID
JOIN Properties p ON t.PropertyID = p.PropertyID
JOIN PropertyTypes pt ON p.TypeID = pt.TypeID
WHERE t.TransactionAmount > (
    SELECT AVG(t2.TransactionAmount)
    FROM Transactions t2
    JOIN Properties p2 ON t2.PropertyID = p2.PropertyID
    WHERE p2.TypeID = pt.TypeID
);

SELECT DISTINCT
    c.FirstName,
    c.LastName,
    c.Email
FROM Clients c
WHERE EXISTS (
    SELECT 1
    FROM Viewings v
    JOIN Properties p ON v.PropertyID = p.PropertyID
    JOIN PropertyTypes pt ON p.TypeID = pt.TypeID
    WHERE v.ClientID = c.ClientID 
    AND pt.TypeName = 'Квартира'
);

-- Курсоры
DECLARE @ClientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @ViewingCount INT;

DECLARE client_cursor CURSOR FOR
SELECT 
    c.ClientID,
    c.FirstName, 
    c.LastName,
    COUNT(v.ViewingID) AS ViewingCount
FROM Clients c
LEFT JOIN Viewings v ON c.ClientID = v.ClientID
GROUP BY c.ClientID, c.FirstName, c.LastName
ORDER BY c.LastName;

OPEN client_cursor;

FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @ViewingCount;

PRINT 'ОТЧЁТ ПО ПРОСМОТРАМ КЛИЕНТОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @ViewingCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + ') - Нет просмотров';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + 
              ') - Количество просмотров: ' + CAST(@ViewingCount AS VARCHAR);

    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @ViewingCount;
END;

CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @TypeID INT, @TypeName NVARCHAR(50);
DECLARE @ClFirstName NVARCHAR(50), @ClLastName NVARCHAR(50), @ClEmail NVARCHAR(100);

DECLARE type_cursor CURSOR FOR
SELECT TypeID, TypeName
FROM PropertyTypes
ORDER BY TypeName;

OPEN type_cursor;
FETCH NEXT FROM type_cursor INTO @TypeID, @TypeName;

PRINT 'КЛИЕНТЫ ПО ТИПАМ НЕДВИЖИМОСТИ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'ТИП НЕДВИЖИМОСТИ: ' + @TypeName;
    PRINT '----------------------------------------';

    DECLARE client_type_cursor CURSOR LOCAL FOR
    SELECT c.FirstName, c.LastName, c.Email
    FROM Clients c
    JOIN Viewings v ON c.ClientID = v.ClientID
    JOIN Properties p ON v.PropertyID = p.PropertyID
    WHERE p.TypeID = @TypeID
    ORDER BY c.LastName;

    OPEN client_type_cursor;
    FETCH NEXT FROM client_type_cursor INTO @ClFirstName, @ClLastName, @ClEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет клиентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @ClLastName + ' ' + @ClFirstName + ' - ' + ISNULL(@ClEmail, 'Нет email');
        FETCH NEXT FROM client_type_cursor INTO @ClFirstName, @ClLastName, @ClEmail;
    END;

    CLOSE client_type_cursor;
    DEALLOCATE client_type_cursor;

    FETCH NEXT FROM type_cursor INTO @TypeID, @TypeName;
END;

CLOSE type_cursor;
DEALLOCATE type_cursor;

DECLARE @TransactionID INT, @TransactionDate DATE;

DECLARE transaction_cursor CURSOR FOR
SELECT TransactionID, TransactionDate
FROM Transactions
WHERE Status = 'В процессе' AND TransactionDate <= DATEADD(DAY, -30, GETDATE());

OPEN transaction_cursor;
FETCH NEXT FROM transaction_cursor INTO @TransactionID, @TransactionDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ СДЕЛОК';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Transactions
    SET Status = 'Отменено'
    WHERE TransactionID = @TransactionID;

    PRINT 'Сделка ID ' + CAST(@TransactionID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM transaction_cursor INTO @TransactionID, @TransactionDate;
END;

CLOSE transaction_cursor;
DEALLOCATE transaction_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Clients_Phone ON Clients(Phone);
CREATE INDEX IX_Properties_AgentID ON Properties(AgentID);
CREATE INDEX IX_Transactions_ClientID ON Transactions(ClientID);
CREATE INDEX IX_Transactions_PropertyID ON Transactions(PropertyID);
CREATE INDEX IX_Viewings_ViewingDate ON Viewings(ViewingDate);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE viewing_cursor_perf CURSOR FOR SELECT ViewingID FROM Viewings;
OPEN viewing_cursor_perf;
FETCH NEXT FROM viewing_cursor_perf INTO @ViewingID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM viewing_cursor_perf INTO @ViewingID;
END;
CLOSE viewing_cursor_perf;
DEALLOCATE viewing_cursor_perf;

PRINT 'Курсор - количество просмотров: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Viewings;
PRINT 'Множественный запрос - количество просмотров: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;