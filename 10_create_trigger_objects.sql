/* Purpose: Creating User-Defined Triggers in the database AMLibrary
Script Date: June 21, 2022
Developed by: Jinyu JIAO
*/

use AMLibrary
;
go

/* Reserving Books */
/* 1. create a trigger, Books.ReservingBooksTR, that checks the copy table modified On_Loan column value. This trigger ensures that during the updating an existing copy, if the modified On_Loan value is 'N' and Loanable value is 'Y', and the item was listed on the reservation table, then will print message to notify the librarian 

create trigger Books.ReservingBooksTR
on Books.Copy
for update
as
	begin
		declare @ModifiedOn_Loan as char(1)
		select
			@ModifiedOn_Loan = ModifiedOn_Loan
		from inserted
		-- making decision (comparing the Modified Date with the current Date)
		if (@ModifiedOn_Loan='Y')
			begin
				-- set the modified date to the current date 
				update Books.Copy
				set ModifiedOn_Loan = 'Y'
				print '***** Member reserved this book *****'
			end
	end
;
go

--		select*
		from Transactions.Reservation AS TR
		INNER JOIN Books.Copy AS BS
		ON TR.ISBN_Copy_No=BS.ISBN_Copy_No

		--if(On_Loan='')




SELECT Member_No, COUNT(*) AS 'Reserved Book'
FROM Transactions.Reservation
GROUP BY Member_No
;
go

create trigger Transactions.MaxReserveTR
on Transactions.reservation 
for update
	begin
		declare @Notification varchar(255);
		SET @Notification =
			CONCAT('This member: ', Member_no, ' reaches the maximum books allow to reserve');

		IF
			(
			SELECT COUNT(*) AS 'Reserved Book'
			FROM Transactions.Reservation
			GROUP BY Member_No
			)
	end
;
go
*/