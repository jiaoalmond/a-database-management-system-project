/* Purpose: Creating the schema objects in the database AMLibrary
Script Date: June 08, 2022
*/

use AMLibrary
;
go

/* create schema objects
1. Membership
2. Books
3. Transactions
*/

create schema Membership authorization dbo
;
go

create schema Books authorization dbo
;
go

create schema Transactions authorization dbo
;
go
