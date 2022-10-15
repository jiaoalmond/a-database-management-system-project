/* Purpose: creating table objects in the database AMLibrary
Script Date: June 09, 2022
*/

use AMLibrary
;
go


/*
drop database AMLibrary;
GO
*/


/* create Table 1. Member table */
if OBJECT_ID('Membership.Member','U') is not null
	drop table Membership.Member
;
go

CREATE TABLE Membership.Member
(
	Member_No nvarchar(5) PRIMARY KEY  NOT NULL, -- exapmle M0001
	MemFN nvarchar(20) NOT NULL,
	MemMI nvarchar(10) NULL,
	MemLN nvarchar(15) NOT NULL,
	Photo varbinary(max) NULL,
	Adult_No nvarchar(4) NULL, -- example A001
	Juvenile_No nvarchar(4) NULL -- example J001
)
;
GO


/* create Table 2. Adult table */
if OBJECT_ID('Membership.Adult','U') is not null
	drop table Membership.Adult
;
go


CREATE TABLE Membership.Adult
(
	Adult_No nvarchar(4) PRIMARY KEY  NOT NULL,
	Street nvarchar(60) NOT NULL, -- Street Number and Street Name
	City nvarchar(15) NOT NULL,
	State Char(2) NOT NULL, -- Province initial like QC
	Zip nvarchar(7) NOT NULL,
	Phone_no nvarchar(10) NOT NULL,
	Expr_Date	date NOT NULL, -- ID created date + 1 year
	Mem_Email	nvarchar(40) NULL
)
;
GO


/* create Table 3. Juvenile table */
if OBJECT_ID('Membership.Juvenile','U') is not null
	drop table Membership.Juvenile
;
go
CREATE TABLE Membership.Juvenile
(
	Juvenile_No nvarchar(4) NOT NULL,
	BirthDate date NOT NULL,
	Parent_Mem_No nvarchar(5) NOT NULL,-- parents' membership no 
	CONSTRAINT pk_Juvenile primary key clustered
	(
		Juvenile_No ASC ,
		Parent_Mem_No ASC
	)
)
;
GO

/* create Table 4. Item table */
if OBJECT_ID('Books.Item','U') is not null
	drop table Books.Item
;
go

CREATE TABLE Books.Item
(
	ISBN nvarchar(17) PRIMARY KEY NOT NULL,
	Title_No nvarchar(4) NOT NULL,
	Publisher_No nvarchar(4) NOT NULL,
	Translation nvarchar(15),
	Cover char(4) -- Hard or SOFT
)
;
GO

/* create Table 5. Author table */
if OBJECT_ID('Books.Author','U') is not null
	drop table Books.Author
;
go

CREATE TABLE Books.Author
(
	Author_No nvarchar(4) PRIMARY KEY NOT NULL,
	AuthorFN nvarchar(20) NOT NULL,
	AuthorMI nvarchar(10) NULL,
	AuthorLN nvarchar(15) NOT NULL,
)
;
GO

/* create Table 6. Publisher table */
if OBJECT_ID('Books.Publisher','U') is not null
	drop table Books.Publisher
;
go

CREATE TABLE Books.Publisher
(
	Publisher_No nvarchar(4) PRIMARY KEY NOT NULL,
	Publisher_Name nvarchar(40) NOT NULL,
	Publisher_Year char(4) -- Year format 2022
)
;
GO

/* create Table 7. Copy table */
if OBJECT_ID('Books.Copy','U') is not null
	drop table Books.Copy
;
go

CREATE TABLE Books.Copy
(
	ISBN_Copy_No nvarchar(20) PRIMARY KEY  NOT NULL,
	Copy_No TINYINT NOT NULL,
	ISBN nvarchar(17) NOT NULL,
	On_Loan CHAR(1) NOT NULL, -- Y or N
	Loanable CHAR(1) NOT NULL -- Y or N
)
;
GO

/* create Table 8. Title table */
if OBJECT_ID('Books.Title','U') is not null
	drop table Books.Title
;
go
CREATE TABLE Books.Title
(
	Title_No  nvarchar(4) PRIMARY KEY NOT NULL,
	Title nvarchar(40) NOT NULL,
	Author_No nvarchar(4) NOT NULL,
	Category_No nvarchar(2),
	Synopses_No nvarchar(4)
)
;
GO

/* create Table 9. Category table */
if OBJECT_ID('Books.Category','U') is not null
	drop table Books.Category
;
go
CREATE TABLE Books.Category
(
	Category_No nvarchar(2) PRIMARY KEY NOT NULL,
	Category nvarchar(20) NOT NULL
)
;
GO

/* create Table 10. Synopses table */
if OBJECT_ID('Books.Synopses','U') is not null
	drop table Books.Synopses
;
go

CREATE TABLE Books.Synopses
(
	Synopses_No nvarchar(4) PRIMARY KEY NOT NULL,
	Synopses nvarchar(400) NOT NULL
)
;
GO

/* create Table 11. Loan table */
if OBJECT_ID('Transactions.Loan','U') is not null
	drop table Transactions.Loan
;
go

CREATE TABLE Transactions.Loan
(
	Loan_No INT IDENTITY(1000001, 1) PRIMARY KEY NOT NULL,
	Borrow_Time Datetime NOT NULL,
	Due_Date  Date NOT NULL,
	Return_Date  Date NULL,
	Member_No NVARCHAR(5) Not NULL,
	ISBN_Copy_No nvarchar(20) NOT null,
	Lib_No NVARCHAR(2) NULL

)
;
GO

/* create Table 12. Reservation table */
if OBJECT_ID('Transactions.Reservation','U') is not null
	drop table Transactions.Reservation
;
go

CREATE TABLE Transactions.Reservation
(
	Reserve_No INT IDENTITY(1000001, 1) PRIMARY KEY NOT NULL,
	Log_Date date NOT NULL,
	Member_No NVARCHAR(5) Not NULL,
	ISBN_Copy_No nvarchar(20) NOT null
)
;
GO


/* create Table 13. Librarian table */
if OBJECT_ID('Transactions.Librarian','U') is not null
	drop table Transactions.Librarian
;
go

CREATE TABLE Transactions.Librarian
(
	Lib_No NVARCHAR(2) PRIMARY KEY NOT NULL, -- EXAMPLE L1, L2
	LibFN nvarchar(20) NOT NULL,
	LibMI nvarchar(10) NULL,
	LibLN nvarchar(15) NOT NULL
)
;
GO

/* create Table 14. MemLoanReserve table 
if OBJECT_ID('Transactions.MemLoanReserve','U') is not null
	drop table Transactions.MemLoanReserve
;
go

CREATE TABLE Transactions.MemLoanReserve
(
	Member_No NVARCHAR(5) Not NULL,
	Loan_No int,
	Reserve_No int,
	ISBN_Copy_No nvarchar(20) NOT null,
	CONSTRAINT pk_MemLoanReserve PRIMARY KEY  CLUSTERED 
	(	-- composite primary key
		Member_No,
		Loan_No asc,
		Reserve_No asc
	) 
)
;
GO
*/
