/* Purpose: Creating User-Defined Stored Procedures AND union in the database AMLibrary
Script Date: June 20, 2022
*/

use AMLibrary
;
go


/* Reserving Books */
/* 1. If a member wants a book that is out on loan, the book is placed on reserve for them. When the book arrives, a librarian must notify the member who has been waiting the longest. Members can have as many as four books on reserve at one time. 
*/
CREATE procedure Transactions.reservingBooksSP
(
	@ISBN_COPY_NO AS nvarchar(20)
)
as
	begin
		SELECT TR.Log_Date AS 'Reserve Date', TR.Member_No, TR.ISBN_Copy_No
		FROM Transactions.Reservation AS TR
		WHERE TR.ISBN_Copy_No=@ISBN_COPY_NO
		ORDER BY TR.Log_Date ASC
	END

;
GO

/* call (execute) the Transactions.reservingBooksSP */
execute Transactions.reservingBooksSP @ISBN_COPY_NO='978-63103-17-47-2-1'
;
go

BEGIN TRANSACTION

INSERT INTO Transactions.Reservation (Log_Date, Member_No, ISBN_COPY_NO)
VALUES
('6/22/2022','M0002','979-85376-4-757-7-1')
;
execute Transactions.reservingBooksSP @ISBN_COPY_NO='979-85376-4-757-7-1'
;

ROLLBACK

/* 2. Members can have as many as four books on reserve at one time. */
CREATE procedure Membership.reservingLimitsSP
(
	@Member_NO AS nvarchar(5)
)
as
	begin
		SELECT MM.Member_No,
			COUNT(*) AS 'No. of Reserved Books'
		FROM Membership.Member AS MM
			INNER JOIN Transactions.Reservation AS TR
			ON MM.Member_No=TR.Member_No
		WHERE MM.Member_No=@Member_NO
		GROUP BY MM.Member_No
	END

;
GO

/* call (execute) the Transactions.reservingBooksSP */
execute Membership.reservingLimitsSP @Member_NO='M0006'
;
go


/* Enrolling Members*/
/* 1. The library must be able to detect when juvenile members turn 18 and then must automatically convert the juvenile memberships to adult memberships.*/
CREATE procedure Membership.JuvenileBirthCheckSP
as
	begin
			SELECT CASE WHEN dateadd(year, datediff (year, BirthDate, getdate()), BirthDate) > getdate()
					THEN datediff(year, BirthDate, getdate()) - 1
					ELSE datediff(year, BirthDate, getdate())
				END as Age
			FROM Membership.Juvenile
	END

;
GO

/* call (execute) the Membership.JuvenileBirthCheckSP */
execute Membership.JuvenileBirthCheckSP
;
go

/* 2. A librarian must notify the member, a month before membership cards expire. */
CREATE procedure Membership.ExpireLessThanAMonthSP
as
	begin
			SELECT 
					CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
					CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address',
					MA.Expr_Date
			FROM Membership.Member as MM
				INNER JOIN Membership.Adult AS MA
				ON MM.Adult_No=MA.Adult_No
			WHERE DATEDIFF(MONTH, MA.Expr_Date, CURRENT_TIMESTAMP)<'1'
	END

;
GO

/* call (execute) the Membership.JuvenileBirthCheckSP */
execute Membership.ExpireLessThanAMonthSP
;
go



/*Determining Book Availability
1. Librarians must be able to determine how many copies of a book are out on loan at any given time
*/
CREATE procedure Books.getOnloanBookCurrentSP
as
	begin
		select BC.ISBN_Copy_No, BT.Title,BC.On_Loan
		from Books.Copy AS BC
		INNER JOIN Books.Item AS BI
		ON BI.ISBN=BC.ISBN
		INNER JOIN BOOKS.Title AS BT
		ON BT.Title_No = BI.Title_No
		WHERE BC.On_Loan='Y'
	end
;
go

/* call (execute) the Books.getOnloanBookCurrentSP */
execute Books.getOnloanBookCurrentSP 
;
go

/*2. Librarians must be able to determine which books are on reserve.*/
create procedure Books.getOnReserveBookCurrentSP
as
	begin

		select TR.ISBN_Copy_No, BT.Title, TR.Member_No AS 'Reserved by Member'
		from Transactions.Reservation AS TR
		INNER JOIN Books.Copy AS BC
		ON TR.ISBN_Copy_No=BC.ISBN_Copy_No
		INNER JOIN Books.Item AS BI
		ON BI.ISBN=BC.ISBN
		INNER JOIN BOOKS.Title AS BT
		ON BT.Title_No = BI.Title_No
		
	end
;
go

/* call (execute) the Books.getOnReserveBookCurrentSP */
execute Books.getOnReserveBookCurrentSP 
;
go

/*3. Librarians want to be able to access the synopses when members request information about books.*/
CREATE procedure Books.getSynopsesSP
(
	@BookTitle as nvarchar(10)
)
as
	begin

		select BT.Title, BS.Synopses
		FROM Books.Title as BT
		INNER JOIN Books.Synopses AS BS
		ON BT.Synopses_No=BS.Synopses_No
		WHERE BT.Title LIKE '%' +@BookTitle+'%'
	end
;
go

/* call (execute) the Books.getSynopsesSP */
execute Books.getSynopsesSP @BookTitle='god' -- let's say member wants to search books title has god like word
;
go


/* Checking Out Books */
/* 1. If a book is overdue, members have one week before the library sends a notice to them. */
CREATE procedure Transactions.sendOverdueNoticeSP
as
	begin

		SELECT CONCAT('Send notice to' , TL.Member_No) AS 'Notification Sent',
			TL.Member_No,TL.ISBN_Copy_No ,TL.Borrow_Time, TL.Due_Date
		FROM Transactions.Loan AS TL
		WHERE DATEDIFF(DAY, TL.Due_Date, CURRENT_TIMESTAMP) >7
			AND TL.Return_Date IS NULL
	end
;
go

/* call (execute) the Transactions.sendOverdueNoticeSP*/
execute Transactions.sendOverdueNoticeSP 
;
go

/* TEST THE PROCEDURE*/
BEGIN TRANSACTION

INSERT INTO Transactions.Loan(Borrow_Time, Due_date, Return_Date, Member_No, ISBN_COPY_NO, Lib_No)
VALUES
('5/10/2022  2:59:55 PM','2022-05-17',null,'M0005','979-49041-43-57-4-2','L2')
;

execute Transactions.sendOverdueNoticeSP 
;

ROLLBACK
;

/* 2. A screen displays information about the member’s account, such as name, address, phone number, and the card’s expiration date. Ideally, cards that have expired or are about to expire will be highlighted. */
create procedure Membership.getMemberInfoSP
(
	@Member_No nvarchar(5)
)
as
	begin

		SELECT *
		FROM
		(
				(select
					MM.Member_No, 
					CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
					CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address',
					MA.Phone_no, MA.Expr_Date
				from Membership.Member as MM
					LEFT JOIN Membership.Adult as MA
					ON MM.Adult_No=MA.Adult_No
				WHERE MA.Street IS NOT NULL
				)

				UNION

				SELECT MM.Member_No,B.[Member Full Name], A.[Complete address],A.Phone_no, A.Expr_Date
				FROM 
					(	SELECT MM.Member_No, MA.Phone_no, MA.Expr_Date,
						CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address'
						FROM Membership.Member as MM
						left JOIN Membership.Adult AS MA
							ON MM.Adult_No=MA.Adult_No
					) AS A
					INNER JOIN 
					(
						select
						CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
						MJ.Juvenile_No, MJ.Parent_Mem_No
						from Membership.Member as MM
							INNER JOIN Membership.Juvenile AS MJ
							ON MM.Juvenile_No=MJ.Juvenile_No 
							left JOIN Membership.Adult AS MA
							ON MM.Adult_No=MA.Adult_No
					) AS B
					ON A.Member_No=B.Parent_Mem_No
					INNER JOIN
					Membership.Member AS MM
					ON MM.Juvenile_No=B.Juvenile_No
		
		) TMP
		WHERE @Member_No= TMP.Member_No 
				--TMP.Member_No='M0003'
	end
;
go

/* call (execute) the Membership.getMemberInfoSP*/
execute Membership.getMemberInfoSP @Member_No=M0003

;
go

/* 3. The screen also displays information about a member’s outstanding loans, including title, checkout date, and due date. */
create procedure Transactions.getMemberLoanSP
(
	@Member_No nvarchar(5)
)
as
	begin

		SELECT TL.Member_No,TL.ISBN_Copy_No, BT.Title, TL.Borrow_Time AS 'Checkout Date', TL.Due_Date
		FROM Transactions.Loan AS TL
			INNER JOIN Books.Copy AS BC
			ON TL.ISBN_Copy_No=BC.ISBN_Copy_No
			INNER JOIN BOOKS.Item AS BI
			ON BC.ISBN=BI.ISBN 
			INNER JOIN Books.Title AS BT
			ON BI.Title_No=BT.Title_No
		WHERE TL.Return_Date IS NULL 
			AND TL.Due_Date < CURRENT_TIMESTAMP
			AND TL.Member_No =@Member_No
		ORDER BY TL.Due_Date ASC 
	end
;
go



/* call (execute) the Transactions.getMemberInfoSP*/
execute Transactions.getMemberLoanSP @Member_No=M0005

;
go


/* 4. Librarians check out books by running a scanner down the book spines (The ISBN and the copy number are encoded on the spines). The ISBN, title, and the information then appear on the computer screen. If the books are not loanable, a warning message appears. */
create procedure BOOKS.scanBookSP
(
	@ISBN_Copy_No nvarchar(20)
)
as
	begin
		SELECT BC.ISBN, BT.Title, 
				CONCAT_WS(' ', BA.AuthorFN, coalesce(BA.AuthorMI, ' '),BA.AuthorLN) AS 'Author Full Name',
				BC.Loanable
		FROM Books.Copy AS BC
			INNER JOIN Books.Item AS BI
			ON BC.ISBN=BI.ISBN
			INNER JOIN Books.Title AS BT
			ON BT.Title_No=BI.Title_No
			INNER JOIN Books.Author AS BA
			ON BT.Author_No=BA.Author_No
		WHERE BC.ISBN_Copy_No=@ISBN_Copy_No

	end
;
GO

/* call (execute) the BOOKS.scanBookSP*/
execute BOOKS.scanBookSP @ISBN_Copy_No='978-63103-17-47-2-2'
;
go

/*Checking In Books*/
/* 1. When books are returned, librarians check them in by running a scanner down the book spines. The ISBN number, title, and author information then appear on the computer screen, as well as the member number and name and the book’s due date.
*/
create procedure BOOKS.returnScanBookSP
(
	@ISBN_Copy_No nvarchar(20)
)
as
	begin
		SELECT BC.ISBN, BT.Title, 
				CONCAT_WS(' ', BA.AuthorFN, coalesce(BA.AuthorMI, ' '),BA.AuthorLN) AS 'Author Full Name',
				TL.Member_No, 
				CONCAT_WS(' ', MM.MemFN, coalesce(MM.MemMI, ' '),MM.MemLN) AS 'Member Full Name',
				TL.Due_Date
		FROM Books.Copy AS BC
			INNER JOIN Books.Item AS BI
			ON BC.ISBN=BI.ISBN
			INNER JOIN Books.Title AS BT
			ON BT.Title_No=BI.Title_No
			INNER JOIN Books.Author AS BA
			ON BT.Author_No=BA.Author_No
			INNER JOIN Transactions.Loan AS TL
			ON TL.ISBN_Copy_No= BC.ISBN_Copy_No
			INNER JOIN Membership.Member AS MM
			ON MM.Member_No=TL.Member_No
		WHERE BC.ISBN_Copy_No=@ISBN_Copy_No
	end
;
GO
/* call (execute) the BOOKS.scanBookSP*/
execute BOOKS.returnScanBookSP @ISBN_Copy_No='978-63103-17-47-2-2'
;
go

