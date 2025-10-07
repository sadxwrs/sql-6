-- 1
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- 2
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE
);

CREATE TABLE Readers (
    ReaderID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RegistrationDate DATE
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    PublicationYear INT,
    AvailableCopies INT
);

CREATE TABLE Checkouts (
    CheckoutID INT IDENTITY(1,1) PRIMARY KEY,
    ReaderID INT FOREIGN KEY REFERENCES Readers(ReaderID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    CheckoutDate DATE,
    ReturnDate DATE,
    Status NVARCHAR(20) CHECK (Status IN ('Активно', 'Возвращено', 'Просрочено'))
);

-- 2
INSERT INTO Categories (CategoryName) VALUES
('Художественная литература'),
('Научная литература'),
('Научная фантастика'),
('Биография');

INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES
('Лев', 'Толстой', '1828-09-09'),
('Екатерина', 'Иванова', '1775-12-16'),
('Исаак', 'Азимов', '1920-01-02'),
('Мария', 'Ангелова', '1928-04-04');

INSERT INTO Readers (FirstName, LastName, Email, Phone, RegistrationDate) VALUES
('Елена', 'Сидорова', 'elena.sidorova@email.com', '+79123456787', '2023-01-15'),
('Михаил', 'Лебедев', 'mikhail.lebedev@email.com', '+6598765432', '2023-02-20'),
('Софья', 'Тимофеева', 'sofia.timofeeva@email.com', '+447911123457', '2023-03-10'),
('Давид', 'Васильев', 'david.vasiliev@email.com', '+12025550124', '2023-04-25'),
('Эмма', 'Давыдова', 'emma.davydova@email.com', '+12025550125', '2023-05-18'),
('Иван', 'Кузнецов', 'ivan.kuznetsov@email.com', '+79123456786', '2023-06-28'),
('Ольга', 'Морозова', 'olga.morozova@email.com', '+79123456785', '2023-07-05'),
('Фёдор', 'Михайлов', 'fedor.mikhailov@email.com', '+447911123458', '2023-08-10'),
('Лидия', 'Мартынова', 'lidiya.martynova@email.com', '+6598765434', '2023-09-17'),
('Алексей', 'Попов', 'alexey.popov@email.com', '+79123456784', '2023-10-20'),
('Светлана', 'Волкова', 'svetlana.volkova@email.com', '+12025550126', '2023-11-11'),
('Анастасия', 'Козлова', 'anastasia.kozlova@email.com', '+447911123459', '2023-12-25'),
('Роберт', 'Алленов', 'robert.allenov@email.com', '+6598765435', '2024-01-30'),
('Наталья', 'Смирнова', 'natalia.smirnova@email.com', '+79123456783', '2024-02-15'),
('Виктор', 'Молодцов', 'viktor.molodtsov@email.com', '+12025550127', '2024-03-22'),
('Виктория', 'Королёва', 'viktoria.koroleva@email.com', '+447911123460', '2024-04-08'),
('Дмитрий', 'Волков', 'dmitry.volkov@email.com', '+79123456782', '2024-05-14'),
('Лариса', 'Скворцова', 'larisa.skvortsova@email.com', '+12025550128', '2024-06-01'),
('Павел', 'Зелёный', 'pavel.zeleny@email.com', '+447911123461', '2024-07-27'),
('Екатерина', 'Фёдорова', 'ekaterina.fedorova@email.com', '+79123456781', '2024-08-19'),
('Георгий', 'Бакланов', 'georgiy.baklanov@email.com', '+6598765436', '2024-09-05'),
('Анастасия', 'Смирнова', 'anastasia.smirnova2@email.com', '+79123456780', '2024-10-12'),
('Чарльз', 'Харрисов', 'charles.harrisov@email.com', '+12025550129', '2024-11-20'),
('Марина', 'Гусева', 'marina.guseva@email.com', '+79123456779', '2024-12-15'),
('Геннадий', 'Левин', 'gennadiy.levin@email.com', '+447911123462', '2025-01-10'),
('Светлана', 'Васильева', 'svetlana.vasilieva@email.com', '+79123456778', '2025-02-25'),
('Эдуард', 'Волков', 'eduard.volkov@email.com', '+12025550130', '2025-03-30'),
('Ирина', 'Михайлова', 'irina.mikhailova@email.com', '+79123456777', '2025-04-22'),
('Степан', 'Белый', 'stepan.bely@email.com', '+447911123463', '2025-05-17'),
('Ольга', 'Коваленко', 'olga.kovalenko@email.com', '+79123456776', '2025-06-05'),
('Ричард', 'Кларков', 'richard.clarkov@email.com', '+12025550131', '2025-07-20'),
('Татьяна', 'Лебедева', 'tatiana.lebedeva@email.com', '+79123456775', '2025-08-15'),
('Даниил', 'Холмов', 'daniil.holmov@email.com', '+447911123464', '2025-09-25'),
('Елена', 'Романова', 'elena.romanova@email.com', '+79123456774', '2025-10-10'),
('Марк', 'Турнов', 'mark.turnov@email.com', '+12025550132', '2025-11-01'),
('Юлия', 'Соколова', 'yulia.sokolova@email.com', '+79123456773', '2025-12-15'),
('Андрей', 'Морозов', 'andrey.morozov@email.com', '+447911123465', '2025-01-20'),
('Марина', 'Беляева', 'marina.belyaeva@email.com', '+79123456772', '2025-02-10'),
('Пётр', 'Райт', 'petr.rayt@email.com', '+12025550133', '2025-03-05'),
('Анна', 'Зайцева', 'anna.zaytseva@email.com', '+79123456771', '2025-04-28'),
('Фома', 'Хьюзов', 'foma.huzov@email.com', '+447911123466', '2025-05-15'),
('София', 'Козлова', 'sofia.kozlova2@email.com', '+79123456770', '2025-06-20'),
('Яков', 'Парков', 'yakov.parkov@email.com', '+12025550134', '2025-07-10'),
('Вера', 'Орлова', 'vera.orlova@email.com', '+79123456769', '2025-08-25'),
('Михаил', 'Кук', 'mikhail.kuk@email.com', '+447911123467', '2025-09-30'),
('Наталья', 'Гусева', 'natalia.guseva@email.com', '+79123456768', '2025-10-15'),
('Давид', 'Коричневый', 'david.korichnevy@email.com', '+12025550135', '2025-11-20'),
('Елена', 'Попова', 'elena.popova@email.com', '+79123456767', '2025-12-15'),
('Иван', 'Тайлоров', 'ivan.taylorov@email.com', '+447911123468', '2025-01-10'),
('Мария', 'Иванова', 'maria.ivanova@email.com', '+79123456766', '2025-02-25');

INSERT INTO Books (Title, AuthorID, CategoryID, PublicationYear, AvailableCopies) VALUES
('Война и мир', 1, 1, 1869, 5),
('Гордость и предубеждение', 2, 1, 1813, 3),
('Основание', 3, 3, 1951, 4),
('Я знаю, почему поёт птица в клетке', 4, 4, 1969, 2);

INSERT INTO Checkouts (ReaderID, BookID, CheckoutDate, ReturnDate, Status) VALUES
(1, 1, '2025-09-01', '2025-09-15', 'Возвращено'),
(2, 2, '2025-09-02', NULL, 'Активно'),
(3, 3, '2025-09-03', '2025-09-17', 'Возвращено'),
(4, 4, '2025-09-04', NULL, 'Активно'),
(5, 1, '2025-09-05', NULL, 'Активно'),
(6, 2, '2025-09-06', '2025-09-20', 'Возвращено'),
(7, 3, '2025-09-07', NULL, 'Активно'),
(8, 4, '2025-09-08', '2025-09-22', 'Возвращено'),
(9, 1, '2025-09-09', NULL, 'Активно'),
(10, 2, '2025-09-10', NULL, 'Активно'),
(11, 3, '2025-09-11', '2025-09-25', 'Возвращено'),
(12, 4, '2025-09-12', NULL, 'Активно'),
(13, 1, '2025-09-13', NULL, 'Активно'),
(14, 2, '2025-09-14', '2025-09-28', 'Возвращено'),
(15, 3, '2025-09-15', NULL, 'Активно'),
(16, 4, '2025-09-16', NULL, 'Активно'),
(17, 1, '2025-09-17', '2025-10-01', 'Возвращено'),
(18, 2, '2025-09-18', NULL, 'Активно'),
(19, 3, '2025-09-19', NULL, 'Активно'),
(20, 4, '2025-09-20', '2025-10-04', 'Возвращено'),
(21, 1, '2025-09-21', NULL, 'Активно'),
(22, 2, '2025-09-22', NULL, 'Активно'),
(23, 3, '2025-09-23', '2025-10-07', 'Возвращено'),
(24, 4, '2025-09-24', NULL, 'Активно'),
(25, 1, '2025-09-25', NULL, 'Активно'),
(26, 2, '2025-09-26', '2025-10-10', 'Возвращено'),
(27, 3, '2025-09-27', NULL, 'Активно'),
(28, 4, '2025-09-28', NULL, 'Активно'),
(29, 1, '2025-09-29', '2025-10-13', 'Возвращено'),
(30, 2, '2025-09-30', NULL, 'Активно'),
(31, 3, '2025-10-01', NULL, 'Активно'),
(32, 4, '2025-10-02', '2025-10-16', 'Возвращено'),
(33, 1, '2025-10-03', NULL, 'Активно'),
(34, 2, '2025-10-04', NULL, 'Активно'),
(35, 3, '2025-10-05', '2025-10-19', 'Возвращено'),
(36, 4, '2025-10-06', NULL, 'Активно'),
(37, 1, '2025-10-07', NULL, 'Активно'),
(38, 2, '2025-10-08', '2025-10-22', 'Возвращено'),
(39, 3, '2025-10-09', NULL, 'Активно'),
(40, 4, '2025-10-10', NULL, 'Активно'),
(41, 1, '2025-10-11', '2025-10-25', 'Возвращено'),
(42, 2, '2025-10-12', NULL, 'Активно'),
(43, 3, '2025-10-13', NULL, 'Активно'),
(44, 4, '2025-10-14', '2025-10-28', 'Возвращено'),
(45, 1, '2025-10-15', NULL, 'Активно'),
(46, 2, '2025-10-16', NULL, 'Активно'),
(47, 3, '2025-10-17', '2025-10-31', 'Возвращено'),
(48, 4, '2025-10-18', NULL, 'Активно'),
(49, 1, '2025-10-19', NULL, 'Активно'),
(50, 2, '2025-10-20', '2025-11-03', 'Возвращено');

-- 3
SELECT 
    r.FirstName,
    r.LastName,
    c.CategoryName,
    (SELECT COUNT(*) 
     FROM Checkouts ch2 
     WHERE ch2.ReaderID = r.ReaderID AND ch2.Status = 'Возвращено') AS ReturnedBooks
FROM Readers r
JOIN Checkouts ch ON r.ReaderID = ch.ReaderID
JOIN Books b ON ch.BookID = b.BookID
JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE (SELECT COUNT(*) 
       FROM Checkouts ch2 
       WHERE ch2.ReaderID = r.ReaderID AND ch2.Status = 'Возвращено') > 
      (SELECT AVG(CAST(COUNT(*) AS FLOAT)) 
       FROM Checkouts ch3 
       WHERE ch3.Status = 'Возвращено' 
       GROUP BY ch3.ReaderID)
ORDER BY ReturnedBooks DESC;

-- 3
SELECT DISTINCT
    a.FirstName,
    a.LastName
FROM Authors a
WHERE a.AuthorID IN (
    SELECT b.AuthorID
    FROM Books b
    JOIN Checkouts ch ON b.BookID = ch.BookID
    WHERE ch.Status = 'Активно'
);

-- 3
SELECT 
    r.FirstName,
    r.LastName,
    c.CategoryName,
    ch.CheckoutDate
FROM Readers r
JOIN Checkouts ch ON r.ReaderID = ch.ReaderID
JOIN Books b ON ch.BookID = b.BookID
JOIN Categories c ON b.CategoryID = c.CategoryID
WHERE ch.CheckoutDate > (
    SELECT AVG(ch2.CheckoutDate)
    FROM Checkouts ch2
    JOIN Books b2 ON ch2.BookID = b2.BookID
    WHERE b2.CategoryID = c.CategoryID
);

-- 4
SELECT DISTINCT
    r.FirstName,
    r.LastName,
    r.Email
FROM Readers r
WHERE EXISTS (
    SELECT 1
    FROM Checkouts ch
    JOIN Books b ON ch.BookID = b.BookID
    JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE ch.ReaderID = r.ReaderID 
    AND c.CategoryName = 'Художественная литература'
);

-- 1
DECLARE @ReaderID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @CheckoutCount INT;

DECLARE reader_cursor CURSOR FOR
SELECT 
    r.ReaderID,
    r.FirstName, 
    r.LastName,
    COUNT(ch.CheckoutID) AS CheckoutCount
FROM Readers r
LEFT JOIN Checkouts ch ON r.ReaderID = ch.ReaderID
WHERE ch.Status = 'Возвращено'
GROUP BY r.ReaderID, r.FirstName, r.LastName
ORDER BY r.LastName;

OPEN reader_cursor;

FETCH NEXT FROM reader_cursor INTO @ReaderID, @FirstName, @LastName, @CheckoutCount;

PRINT 'ОТЧЁТ ПО ВЫДАЧАМ ЧИТАТЕЛЕЙ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @CheckoutCount = 0
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ReaderID AS VARCHAR) + ') - Нет возвращённых книг';
    ELSE
        PRINT @LastName + ' ' + @FirstName + ' (ID: ' + CAST(@ReaderID AS VARCHAR) + 
              ') - Возвращено книг: ' + CAST(@CheckoutCount AS VARCHAR);

    FETCH NEXT FROM reader_cursor INTO @ReaderID, @FirstName, @LastName, @CheckoutCount;
END;

CLOSE reader_cursor;
DEALLOCATE reader_cursor;

-- 2
DECLARE @CategoryID INT, @CategoryName NVARCHAR(100);
DECLARE @RdFirstName NVARCHAR(50), @RdLastName NVARCHAR(50), @RdEmail NVARCHAR(100);

DECLARE category_cursor CURSOR FOR
SELECT CategoryID, CategoryName
FROM Categories
ORDER BY CategoryName;

OPEN category_cursor;
FETCH NEXT FROM category_cursor INTO @CategoryID, @CategoryName;

PRINT 'ЧИТАТЕЛИ ПО КАТЕГОРИЯМ КНИГ';
PRINT '=============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'КАТЕГОРИЯ: ' + @CategoryName;
    PRINT '----------------------------------------';

    DECLARE reader_category_cursor CURSOR LOCAL FOR
    SELECT r.FirstName, r.LastName, r.Email
    FROM Readers r
    JOIN Checkouts ch ON r.ReaderID = ch.ReaderID
    JOIN Books b ON ch.BookID = b.BookID
    WHERE b.CategoryID = @CategoryID AND ch.Status = 'Возвращено'
    ORDER BY r.LastName;

    OPEN reader_category_cursor;
    FETCH NEXT FROM reader_category_cursor INTO @RdFirstName, @RdLastName, @RdEmail;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет читателей';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ' + @RdLastName + ' ' + @RdFirstName + ' - ' + ISNULL(@RdEmail, 'Нет email');
        FETCH NEXT FROM reader_category_cursor INTO @RdFirstName, @RdLastName, @RdEmail;
    END;

    CLOSE reader_category_cursor;
    DEALLOCATE reader_category_cursor;

    FETCH NEXT FROM category_cursor INTO @CategoryID, @CategoryName;
END;

CLOSE category_cursor;
DEALLOCATE category_cursor;

-- 3
DECLARE @CheckoutID INT, @CheckoutDate DATE;

DECLARE checkout_cursor CURSOR FOR
SELECT CheckoutID, CheckoutDate
FROM Checkouts
WHERE Status = 'Активно' AND CheckoutDate <= DATEADD(DAY, -30, GETDATE());

OPEN checkout_cursor;
FETCH NEXT FROM checkout_cursor INTO @CheckoutID, @CheckoutDate;

PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОСРОЧЕННЫХ ВЫДАЧ';
PRINT '=====================================';

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Checkouts
    SET Status = 'Просрочено'
    WHERE CheckoutID = @CheckoutID;

    PRINT 'Выдача ID ' + CAST(@CheckoutID AS VARCHAR) + ' - статус изменён на "Просрочено"';

    FETCH NEXT FROM checkout_cursor INTO @CheckoutID, @CheckoutDate;
END;

CLOSE checkout_cursor;
DEALLOCATE checkout_cursor;

PRINT 'Обновление завершено.';

-- 5
CREATE INDEX IX_Readers_Phone ON Readers(Phone);
CREATE INDEX IX_Books_AuthorID ON Books(AuthorID);
CREATE INDEX IX_Checkouts_ReaderID ON Checkouts(ReaderID);
CREATE INDEX IX_Checkouts_BookID ON Checkouts(BookID);
CREATE INDEX IX_Checkouts_CheckoutDate ON Checkouts(CheckoutDate);

-- 6
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DECLARE @Count1 INT = 0;
DECLARE checkout_cursor_perf CURSOR FOR SELECT CheckoutID FROM Checkouts WHERE Status = 'Активно';
OPEN checkout_cursor_perf;
FETCH NEXT FROM checkout_cursor_perf INTO @CheckoutID;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Count1 = @Count1 + 1;
    FETCH NEXT FROM checkout_cursor_perf INTO @CheckoutID;
END;
CLOSE checkout_cursor_perf;
DEALLOCATE checkout_cursor_perf;

PRINT 'Курсор - количество активных выдач: ' + CAST(@Count1 AS VARCHAR);

DECLARE @Count2 INT;
SELECT @Count2 = COUNT(*) FROM Checkouts WHERE Status = 'Активно';
PRINT 'Множественный запрос - количество активных выдач: ' + CAST(@Count2 AS VARCHAR);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;