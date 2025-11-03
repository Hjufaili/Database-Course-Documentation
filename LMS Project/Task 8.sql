---- COUNT:  
SELECT member_id,
COUNT(*) AS TotalBorrowings
FROM Borrowing
GROUP BY member_id;

SELECT c.Category_Name,
COUNT(b.Book_ID) AS TotalBooks
FROM Books b
JOIN BookCategories bc ON b.Book_ID = bc.book_id
JOIN Categories c ON bc.category_id = c.Category_ID
GROUP BY c.Category_Name;

SELECT
brn.Branch_Name,
COUNT(b.borrow_id) AS OverdueCount
FROM Borrowing b
JOIN Branches brn ON b.branch_id = brn.Branch_ID
WHERE b.Status = 'Overdue'
GROUP BY brn.Branch_Name;

 ----SUM:
SELECT
FORMAT(f.payment_date, 'yyyy-MM') AS Month,
SUM(f.paid_amount) AS TotalCollected
FROM Fines f
WHERE f.Status = 'Paid'
GROUP BY FORMAT(f.payment_date, 'yyyy-MM');


SELECT
    m.Member_ID,
    m.Name,
    SUM(f.fine_amount - f.paid_amount) AS PendingFines
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Fines f ON b.borrow_id = f.borrow_id
WHERE f.Status = 'Pending'
GROUP BY m.Member_ID, m.Name;

SELECT
    p.Publisher_ID,
    p.Name AS PublisherName,
    SUM(b.Available_Copies) AS TotalAvailableCopies
FROM Books b
JOIN Publishers p ON b.Publisher_ID = p.Publisher_ID
GROUP BY p.Publisher_ID, p.Name;

----AVG: 
SELECT
    AVG(DATEDIFF(DAY, borrow_date, return_date)) AS AvgDaysBorrowed
FROM Borrowing
WHERE return_date IS NOT NULL;


SELECT
    m.Member_ID,
    m.Name,
    AVG(f.fine_amount) AS AvgFine
FROM Members m
JOIN Borrowing b ON m.member_id = b.member_id
JOIN Fines f ON b.borrow_id = f.borrow_id
GROUP BY m.Member_ID, m.Name;

SELECT
    br.Branch_Name,
    AVG(BorrowCount) AS AvgBooksBorrowed
FROM Branches br
JOIN (
    SELECT branch_id, COUNT(*) AS BorrowCount
    FROM Borrowing
    GROUP BY branch_id
) b ON br.Branch_ID = b.branch_id
GROUP BY br.Branch_Name;


----- MIN/MAX:  
SELECT
    MIN(Publication_Year) AS OldestPublication,
    MAX(Publication_Year) AS NewestPublication
FROM Books;


SELECT TOP 1
    member_id,
    COUNT(*) AS TotalBorrowings
FROM Borrowing
GROUP BY member_id

SELECT TOP 1
    member_id,
    COUNT(*) AS TotalBorrowings
FROM Borrowing
GROUP BY member_id

SELECT MAX(fine_amount) AS HighestFine
FROM Fines;

----Complex Aggregations with HAVING: 

SELECT
category_id,
COUNT(book_id) AS TotalBooks
FROM BookCategories
GROUP BY category_id
HAVING COUNT(book_id) > 5;

SELECT
    member_id,
    COUNT(*) AS BorrowCount
FROM Borrowing
WHERE borrow_date BETWEEN DATEADD(MONTH, -1, GETDATE()) AND GETDATE()
GROUP BY member_id
HAVING COUNT(*) > 3;

SELECT
a.Author_ID,
a.Name,
COUNT(ba.book_id) AS BookCount
FROM Authors a
JOIN BookAuthors ba ON a.Author_ID = ba.author_id
GROUP BY a.Author_ID, a.Name
HAVING COUNT(ba.book_id) > 2;

SELECT
    br.Branch_ID,
    br.Branch_Name,
    SUM(f.fine_amount - f.paid_amount) AS TotalPending
FROM Branches br
JOIN Borrowing b ON br.Branch_ID = b.branch_id
JOIN Fines f ON b.borrow_id = f.borrow_id
WHERE f.Status = 'Pending'
GROUP BY br.Branch_ID, br.Branch_Name
HAVING SUM(f.fine_amount - f.paid_amount) > 100;

----GROUP BY with Multiple Columns: 

SELECT
br.Branch_Name,
FORMAT(b.borrow_date,'yyyy-MM') AS Month,
COUNT(*) AS TotalBorrowings
FROM Borrowing b
JOIN Branches br ON b.branch_id = br.Branch_ID
GROUP BY br.Branch_Name, FORMAT(b.borrow_date,'yyyy-MM');

SELECT
    m.Member_ID,
    m.Name,
    YEAR(f.payment_date) AS Year,
    SUM(f.paid_amount) AS TotalCollected
FROM Members m
JOIN Borrowing b ON m.Member_ID = b.member_id
JOIN Fines f ON b.borrow_id = f.borrow_id
WHERE f.Status = 'Paid'
GROUP BY m.Member_ID, m.Name, YEAR(f.payment_date);

----- Subqueries with Aggregation:  

SELECT book_id, COUNT(*) AS BorrowCount
FROM Borrowing
GROUP BY book_id
HAVING COUNT(*) > (
    SELECT AVG(BorrowCount)
    FROM (
        SELECT COUNT(*) AS BorrowCount
        FROM Borrowing
        GROUP BY book_id
    ) AS sub
);


SELECT member_id, SUM(paid_amount) AS TotalPaid
FROM Borrowing b
JOIN Fines f ON b.borrow_id = f.borrow_id
WHERE f.Status = 'Paid'
GROUP BY member_id
HAVING SUM(paid_amount) > (
    SELECT AVG(paid_amount)
    FROM Fines
    WHERE Status = 'Paid'
	);