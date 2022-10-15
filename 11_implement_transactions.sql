/* Purpose: Implementing Transactionss in the database AMLibrary
Script Date: June 20, 2022
*/

use AMLibrary
;
go

/* ************ -- insert into Transactions.Loan  **************** */
begin try
	begin transaction
		
		insert into Transactions.Loan(Borrow_Time, Due_date, Return_Date, Member_No, ISBN_COPY_NO, Lib_No)
		values ('6/21/2022  4:01:17 PM','2022-07-03',null,'M0012','979-4-430-85470-8-1','L1');	-- insert succeeds
	
		insert into Transactions.Loan(Borrow_Time, Due_date, Return_Date, Member_No, ISBN_COPY_NO, Lib_No)
		-- wrong Return_data, since Return_date < Borrow_time
		values ('6/22/2022  11:15:26 AM','2022-07-04','5/23/2022','M0012','979-0-500-47840-8-1','L1'); -- insert fails

		insert into Membership.Adult(Adult_No, Street, City, Zip, Phone_no, Expr_date, Mem_Email)
		-- wrong phone_no area code, should be 438 or 514
		values('A021','1909 Scarth Street','Montreal','S4P 3Y2','2264831097','2023/06/01',null); -- insert fails

		INSERT INTO Membership.Juvenile (Juvenile_No, BirthDate, Parent_Mem_No)
		-- wrong BirthDate, it should be less than 18 years old
		VALUES('J006','1999/07/08','M0018');-- insert fails


	commit transaction
end try
begin catch
	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'
	rollback transaction
	Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go

SELECT * 
FROM Transactions.Loan
;
GO

/* ************ -- insert into Membership.Adult **************** */
begin try
	begin transaction
		
		insert into Membership.Adult(Adult_No, Street, City, Zip, Phone_no, Expr_date, Mem_Email)
		-- wrong phone_no area code, should be 438 or 514
		values ('A022','2195 René-Lévesque Blvd','Montreal','H3B 4W8','5147986333','2023/06/22',null), -- insert succeed
		('A021','1909 Scarth Street','Montreal','S4P 3Y2','2264831097','2023/06/22',null); -- insert fails


	commit transaction
end try
begin catch
	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'
	rollback transaction
	Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go

SELECT * 
FROM Membership.Adult
;
GO

/* ************ -- insert into Membership.Adult **************** */
begin try
	begin transaction
		
		INSERT INTO Membership.Juvenile (Juvenile_No, BirthDate, Parent_Mem_No)
		-- wrong BirthDate, it should be less than 18 years old
		VALUES('J006','1999/07/08','M0018');-- insert fails

	commit transaction
end try
begin catch
	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'
	rollback transaction
	Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go


SELECT * 
FROM Membership.Juvenile
;
GO
