-- 1
CREATE DATABASE FactoryDB;
USE FactoryDB;

-- 2
CREATE TABLE Workshops (
    WorkshopID INT IDENTITY(1,1) PRIMARY KEY,
    WorkshopName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE,
    WorkshopID INT FOREIGN KEY REFERENCES Workshops(WorkshopID),
    Salary DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    WorkshopID INT FOREIGN KEY REFERENCES Workshops(WorkshopID),
    UnitPrice DECIMAL(8,2),
    ProductionTimeHours INT
);

CREATE TABLE Shifts (
    ShiftID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    WorkshopID INT FOREIGN KEY REFERENCES Workshops(WorkshopID),
    ShiftDate DATE,
    StartTime TIME,
    EndTime TIME
);

CREATE TABLE Equipment (
    EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
    EquipmentName NVARCHAR(100) NOT NULL,
    WorkshopID INT FOREIGN KEY REFERENCES Workshops(WorkshopID),
    PurchaseDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('Работает', 'На обслуживании', 'Выведено из эксплуатации'))
);

-- 2
INSERT INTO Workshops (WorkshopName, Location) VALUES
('Сборочный цех', 'Здание А'),
('Механический цех', 'Здание Б'),
('Упаковочный цех', 'Здание В'),
('Контроль качества', 'Здание Г');

INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, WorkshopID, Salary) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '2020-01-15', 1, 5000.00),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '2020-02-20', 2, 5500.00),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '2020-03-10', 3, 4800.00),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '2020-04-25', 4, 5200.00),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '2020-05-18', 1, 4900.00),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '2020-06-28', 2, 5600.00),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '2020-07-05', 3, 4700.00),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '2020-08-10', 4, 5300.00),
('Лидия', 'Мартынова', 'lidiya.martynova@email.com', '+6598765434', '2020-09-17', 1, 5000.00),
('Алексей', 'Попов', 'alexey.popov@email.com', '+79123456784', '2020-10-20', 2, 5700.00),
('Светлана', 'Волкова', 'svetlana.volkova@email.com', '+12025550126', '2020-11-11', 3, 4600.00),
('Анастасия', 'Козлова', 'anastasia.kozlova@email.com', '+447911123459', '2020-12-25', 4, 5400.00),
('Роберт', 'Алленов', 'robert.allenov@email.com', '+6598765435', '2021-01-30', 1, 5100.00),
('Наталья', 'Смирнова', 'natalia.smirnova@email.com', '+79123456783', '2021-02-15', 2, 5800.00),
('Виктор', 'Молодцов', 'viktor.molodtsov@email.com', '+12025550127', '2021-03-22', 3, 4500.00),
('Виктория', 'Королёва', 'viktoria.koroleva@email.com', '+447911123460', '2021-04-08', 4, 5500.00),
('Дмитрий', 'Волков', 'dmitry.volkov@email.com', '+79123456782', '2021-05-14', 1, 5200.00),
('Лариса', 'Скворцова', 'larisa.skvortsova@email.com', '+12025550128', '2021-06-01', 2, 5900.00),
('Павел', 'Зелёный', 'pavel.zeleny@email.com', '+447911123461', '2021-07-27', 3, 4400.00),
('Екатерина', 'Фёдорова', 'ekaterina.fedorova@email.com', '+79123456781', '2021-08-19', 4, 5600.00),
('Георгий', 'Бакланов', 'georgiy.baklanov@email.com', '+6598765436', '2021-09-05', 1, 5300.00),
('Анастасия', 'Смирнова', 'anastasia.smirnova2@email.com', '+79123456780', '2021-10-12', 2, 6000.00),
('Чарльз', 'Харрисов', 'charles.harrisov@email.com', '+12025550129', '2021-11-20', 3, 4300.00),
('Марина', 'Гусева', 'marina.guseva@email.com', '+79123456779', '2021-12-15', 4, 5700.00),
('Геннадий', 'Левин', 'gennadiy.levin@email.com', '+447911123462', '2022-01-10', 1, 5400.00),
('Светлана', 'Васильева', 'svetlana.vasilieva@email.com', '+79123456778', '2022-02-25', 2, 6100.00),
('Эдуард', 'Волков', 'eduard.volkov@email.com', '+12025550130', '2022-03-30', 3, 4200.00),
('Ирина', 'Михайлова', 'irina.mikhailova@email.com', '+79123456777', '2022-04-22', 4, 5800.00),
('Степан', 'Белый', 'stepan.bely@email.com', '+447911123463', '2022-05-17', 1, 5500.00),
('Ольга', 'Коваленко', 'olga.kovalenko@email.com', '+79123456776', '2022-06-05', 2, 6200.00),
('Ричард', 'Кларков', 'richard.clarkov@email.com', '+12025550131', '2022-07-20', 3, 4100.00),
('Татьяна', 'Лебедева', 'tatiana.lebedeva@email.com', '+79123456775', '2022-08-15', 4, 5900.00),
('Даниил', 'Холмов', 'daniil.holmov@email.com', '+447911123464', '2022-09-25', 1, 5600.00),
('Елена', 'Романова', 'elena.romanova@email.com', '+79123456774', '2022-10-10', 2, 6300.00),
('Марк', 'Турнов', 'mark.turnov@email.com', '+12025550132', '2022-11-01', 3, 4000.00),
('Юлия', 'Соколова', 'yulia.sokolova@email.com', '+79123456773', '2022-12-15', 4, 6000.00),
('Андрей', 'Морозов', 'andrey.morozov@email.com', '+447911123465', '2023-01-20', 1, 5700.00),
('Марина', 'Беляева', 'marina.belyaeva@email.com', '+79123456772', '2023-02-10', 2, 6400.00),
('Пётр', 'Райт', 'petr.rayt@email.com', '+12025550133', '2023-03-05', 3, 3900.00),
('Анна', 'Зайцева', 'anna.zaytseva@email.com', '+79123456771', '2023-04-28', 4, 6100.00),
('Фома', 'Хьюзов', 'foma.huzov@email.com', '+447911123466', '2023-05-15', 1, 5800.00),
('София', 'Козлова', 'sofia.kozlova2@email.com', '+79123456770', '2023-06-20', 2, 6500.00),
('Яков', 'Парков', 'yakov.parkov@email.com', '+12025550134', '2023-07-10', 3, 3800.00),
('Вера', 'Орлова', 'vera.orlova@email.com', '+79123456769', '2023-08-25', 4, 6200.00),
('Михаил', 'Кук', 'mikhail.kuk@email.com', '+447911123467', '2023-09-30', 1, 5900.00),
('Наталья', 'Гусева', 'natalia.guseva@email.com', '+79123456768', '2023-10-15', 2, 6600.00),
('Давид', 'Коричневый', 'david.korichnevy@email.com', '+12025550135', '2023-11-20', 3, 3700.00),
('Елена', 'Попова', 'elena.popova@email.com', '+79123456767', '2023-12-15', 4, 6300.00),
('Иван', 'Тайлоров', 'ivan.taylorov@email.com', '+447911123468', '2024-01-10', 1, 6000.00),
('Мария', 'Иванова', 'maria.ivanova@email.com', '+79123456766', '2024-02-25', 2, 6700.00);

INSERT INTO Products (ProductName, WorkshopID, UnitPrice, ProductionTimeHours) VALUES
('Коробка передач', 1, 200.00, 10),
('Деталь двигателя', 2, 150.00, 8),
('Упаковочная коробка', 3, 5.00, 2),
('Отчёт по качеству', 4, 50.00, 4);

INSERT INTO Shifts (EmployeeID, WorkshopID, ShiftDate, StartTime, EndTime) VALUES
(1, 1, '2025-10-01', '08:00:00', '16:00:00'),
(2, 2, '2025-10-01', '09:00:00', '17:00:00'),
(3, 3, '2025-10-02', '07:00:00', '15:00:00'),
(4, 4, '2025-10-02', '10:00:00', '18:00:00'),
(5, 1, '2025-10-03', '08:00:00', '16:00:00'),
(6, 2, '2025-10-03', '09:00:00', '17:00:00'),
(7, 3, '2025-10-04', '07:00:00', '15:00:00'),
(8, 4, '2025-10-04', '10:00:00', '18:00:00'),
(9, 1, '2025-10-05', '08:00:00', '16:00:00'),
(10, 2, '2025-10-05', '09:00:00', '17:00:00'),
(11, 3, '2025-10-06', '07:00:00', '15:00:00'),
(12, 4, '2025-10-06', '10:00:00', '18:00:00'),
(13, 1, '2025-10-07', '08:00:00', '16:00:00'),
(14, 2, '2025-10-07', '09:00:00', '17:00:00'),
(15, 3, '2025-10-08', '07:00:00', '15:00:00'),
(16, 4, '2025-10-08', '10:00:00', '18:00:00'),
(17, 1, '2025-10-09', '08:00:00', '16:00:00'),
(18, 2, '2025-10-09', '09:00:00', '17:00:00'),
(19, 3, '2025-10-10', '07:00:00', '15:00:00'),
(20, 4, '2025-10-10', '10:00:00', '18:00:00'),
(21, 1, '2025-10-11', '08:00:00', '16:00:00'),
(22, 2, '2025-10-11', '09:00:00', '17:00:00'),
(23, 3, '2025-10-12', '07:00:00', '15:00:00'),
(24, 4, '2025-10-12', '10:00:00', '18:00:00'),
(25, 1, '2025-10-13', '08:00:00', '16:00:00'),
(26, 2, '2025-10-13', '09:00:00', '17:00:00'),
(27, 3, '2025-10-14', '07:00:00', '15:00:00'),
(28, 4, '2025-10-14', '10:00:00', '18:00:00'),
(29, 1, '2025-10-15', '08:00:00', '16:00:00'),
(30, 2, '2025-10-15', '09:00:00', '17:00:00'),
(31, 3, '2025-10-16', '07:00:00', '15:00:00'),
(32, 4, '2025-10-16', '10:00:00', '18:00:00'),
(33, 1, '2025-10-17', '08:00:00', '16:00:00'),
(34, 2, '2025-10-17', '09:00:00', '17:00:00'),
(35, 3, '2025-10-18', '07:00:00', '15:00:00'),
(36, 4, '2025-10-18', '10:00:00', '18:00:00'),
(37, 1, '2025-10-19', '08:00:00', '16:00:00'),
(38, 2, '2025-10-19', '09:00:00', '17:00:00'),
(39, 3, '2025-10-20', '07:00:00', '15:00:00'),
(40, 4, '2025-10-20', '10:00:00', '18:00:00'),
(41, 1, '2025-10-21', '08:00:00', '16:00:00'),
(42, 2, '2025-10-21', '09:00:00', '17:00:00'),
(43, 3, '2025-10-22', '07:00:00', '15:00:00'),
(44, 4, '2025-10-22', '10:00:00', '18:00:00'),
(45, 1, '2025-10-23', '08:00:00', '16:00:00'),
(46, 2, '2025-10-23', '09:00:00', '17:00:00'),
(47, 3, '2025-10-24', '07:00:00', '15:00:00'),
(48, 4, '2025-10-24', '10:00:00', '18:00:00'),
(49, 1, '2025-10-25', '08:00:00', '16:00:00'),
(50, 2, '2025-10-25', '09:00:00', '17:00:00');

INSERT INTO Equipment (EquipmentName, WorkshopID, PurchaseDate, Status) VALUES
('Станок ЧПУ', 1, '2020-01-01', 'Работает'),
('Токарный станок', 2, '2020-02-01', 'Работает'),
('Конвейерная лента', 3, '2020-03-01', 'На обслуживании'),
('Тестовый стенд', 4, '2020-04-01', 'Работает');

-- 3
SELECT 
    e.FirstName,
    e.LastName,
    w.WorkshopName,
    (SELECT COUNT(*) 
     FROM Shifts s2 
     WHERE s2.EmployeeID = e.EmployeeID) AS TotalShifts
FROM Employees e
JOIN Workshops w ON e.WorkshopID = w.WorkshopID
JOIN Shifts s ON e.EmployeeID = s.EmployeeID
WHERE (SELECT COUNT(*) 
       FROM Shifts s2 
       WHERE s2.EmployeeID = e.EmployeeID) > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Shifts s3 
       GROUP BY s3.EmployeeID)
ORDER BY TotalShifts DESC;

-- 3
SELECT DISTINCT
    e.FirstName,
    e.LastName
FROM Employees e
WHERE e.EmployeeID IN (
    SELECT s.EmployeeID
    FROM Shifts s
    JOIN Workshops w ON s.WorkshopID = w.WorkshopID
    WHERE w.WorkshopName = 'Сборочный цех'
);

-- 3
SELECT 
    e.FirstName,
    e.LastName,
    w.WorkshopName,
    s.ShiftDate
FROM Employees e
JOIN Shifts s ON e.EmployeeID = s.EmployeeID
JOIN Workshops w ON s.WorkshopID = w.WorkshopID
WHERE s.ShiftDate > (
    SELECT AVG(s2.ShiftDate)
    FROM Shifts s2
    JOIN Workshops w2 ON s2.WorkshopID = w2.WorkshopID
    WHERE w2.WorkshopID = w.WorkshopID
);

-- 4
SELECT DISTINCT
    e.FirstName,
    e.LastName,
    e.Email
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Shifts s
    JOIN Workshops w ON s.WorkshopID = w.WorkshopID
    WHERE s.EmployeeID = e.EmployeeID 
    AND w.WorkshopName = 'Механический цех'
);

-- 1
DECLARE @EmployeeID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @ShiftCount INT;

DECLARE employee_cursor CURSOR FOR
SELECT 
    e.EmployeeID,
    e.FirstName, 
    e.LastName,
    COUNT(s.ShiftID) AS ShiftCount
FROM Employees e
LEFT JOIN Shifts s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.LastName;

OPEN employee_cursor;

FETCH NEXT FROM employee_cursor INTO @EmployeeID, @FirstName, @LastName, @ShiftCount;

PRINT 'ОТЧЁТ ПО СМЕНАМ СОТРУДНИКОВ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @ShiftCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@EmployeeID AS VARCHAR) + ') - Нет смен';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@EmployeeID AS VARCHAR) + 
              ') - Общее количество смен: ' + CAST(@ShiftCount AS VARCHAR);

    FETCH NEXT FROM employee_cursor INTO @EmployeeID, @FirstName, @LastName, @ShiftCount;
END;

CLOSE employee_cursor;
DEALLOCATE employee_cursor;

-- 2
DECLARE @WorkshopID INT, @WorkshopName NVARCHAR(100);
DECLARE @EmpFirstName NVARCHAR(50), @EmpLastName NVARCHAR(50), @EmpEmail NVARCHAR(100);

DECLARE workshop_cursor CURSOR FOR
SELECT WorkshopID, WorkshopName
FROM Workshops
ORDER BY WorkshopName;

OPEN workshop_cursor;
FETCH NEXT FROM workshop_cursor INTO @WorkshopID, @WorkshopName;

PRINT 'СОТРУДНИКИ ПО ЦЕХАМ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'ЦЕХ: ' + @WorkshopName;
    PRINT '----------------------------------------';

    DECLARE employee_workshop_cursor CURSOR LOCAL FOR
    SELECT e.FirstName, e.LastName, e.Email
    FROM Employees e
    JOIN Shifts s ON e.EmployeeID = s.EmployeeID
    WHERE s.WorkshopID = @WorkshopID
    ORDER BY e.LastName;

    OPEN employee_workshop_cursor;
    FETCH NEXT FROM employee_workshop_cursor INTO @EmpFirstName, @EmpLastName, @EmpEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет сотрудников';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @EmpLastName + ' ' + @EmpFirstName + ' - ' + ISNULL(@EmpEmail, 'Нет email');
        FETCH NEXT FROM employee_workshop_cursor INTO @EmpFirstName, @EmpLastName, @EmpEmail;
    END;

    CLOSE employee_workshop_cursor;
    DEALLOCATE employee_workshop_cursor;

    FETCH NEXT FROM workshop_cursor INTO @WorkshopID, @WorkshopName;
END;

CLOSE workshop_cursor;
DEALLOCATE workshop_cursor;

-- 3
DECLARE @EquipmentID INT, @PurchaseDate DATE;

DECLARE equipment_cursor CURSOR FOR
SELECT EquipmentID, PurchaseDate
FROM Equipment
WHERE PurchaseDate <= DATEADD(YEAR, -5, GETDATE());

OPEN equipment_cursor;
FETCH NEXT FROM equipment_cursor INTO @EquipmentID, @PurchaseDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА СТАРОГО ОБОРУДОВАНИЯ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Equipment
    SET Status = 'На обслуживании'
    WHERE EquipmentID = @EquipmentID;

    PRINT 'Оборудование ID ' + CAST(@EquipmentID AS VARCHAR) + ' - статус изменён на "На обслуживании"';

    FETCH NEXT FROM equipment_cursor INTO @EquipmentID, @PurchaseDate;
END;

CLOSE equipment_cursor;
DEALLOCATE equipment_cursor;

PRINT 'Обновление завершено.';

-- 5
CREATE INDEX IX_Employees_Phone ON Employees(Phone);
CREATE INDEX IX_Shifts_EmployeeID ON Shifts(EmployeeID);
CREATE INDEX IX_Shifts_WorkshopID ON Shifts(WorkshopID);
CREATE INDEX IX_Products_WorkshopID ON Products(WorkshopID);
CREATE INDEX