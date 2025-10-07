-- Создание базы данных
CREATE DATABASE DeliveryServiceDB;
USE DeliveryServiceDB;

-- Создание таблиц
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200)
);

CREATE TABLE Couriers (
    CourierID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    VehicleType NVARCHAR(50)
);

CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    CourierID INT FOREIGN KEY REFERENCES Couriers(CourierID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    OrderDate DATE,
    DeliveryDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('В обработке', 'Доставлено', 'Отменено'))
);

CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    CourierID INT FOREIGN KEY REFERENCES Couriers(CourierID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    RouteDate DATE,
    StartTime TIME,
    EndTime TIME
);

-- Вставка данных
INSERT INTO Clients (FirstName, LastName, Email, Phone, Address) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', 'ул. Ленина, 10, Москва'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', 'ул. Садовая, 5, Москва'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', 'ул. Тверская, 20, Москва'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', 'ул. Полевая, 15, Москва'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', 'ул. Центральная, 25, Москва'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', 'ул. Мира, 30, Москва'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', 'ул. Солнечная, 12, Москва'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', 'ул. Звёздная, 8, Москва');

INSERT INTO Couriers (FirstName, LastName, Email, Phone, VehicleType) VALUES
('Анна', 'Смирнова', 'anna.smirnova@email.com', '+79123456701', 'Автомобиль'),
('Иван', 'Петров', 'ivan.petrov@email.com', '+79123456702', 'Мотоцикл'),
('Екатерина', 'Иванова', 'ekaterina.ivanova@email.com', '+79123456703', 'Велосипед'),
('Михаил', 'Козлов', 'mikhail.kozlov@email.com', '+79123456704', 'Автомобиль');

INSERT INTO Warehouses (WarehouseName, Address) VALUES
('Склад Центральный', 'ул. Промышленная, 1, Москва'),
('Склад Южный', 'ул. Южная, 10, Москва'),
('Склад Северный', 'ул. Северная, 5, Москва'),
('Склад Восточный', 'ул. Восточная, 15, Москва');

INSERT INTO Orders (ClientID, CourierID, WarehouseID, OrderDate, DeliveryDate, Status) VALUES
(1, 1, 1, '2025-10-01', '2025-10-02', 'Доставлено'),
(2, 2, 2, '2025-10-02', '2025-10-03', 'В обработке'),
(3, 3, 3, '2025-10-03', '2025-10-04', 'Доставлено'),
(4, 4, 4, '2025-10-04', '2025-10-05', 'В обработке'),
(5, 1, 1, '2025-10-05', '2025-10-06', 'В обработке'),
(6, 2, 2, '2025-10-06', '2025-10-07', 'Доставлено'),
(7, 3, 3, '2025-10-07', '2025-10-08', 'В обработке'),
(8, 4, 4, '2025-10-08', '2025-10-09', 'Доставлено');

INSERT INTO Routes (CourierID, WarehouseID, RouteDate, StartTime, EndTime) VALUES
(1, 1, '2025-10-01', '08:00:00', '16:00:00'),
(2, 2, '2025-10-02', '09:00:00', '17:00:00'),
(3, 3, '2025-10-03', '07:00:00', '15:00:00'),
(4, 4, '2025-10-04', '10:00:00', '18:00:00'),
(1, 1, '2025-10-05', '08:00:00', '16:00:00'),
(2, 2, '2025-10-06', '09:00:00', '17:00:00'),
(3, 3, '2025-10-07', '07:00:00', '15:00:00'),
(4, 4, '2025-10-08', '10:00:00', '18:00:00');

-- Запросы
SELECT 
    c.FirstName,
    c.LastName,
    w.WarehouseName,
    (SELECT COUNT(*) 
     FROM Orders o2 
     WHERE o2.ClientID = c.ClientID) AS TotalOrders
FROM Clients c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN Warehouses w ON o.WarehouseID = w.WarehouseID
WHERE (SELECT COUNT(*) 
       FROM Orders o2 
       WHERE o2.ClientID = c.ClientID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Orders o3 
       GROUP BY o3.ClientID)
ORDER BY TotalOrders DESC;

SELECT DISTINCT
    co.FirstName,
    co.LastName
FROM Couriers co
WHERE co.CourierID IN (
    SELECT o.CourierID
    FROM Orders o
    WHERE o.Status = 'Доставлено'
);

SELECT 
    c.FirstName,
    c.LastName,
    w.WarehouseName,
    o.OrderDate
FROM Clients c
JOIN Orders o ON c.ClientID = o.ClientID
JOIN Warehouses w ON o.WarehouseID = w.WarehouseID
WHERE o.OrderDate > (
    SELECT AVG(o2.OrderDate)
    FROM Orders o2
    JOIN Warehouses w2 ON o2.WarehouseID = w2.WarehouseID
    WHERE w2.WarehouseID = w.WarehouseID
);

SELECT DISTINCT
    c.FirstName,
    c.LastName,
    c.Email
FROM Clients c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    JOIN Warehouses w ON o.WarehouseID = w.WarehouseID
    WHERE o.ClientID = c.ClientID 
    AND w.WarehouseName = 'Склад Центральный'
);

-- Курсоры
DECLARE @ClientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @OrderCount INT;

DECLARE client_cursor CURSOR FOR
SELECT 
    c.ClientID,
    c.FirstName, 
    c.LastName,
    COUNT(o.OrderID) AS OrderCount
FROM Clients c
LEFT JOIN Orders o ON c.ClientID = o.ClientID
GROUP BY c.ClientID, c.FirstName, c.LastName
ORDER BY c.LastName;

OPEN client_cursor;

FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @OrderCount;

PRINT 'ОТЧЁТ ПО ЗАКАЗАМ КЛИЕНТОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @OrderCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + ') - Нет заказов';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ClientID AS VARCHAR) + 
              ') - Количество заказов: ' + CAST(@OrderCount AS VARCHAR);

    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @OrderCount;
END;

CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @WarehouseID INT, @WarehouseName NVARCHAR(100);
DECLARE @ClFirstName NVARCHAR(50), @ClLastName NVARCHAR(50), @ClEmail NVARCHAR(100);

DECLARE warehouse_cursor CURSOR FOR
SELECT WarehouseID, WarehouseName
FROM Warehouses
ORDER BY WarehouseName;

OPEN warehouse_cursor;
FETCH NEXT FROM warehouse_cursor INTO @WarehouseID, @WarehouseName;

PRINT 'КЛИЕНТЫ ПО СКЛАДАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'СКЛАД: ' + @WarehouseName;
    PRINT '----------------------------------------';

    DECLARE client_warehouse_cursor CURSOR LOCAL FOR
    SELECT c.FirstName, c.LastName, c.Email
    FROM Clients c
    JOIN Orders o ON c.ClientID = o.ClientID
    WHERE o.WarehouseID = @WarehouseID AND o.Status = 'Доставлено'
    ORDER BY c.LastName;

    OPEN client_warehouse_cursor;
    FETCH NEXT FROM client_warehouse_cursor INTO @ClFirstName, @ClLastName, @ClEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет клиентов';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @ClLastName + ' ' + @ClFirstName + ' - ' + ISNULL(@ClEmail, 'Нет email');
        FETCH NEXT FROM client_warehouse_cursor INTO @ClFirstName, @ClLastName, @ClEmail;
    END;

    CLOSE client_warehouse_cursor;
    DEALLOCATE client_warehouse_cursor;

    FETCH NEXT FROM warehouse_cursor INTO @WarehouseID, @WarehouseName;
END;

CLOSE warehouse_cursor;
DEALLOCATE warehouse_cursor;

DECLARE @OrderID INT, @OrderDate DATE;

DECLARE order_cursor CURSOR FOR
SELECT OrderID, OrderDate
FROM Orders
WHERE Status = 'В обработке' AND OrderDate <= DATEADD(DAY, -7, GETDATE());

OPEN order_cursor;
FETCH NEXT FROM order_cursor INTO @OrderID, @OrderDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ЗАКАЗОВ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Orders
    SET Status = 'Отменено'
    WHERE OrderID = @OrderID;

    PRINT 'Заказ ID ' + CAST(@OrderID AS VARCHAR) + ' - статус изменён на "Отменено"';

    FETCH NEXT FROM order_cursor INTO @OrderID, @OrderDate;
END;

CLOSE order_cursor;
DEALLOCATE order_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Clients_Phone ON Clients(Phone);
CREATE INDEX IX_Orders_ClientID ON Orders(ClientID);
CREATE INDEX IX_Orders_CourierID ON Orders(CourierID);
CREATE INDEX IX_Orders_WarehouseID ON Orders(WarehouseID);
CREATE INDEX IX_Routes_RouteDate ON Routes(RouteDate);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE order_cursor_perf CURSOR FOR SELECT OrderID FROM Orders WHERE Status = 'Доставлено';
OPEN order_cursor_perf;
FETCH NEXT FROM order_cursor_perf INTO @OrderID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM order_cursor_perf INTO @OrderID;
END;
CLOSE order_cursor_perf;
DEALLOCATE order_cursor_perf;

PRINT 'Курсор - количество доставленных заказов: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Orders WHERE Status = 'Доставлено';
PRINT 'Множественный запрос - количество доставленных заказов: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;