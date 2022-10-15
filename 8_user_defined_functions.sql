/* Purpose: User-Defined T-SQL Functions in the database AMLibrary
Script Date: June 20, 2022
*/

use AMLibrary
;
go

/* 1.(How many loans did the library do last year?)
Create a function to return the number of total loans in last year.
*/

if OBJECT_ID('Transactions.getLastYearLoansFn', 'Fn') is not null
	drop function Transactions.getLastYearLoansFn
;
go

create function Transactions.getLastYearLoansFn
(
	-- declare parameter(s)
	@CurrentDate as date
)
returns tinyint
as
	begin
		-- declare the return variable 
		declare @TotalLoans as tinyint
		-- compute the return value
		select @TotalLoans = COUNT (*) 
		from Transactions.Loan AS TL
		where YEAR(TL.Borrow_Time) = (YEAR(@CurrentDate)-1)
		-- return the result value to the function caller
		return @TotalLoans
	end
;
go
-- testing Transactions.getLastYearLoansFn
select Transactions.getLastYearLoansFn('2022/06/08') AS 'Last Year Total Loans'
;
go


/* 2.(What percentage of the membership borrowed at least one book?)
Create a function to return the percentage of the membership borrowed at least one book
*/

if OBJECT_ID('Transactions.percentageMembershipFn', 'Fn') is not null
	drop function Transactions.percentageMembershipFn
;
go

create function Transactions.percentageMembershipFn
(

)
returns decimal(4,2)
as
	begin
		-- declare the return variable 
		declare @Percentage as decimal(4,2)
		-- compute the return value
		select @Percentage = 

		(SELECT CAST(COUNT(DISTINCT TL.Member_No) AS DECIMAL(4,2))
		FROM Transactions.Loan AS TL) -- Member borrowed as least one book
		/
		(SELECT CAST( COUNT(*)AS DECIMAL(4,2))
		FROM Membership.Member) -- total membership number

		return @Percentage
	end
;
go
-- testing Transactions.getLastYearLoansFn
select Transactions.percentageMembershipFn() AS 'Membership Borrowed Percentage '
;
go



/* 3.(What was the greatest number of books borrowed by any one individual?)
Create a function to return the  greatest number of books borrowed by any one individual
*/

if OBJECT_ID('Books.greatestBorrowedBookFn', 'Fn') is not null
	drop function Books.greatestBorrowedBookFn
;
go

create function Books.greatestBorrowedBookFn
(
	
)
returns TINYINT
as
	begin
		-- declare the return variable 
		declare @GreatestBorrowedBook as TINYINT
		-- compute the return value
		SET @GreatestBorrowedBook = 
		(
			SELECT TOP 1 tmp.[Individual Borrowed Times]
			FROM 
				(
					SELECT TL.Member_No, COUNT(TL.Member_No) AS 'Individual Borrowed Times'
					FROM Transactions.Loan AS TL
					GROUP BY TL.Member_No
				) AS tmp
			ORDER BY [Individual Borrowed Times] DESC
		)

		return @GreatestBorrowedBook
	end
;
go

select Books.greatestBorrowedBookFn() AS 'Individual Greatest Borrowed Books'
;
go


/* 4.(What percentage of the books was loaned out at least once last year?)
Create a function to return the percentage of the books was loaned out at least once last year
*/

if OBJECT_ID('Books.percentageBookLoanedFn', 'Fn') is not null
	drop function Books.percentageBookLoanedFn
;
go

create function Books.percentageBookLoanedFn
(
	@CurrentDate as date
)
returns decimal(4,2)
as
	begin
		-- declare the return variable 
		declare @percentageBookLoaned as decimal(4,2)
		-- compute the return value
		SET @percentageBookLoaned = 
		(
			(SELECT CAST (COUNT(DISTINCT TL.ISBN_Copy_No) AS DECIMAL(4,2))
			FROM Transactions.Loan AS TL -- no. of books were loaned at least once
			WHERE YEAR(TL.Borrow_Time) = (YEAR(@CurrentDate) -1)
			) 
			/
			(SELECT CAST (COUNT(*) AS DECIMAL(4,2))
			FROM Books.Copy) -- total of books
		)

		return @percentageBookLoaned
	end
;
go

select (YEAR('2022/06/22')-1) AS 'Last Year',
Books.percentageBookLoanedFn('2022/06/22') AS 'Percentage of Books was Loaned Out Last Year at Least Once'
;
go


/* 5.(What percentage of all loans eventually becomes overdue?)
Create a function to return the percentage of all loans eventually becomes overdue
*/
if OBJECT_ID('Transactions.overduePercentageFn', 'Fn') is not null
	drop function Transactions.overduePercentageFn
;
go

create function Transactions.overduePercentageFn
(
)
returns decimal(4,2)
as
	begin
		-- declare the return variable 
		declare @percentageOverdue as decimal(4,2)
		-- compute the return value
		SET @percentageOverdue = 
		(
			(SELECT CAST (COUNT(*) AS DECIMAL(4,2))
			FROM Transactions.Loan AS TL -- no. of books were loaned at least once
			WHERE TL.Due_Date < TL.Return_Date
			) 
			/
			(SELECT CAST (COUNT(*) AS DECIMAL(4,2))
			FROM Transactions.Loan) -- total number of loans
		)

		return @percentageOverdue
	end
;
go


select 
Transactions.overduePercentageFn() AS 'Overdue Percentage'
;
go

/* 6.(What is the average length of a loan?)
Create a function to return the average length of a loan
*/

if OBJECT_ID('Transactions.averageLoanLengthFn', 'Fn') is not null
	drop function Transactions.averageLoanLengthFn
;
go

create function Transactions.averageLoanLengthFn
(
)
returns decimal(4,2)
as
	begin
		-- declare the return variable 
		declare @averageLength as decimal(4,2)
		-- compute the return value
		SET @averageLength = 
		(
			(SELECT SUM(DATEDIFF(DAY, TL.Borrow_Time, TL.Return_Date))AS 'Total Loan Days' 
			FROM Transactions.Loan AS TL -- total no. of loan days
			) 
			/
			(SELECT CAST (COUNT(*) AS DECIMAL(4,2))
			FROM Transactions.Loan) -- total number of loans
		)

		return @averageLength
	end
;
go

select 
Transactions.averageLoanLengthFn() AS 'Average Loan Length / Days'
;
go

/* 7.(What are the library's peak hours for loans?)
Create a function to return the library's peak hours for loans
*/
if OBJECT_ID('Transactions.peakLoanHoursFn', 'Fn') is not null
	drop function Transactions.peakLoanHoursFn
;
go

create function Transactions.peakLoanHoursFn
(
)
returns int
as
	begin
		-- declare the return variable 
		declare @peakHour as int
		-- compute the return value
		SET @peakHour = 
		(
			select TOP 1 DATENAME(HOUR,TL.Borrow_Time) AS 'Day Hour'
			--, COUNT(*) AS 'Transaction no.'
			from Transactions.Loan as TL
			group by DATENAME(HOUR,TL.Borrow_Time)
			Order by COUNT(*) desc
		)

		return @peakHour
	end
;
go

select 
Transactions.peakLoanHoursFn() AS 'Peak Loan Hour'
;
go
