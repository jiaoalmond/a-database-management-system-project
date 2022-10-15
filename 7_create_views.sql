/* Purpose: Creating view objects in the database AMLibrary
Script Date: June 09, 2022
*/


use AMLibrary
;
go

/* 1. Create a mailing list of library members that includes the members' full names and complete address info. */
if OBJECT_ID('Membership.MailingListView', 'V') is not null
	drop view Membership.MailingListView
;
go

create view Membership.MailingListView
as
		select 
		CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
		CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address'
		from Membership.Member as MM
			LEFT JOIN Membership.Adult as MA
			ON MM.Adult_No=MA.Adult_No
		WHERE MA.Street IS NOT NULL

		UNION

		SELECT B.[Juvenile Full Name],A.[Complete address] 
		FROM 
			(	SELECT MM.Member_No,
				CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address'
				FROM Membership.Member as MM
				left JOIN Membership.Adult AS MA
					ON MM.Adult_No=MA.Adult_No
			) AS A
			INNER JOIN 
			(
				select 
				CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Juvenile Full Name',
				MJ.Juvenile_No, MJ.Parent_Mem_No
				from Membership.Member as MM
					INNER JOIN Membership.Juvenile AS MJ
					ON MM.Juvenile_No=MJ.Juvenile_No 
					left JOIN Membership.Adult AS MA
					ON MM.Adult_No=MA.Adult_No
			) AS B
			ON A.Member_No=B.Parent_Mem_No

;
go

select *
from Membership.MailingListView
;
go


/* 2. Write and execute a query on the title, item, and copy tables that returns the isbn, copy_no, on_loan, title, translation, and cover, and values for rows in the copy table with an ISBN of 1 (one), 500 (five hundred), or 1000 (thousand). Order the result by ISBN column. 

	The standard ISBN format is 17 or 19 chars, we took 17 format here, and adjust the question to ISBN contains 1, 500 or 1000.
*/

SELECT DISTINCT BI.ISBN, BC.COPY_NO, BC.ON_LOAN, TITLE, BI.TRANSLATION, BI.COVER
FROM Books.Item AS BI
	INNER JOIN Books.Copy AS BC
	ON BI.ISBN=BC.ISBN
	INNER JOIN Books.TITLE AS BT
	ON BI.TITLE_NO=BT.TITLE_NO
WHERE BI.ISBN LIKE ('%1%') OR BI.ISBN LIKE ('%500%') OR BI.ISBN LIKE '%1000%'
ORDER BY ISBN 

;
GO


/* 3. Write and execute a query to retrieve the member’s full name and member_no from the member table and the isbn and log_date values from the reservation table for members 250, 341, 1675. Order the results by member_no. You should show information for these members, even if they have no books or reserve.
	Our Member_No data type is varchar, like M0001, and current database only has 20 membership info. So we select member M0005, M0012, M0020 instead.
*/

SELECT MM.Member_No, 
		CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
		SUBSTRING(TR.ISBN_COPY_NO,1,17) AS 'ISBN', TR.Log_date
FROM Membership.Member AS MM
	LEFT JOIN Transactions.Reservation AS TR
	ON MM.Member_No=TR.Member_No
WHERE MM.Member_No IN ('M0005', 'M0012', 'M0020')
ORDER BY MM.Member_No

;
GO


/* 4. Create a view and save it as adultwideView that queries the member and adult tables. Lists the name & address for all adults.*/
if OBJECT_ID('Membership.adultwideView', 'V') is not null
	drop view Membership.adultwideView
;
go

create view Membership.adultwideView
as
	select 
	CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Full Name',
	CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address'
	from Membership.Member as MM
		INNER JOIN Membership.Adult as MA
		ON MM.Adult_No=MA.Adult_No
;
go

select *
from Membership.adultwideView
;
go


/* 5. Create a view and save it as ChildwideView that queries the member, adult, and juvenile tables. Lists the name & address for the juveniles.*/
if OBJECT_ID('Membership.ChildwideView', 'V') is not null
	drop view Membership.ChildwideView
;
go

create view Membership.ChildwideView
as
	SELECT B.[Juvenile Full Name],A.[Complete address] 
	FROM 
		(	SELECT MM.Member_No,
			CONCAT_WS(' ', MA.Street, coalesce(MA.City,' '), MA.State, MA.Zip)AS 'Complete address'
			FROM Membership.Member as MM
			left JOIN Membership.Adult AS MA
				ON MM.Adult_No=MA.Adult_No
		) AS A
		INNER JOIN 
		(
			select 
			CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Juvenile Full Name',
			MJ.Juvenile_No, MJ.Parent_Mem_No
			from Membership.Member as MM
				INNER JOIN Membership.Juvenile AS MJ
				ON MM.Juvenile_No=MJ.Juvenile_No 
				left JOIN Membership.Adult AS MA
				ON MM.Adult_No=MA.Adult_No
		) AS B
		ON A.Member_No=B.Parent_Mem_No

;
go


select *
from Membership.ChildwideView
;
go


/* 6. Create a view and save it as and CopywideView that queries the copy, title and item tables. Lists complete information about each copy.*/
if OBJECT_ID('Books.CopywideView', 'V') is not null
	drop view Books.CopywideView
;
go

create view Books.CopywideView
as
	SELECT DISTINCT BC.ISBN_Copy_No, BT.Title , 
	CONCAT_WS(' ', BA.AUTHORFN, coalesce(BA.AUTHORMI, ' '), BA.AUTHORLN) AS 'Author Full Name',
	BP.PUBLISHER_NAME, BP.PUBLISHER_YEAR,
	BC.COPY_NO, BI.TRANSLATION, BI.COVER, BC.ON_LOAN,  BC.LOANABLE,
	BCA.CATEGORY, BS.Synopses
	FROM Books.Item AS BI
		INNER JOIN Books.Copy AS BC
		ON BI.ISBN=BC.ISBN
		INNER JOIN Books.TITLE AS BT
		ON BI.TITLE_NO=BT.TITLE_NO
		INNER JOIN Books.Author AS BA
		ON BT.Author_No=BA.Author_No
		INNER JOIN Books.Publisher AS BP
		ON BI.Publisher_No=BP.Publisher_No
		INNER JOIN Books.Category AS BCA
		ON BT.Category_No=BCA.Category_NO
		INNER JOIN Books.Synopses AS BS
		ON BT.Synopses_No=BS.Synopses_No
		
;
GO

select *
from Books.CopywideView
;
go

/* 7. Create a view and save it as LoanableView that queries CopywideView (3-table join). Lists complete information about each copy marked as loanable (loanable = 'Y').*/
if OBJECT_ID('Books.LoanableView', 'V') is not null
	drop view Books.LoanableView
;
go

create view Books.LoanableView
as
	SELECT DISTINCT BC.ISBN_Copy_No, BT.Title ,BC.COPY_NO, BI.TRANSLATION, BI.COVER, BC.ON_LOAN,  BC.LOANABLE
	FROM Books.Item AS BI
		INNER JOIN Books.Copy AS BC
		ON BI.ISBN=BC.ISBN
		INNER JOIN Books.TITLE AS BT
		ON BI.TITLE_NO=BT.TITLE_NO
	WHERE BC.LOANABLE='N'

;
GO

select *
from Books.LoanableView
;
go


/* 8. Create a view and save it as OnshelfView that queries CopywideView (3-table join). Lists complete information about each copy that is not currently on loan (on_loan ='N').*/
if OBJECT_ID('Books.OnshelfView', 'V') is not null
	drop view Books.OnshelfView
;
go

create view Books.OnshelfView
as
	SELECT DISTINCT BC.ISBN_Copy_No, BT.Title ,BC.COPY_NO, BI.TRANSLATION, BI.COVER, BC.LOANABLE,BC.ON_LOAN
	FROM Books.Item AS BI
		INNER JOIN Books.Copy AS BC
		ON BI.ISBN=BC.ISBN
		INNER JOIN Books.TITLE AS BT
		ON BI.TITLE_NO=BT.TITLE_NO
	WHERE BC.ON_LOAN='N'

;
GO

select *
from Books.OnshelfView
;
go


/* 9. Create a view and save it as OnloanView that queries the loan, title, and member tables. Lists the member, title, and loan information of a copy that is currently on loan.*/
if OBJECT_ID('Transactions.OnloanView', 'V') is not null
	drop view Transactions.OnloanView
;
go

create view Transactions.OnloanView
as
	SELECT TL.Member_No, 
	CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
	BT.Title AS 'Book Title', TL.Borrow_Time, TL.Due_Date, TL.Return_Date, TL.Lib_No, BC.On_Loan
	FROM Transactions.Loan AS TL
		INNER JOIN Books.Copy AS BC
		ON TL.ISBN_COPY_NO=BC.ISBN_Copy_No
		INNER JOIN Books.Item AS BI
		ON BC.ISBN=BI.ISBN
		INNER JOIN Books.Title AS BT
		ON BI.Title_No=BT.Title_No
		INNER JOIN Membership.Member AS MM
		ON MM.Member_No=TL.Member_No
	WHERE TL.Return_Date is NULL

;
GO

select *
from Transactions.OnloanView
order by Borrow_time
;
go


/* 10. Create a view and save it as OverdueView that queries OnloanView (3-table join.) Lists the member, title, and loan information of a copy on loan that is overdue (due_date < current date).*/
if OBJECT_ID('Transactions.OverdueView', 'V') is not null
	drop view Transactions.OverdueView
;
go

create view Transactions.OverdueView
as
	SELECT TL.Member_No, 
	CONCAT_WS(' ', MM.MemFN, coalesce(MM.[MemMI], ' '), MM.[MemLN]) AS 'Member Full Name',
	BT.Title AS 'Book Title', TL.Borrow_Time, TL.Due_Date, TL.Return_Date, TL.Lib_No
	FROM Transactions.Loan AS TL
		INNER JOIN Books.Copy AS BC
		ON TL.ISBN_COPY_NO=BC.ISBN_Copy_No
		INNER JOIN Books.Item AS BI
		ON BC.ISBN=BI.ISBN
		INNER JOIN Books.Title AS BT
		ON BI.Title_No=BT.Title_No
		INNER JOIN Membership.Member AS MM
		ON MM.Member_No=TL.Member_No
	WHERE TL.Due_Date< TL.Return_Date
;
GO


select *
from Transactions.OverdueView
order by Borrow_time
;
go
