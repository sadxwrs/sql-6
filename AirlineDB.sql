-- Создание базы данных
CREATE DATABASE AirlineDB;
USE AirlineDB;

-- Создание таблиц
CREATE TABLE Airports (
    AirportID INT IDENTITY(1,1) PRIMARY KEY,
    AirportName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50),
    Country NVARCHAR(50)
);

CREATE TABLE Aircraft (
    AircraftID INT IDENTITY(1,1) PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    Capacity INT,
    RegistrationNumber NVARCHAR(20)
);

CREATE TABLE CrewMembers (
    CrewMemberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Role NVARCHAR(50)
);

CREATE TABLE Flights (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    FlightNumber NVARCHAR(20) NOT NULL,
    AircraftID INT FOREIGN KEY REFERENCES Aircraft(AircraftID),
    DepartureAirportID INT FOREIGN KEY REFERENCES Airports(AirportID),
    ArrivalAirportID INT FOREIGN KEY REFERENCES Airports(AirportID),
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    Status NVARCHAR(20) CHECK (Status IN ('Запланирован', 'В полёте', 'Прибыл', 'Отменён'))
);

CREATE TABLE Passengers (
    PassengerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    PassportNumber NVARCHAR(20)
);

CREATE TABLE FlightAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT FOREIGN KEY REFERENCES Flights(FlightID),
    CrewMemberID INT FOREIGN KEY REFERENCES CrewMembers(CrewMemberID)
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT FOREIGN KEY REFERENCES Flights(FlightID),
    PassengerID INT FOREIGN KEY REFERENCES Passengers(PassengerID),
    SeatNumber NVARCHAR(10),
    TicketPrice DECIMAL(8,2)
);

-- Вставка данных
INSERT INTO Airports (AirportName, City, Country) VALUES
('Шереметьево', 'Москва', 'Россия'),
('Домодедово', 'Москва', 'Россия'),
('Пулково', 'Санкт-Петербург', 'Россия'),
('Внуково', 'Москва', 'Россия');

INSERT INTO Aircraft (Model, Capacity, RegistrationNumber) VALUES
('Боинг 737', 180, 'RA-12345'),
('Аэробус A320', 150, 'RA-67890'),
('Боинг 777', 300, 'RA-54321'),
('Аэробус A350', 250, 'RA-09876');

INSERT INTO CrewMembers (FirstName, LastName, Email, Phone, Role) VALUES
('Анна', 'Смирнова', 'anna.smirnova@email.com', '+79123456701', 'Пилот'),
('Иван', 'Петров', 'ivan.petrov@email.com', '+79123456702', 'Второй пилот'),
('Екатерина', 'Иванова', 'ekaterina.ivanova@email.com', '+79123456703', 'Бортпроводник'),
('Михаил', 'Козлов', 'mikhail.kozlov@email.com', '+79123456704', 'Бортпроводник');

INSERT INTO Flights (FlightNumber, AircraftID, DepartureAirportID, ArrivalAirportID, DepartureTime, ArrivalTime, Status) VALUES
('SU101', 1, 1, 3, '2025-10-01 08:00:00', '2025-10-01 10:00:00', 'Прибыл'),
('SU202', 2, 2, 4, '2025-10-02 12:00:00', '2025-10-02 14:00:00', 'Запланирован'),
('SU303', 3, 3, 1, '2025-10-03 15:00:00', '2025-10-03 17:00:00', 'Прибыл'),
('SU404', 4, 4, 2, '2025-10-04 18:00:00', '2025-10-04 20:00:00', 'Запланирован');

INSERT INTO Passengers (FirstName, LastName, Email, Phone, PassportNumber) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '123456789'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '987654321'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '456789123'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '321654987'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '789123456'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '654987321'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '147258369'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '258369147');

INSERT INTO FlightAssignments (FlightID, CrewMemberID) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 1),
(3, 3),
(4, 2),
(4, 4);

INSERT INTO Tickets (FlightID, PassengerID, SeatNumber, TicketPrice) VALUES
(1, 1, '12A', 200.00),
(2, 2, '15B', 180.00),
(3, 3, '20C', 250.00),
(4, 4, '10D', 220.00);

-- Запросы
SELECT 
    p.FirstName,
    p.LastName,
    f.FlightNumber,
    (SELECT COUNT(*) 
     FROM Tickets t2 
     WHERE t2.PassengerID = p.PassengerID) AS TotalTickets
FROM Passengers p
JOIN Tickets t ON p.PassengerID = t.PassengerID
JOIN Flights f ON t.FlightID = f.FlightID
WHERE (SELECT COUNT(*) 
       FROM Tickets t2 
       WHERE t2.PassengerID = p.PassengerID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Tickets t3 
       GROUP BY t3.PassengerID)
ORDER BY TotalTickets DESC;

SELECT DISTINCT
    c.FirstName,
    c.LastName
FROM CrewMembers c
WHERE c.CrewMemberID IN (
    SELECT fa.CrewMemberID
    FROM FlightAssignments fa
    JOIN Flights f ON fa.FlightID = f.FlightID
    WHERE f.Status = 'Прибыл'
);

SELECT 
    p.FirstName,
    p.LastName,
    a.AirportName AS ArrivalAirport,
    f.DepartureTime
FROM Passengers p
JOIN Tickets t ON p.PassengerID = t.PassengerID
JOIN Flights f ON t.FlightID = f.FlightID
JOIN Airports a ON f.ArrivalAirportID = a.AirportID
WHERE f.DepartureTime > (
    SELECT AVG(f2.DepartureTime)
    FROM Flights f2
    JOIN Airports a2 ON f2.ArrivalAirportID = a2.AirportID
    WHERE a2.AirportID = a.AirportID
);

SELECT DISTINCT
    p.FirstName,
    p.LastName,
    p.Email
FROM Passengers p
WHERE EXISTS (
    SELECT 1
    FROM Tickets t
    JOIN Flights f ON t.FlightID = f.FlightID
    JOIN Airports a ON f.ArrivalAirportID = a.AirportID
    WHERE t.PassengerID = p.PassengerID 
    AND a.AirportName = 'Пулково'
);

-- Курсоры
DECLARE @PassengerID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @TicketCount INT;

DECLARE passenger_cursor CURSOR FOR
SELECT 
    p.PassengerID,
    p.FirstName, 
    p.LastName,
    COUNT(t.TicketID) AS TicketCount
FROM Passengers p
LEFT JOIN Tickets t ON p.PassengerID = t.PassengerID
GROUP BY p.PassengerID, p.FirstName, p.LastName
ORDER BY p.LastName;

OPEN passenger_cursor;

FETCH NEXT FROM passenger_cursor INTO @PassengerID, @FirstName, @LastName, @TicketCount;

PRINT 'ОТЧЁТ ПО БИЛЕТАМ ПАССАЖИРОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @TicketCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@PassengerID AS VARCHAR) + ') - Нет билетов';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@PassengerID AS VARCHAR) + 
              ') - Количество билетов: ' + CAST(@TicketCount AS VARCHAR);

    FETCH NEXT FROM passenger_cursor INTO @PassengerID, @FirstName, @LastName, @TicketCount;
END;

CLOSE passenger_cursor;
DEALLOCATE passenger_cursor;

DECLARE @AirportID INT, @AirportName NVARCHAR(100);
DECLARE @PsFirstName NVARCHAR(50), @PsLastName NVARCHAR(50), @PsEmail NVARCHAR(100);

DECLARE airport_cursor CURSOR FOR
SELECT AirportID, AirportName
FROM Airports
ORDER BY AirportName;

OPEN airport_cursor;
FETCH NEXT FROM airport_cursor INTO @AirportID, @AirportName;

PRINT 'ПАССАЖИРЫ ПО АЭРОПОРТАМ ПРИЛЁТА';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'АЭРОПОРТ: ' + @AirportName;
    PRINT '----------------------------------------';

    DECLARE passenger_airport_cursor CURSOR LOCAL FOR
    SELECT p.FirstName, p.LastName, p.Email
    FROM Passengers p
    JOIN Tickets t ON p.PassengerID = t.PassengerID
    JOIN Flights f ON t.FlightID = f.FlightID
    WHERE f.ArrivalAirportID = @AirportID
    ORDER BY p.LastName;

    OPEN passenger_airport_cursor;
    FETCH NEXT FROM passenger_airport_cursor INTO @PsFirstName, @PsLastName, @PsEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет пассажиров';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @PsLastName + ' ' + @PsFirstName + ' - ' + ISNULL(@PsEmail, 'Нет email');
        FETCH NEXT FROM passenger_airport_cursor INTO @PsFirstName, @PsLastName, @PsEmail;
    END;

    CLOSE passenger_airport_cursor;
    DEALLOCATE passenger_airport_cursor;

    FETCH NEXT FROM airport_cursor INTO @AirportID, @AirportName;
END;

CLOSE airport_cursor;
DEALLOCATE airport_cursor;

DECLARE @FlightID INT, @DepartureTime DATETIME;

DECLARE flight_cursor CURSOR FOR
SELECT FlightID, DepartureTime
FROM Flights
WHERE Status = 'Запланирован' AND DepartureTime <= DATEADD(DAY, -1, GETDATE());

OPEN flight_cursor;
FETCH NEXT FROM flight_cursor INTO @FlightID, @DepartureTime;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ РЕЙСОВ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Flights
    SET Status = 'Отменён'
    WHERE FlightID = @FlightID;

    PRINT 'Рейс ID ' + CAST(@FlightID AS VARCHAR) + ' - статус изменён на "Отменён"';

    FETCH NEXT FROM flight_cursor INTO @FlightID, @DepartureTime;
END;

CLOSE flight_cursor;
DEALLOCATE flight_cursor;

PRINT 'Обновление завершено.';

-- Индексы
CREATE INDEX IX_Passengers_Phone ON Passengers(Phone);
CREATE INDEX IX_Flights_AircraftID ON Flights(AircraftID);
CREATE INDEX IX_Flights_DepartureAirportID ON Flights(DepartureAirportID);
CREATE INDEX IX_Tickets_PassengerID ON Tickets(PassengerID);
CREATE INDEX IX_FlightAssignments_FlightID ON FlightAssignments(FlightID);

-- Сравнение производительности
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE ticket_cursor_perf CURSOR FOR SELECT TicketID FROM Tickets;
OPEN ticket_cursor_perf;
FETCH NEXT FROM ticket_cursor_perf INTO @TicketID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM ticket_cursor_perf INTO @TicketID;
END;
CLOSE ticket_cursor_perf;
DEALLOCATE ticket_cursor_perf;

PRINT 'Курсор - количество билетов: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Tickets;
PRINT 'Множественный запрос - количество билетов: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;