/* Purpose: Applying Data Integrity to the Table Objects in the database AMLibrary
Script Date: June 11, 2022
Developed by: Jinyu JIAO
*/

use AMLibrary
;
go

/* create Table 1. Member table */
-- Foreign key constraints
/* 1) Between Membership.Member and Membership.Adult */
alter table Membership.Member WITH NOCHECK
	add constraint fk_Member_Adult foreign key (Adult_No) references Membership.Adult (Adult_No)
;
go


/* 2) Between Membership.Member and Membership.Juvenile 
alter table Membership.Member
	add constraint fk_Member_Juvenile foreign key (Juvenile_No) references Membership.Juvenile (Juvenile_No)
;
go
*/


/* create Table 2. Adult table */ 
-- Set province value to be QC as default
alter table Membership.Adult 
	add constraint df_State_Adult default ('QC') for State 
;
go

-- Check phone number area code is 514 or 438
alter table Membership.Adult
	add constraint df_PhoneNo_Adult check (LEFT(Phone_no, 3) in ('438', '514'))
;
GO


/* create Table 3. Juvenile table */
-- Foreign key constraints
/* Between Membership.Juvenile AND Membership.Member */
alter table Membership.Juvenile WITH NOCHECK
	add constraint fk_Juvenile_Member foreign key (Parent_Mem_No) references Membership.Member (Member_No)
;
go


-- Check constraint 
-- 1. check that BirthDate is less than 18 years old
alter table Membership.Juvenile
	add constraint ck_BirthDate_Juvenile check 
	(
		(year(CURRENT_TIMESTAMP)-year(BirthDate)) <= 18
		--AND
		--(Month(CURRENT_TIMESTAMP)-Month(BirthDate)) <= 0
		--AND
		--( DAY(CURRENT_TIMESTAMP)-DAY(BirthDate)) <0
	)
;
go

/* create Table 4. Item table */
-- Foreign key constraints

/* 1) Between Books.Item and Books.Publisher*/
alter table Books.Item
	add constraint fk_Item_Publisher foreign key (Publisher_No) references Books.Publisher (Publisher_No)
;
go

/* 3) Between Books.Item and Books.Copy
alter table Books.Item
	add constraint fk_Item_Copy foreign key (Copy_ID) references Books.Copy (Copy_ID)
;
go
*/

/* 2) Between Books.Item and Books.Title*/
alter table Books.Item
	add constraint fk_Item_Title foreign key (Title_No) references Books.Title (Title_No)
;
go

/* set the Copy_ID to be unique in the Books.Item table 
alter table Books.Item
	add constraint uq_Copy_ID unique (Copy_ID)
;
go
*/


/* create Table 5. Author table */
-- No extra constraints (only one primary key)

/* create Table 6. Publisher table */
-- No extra constraints (only one primary key)

/* create Table 7. Copy table */
-- No extra constraints (only one primary key)
-- Foreign key constraints
/* 1) Between Books.Copy and Books.Item*/
alter table Books.Copy
	add constraint fk_Copy_Item foreign key (ISBN) references Books.Item (ISBN)
;
go



/* create Table 8. Title table */
-- Foreign key constraints
/* 1) Between Books.Title and Books.Category*/
alter table Books.Title
	add constraint fk_Title_Category foreign key (Category_No) references Books.Category (Category_No)
;
go

/* 2) Between Books.Title and Books.Synopses*/
alter table Books.Title
	add constraint fk_Title_Synopses foreign key (Synopses_No) references Books.Synopses (Synopses_No)
;
go

/* 3) Between Books.Title and Books.Author*/
alter table Books.Title
	add constraint fk_Title_Author foreign key (Author_No) references Books.Author (Author_No)
;
go


/* create Table 9. Category table */
-- No extra constraints (only one primary key)

/* create Table 10. Synopses table */
-- No extra constraints (only one primary key)

/* create Table 11. Loan table */
-- Foreign key constraints
/* 1) Between Transactions.Loan and Transactions.Librarian  */
alter table Transactions.Loan
	add constraint fk_Loan_Librarian foreign key (Lib_No) references Transactions.Librarian (Lib_No)
;
go

/* 2) Between Transactions.Loan and Membership.Member*/
alter table Transactions.Loan WITH NOCHECK
	add constraint fk_Loan_Member foreign key (Member_No) references Membership.Member (Member_No)
;
go

/* 3) Between Transactions.Loan and Books.Copy 
alter table Transactions.Loan WITH NOCHECK
	add constraint fk_Loan_Copy foreign key (ISBN_Copy_NO) references Books.Copy (ISBN_Copy_No)
;
go
*/ 


-- Check constraint 
--1) check the Due_Date >= Borrow_Time
alter table Transactions.Loan
	add constraint ck_DueDate_Loan check (Due_Date >= CONVERT(DATE, Borrow_Time))
;
go


--2) check the return_Date >= Borrow_Time
alter table Transactions.Loan
	add constraint ck_ReturnDate_Loan check (return_Date >= Borrow_Time)
;
go

/* create Table 12. Reservation table */
-- Foreign key constraints
/* 1) Between Transactions.Reservation and Membership.Member*/
alter table Transactions.Reservation WITH NOCHECK
	add constraint fk_Reservation_Member foreign key (Member_No) references Membership.Member (Member_No)
;
go

/* 2) Between Transactions.Reservation and Books.Copy*/
alter table Transactions.Reservation WITH NOCHECK
	add constraint fk_Reservation_Copy foreign key (ISBN_Copy_No) references Books.Copy (ISBN_Copy_No)
;
go


/* create Table 13. Librarian table */
-- No extra constraints (only one primary key)
