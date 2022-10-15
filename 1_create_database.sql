/* Purpose: Creating the database AMLibrary
Script Date: June 08, 2022
Developed by: Jinyu JIAO
*/

/* Add a statement that specifies the script runs in the context of the master database */
use master
;
go 

-- create database AMLibrary
create database AMLibrary
on primary
(
 name ='AMLibrary',
 size=12MB,
 filegrowth= 8MB,
 maxsize =500MB,
 filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AMLibrary.mdf'

)

-- transaction log file
log on 
(
	name='AMLibrary_log',
	size=3MB,
	filegrowth= 10%,
	maxsize =25MB, 
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AMLibrary_log.ldf'
)
;
go

--check the database AMLibrary
execute sp_helpdb AMLibrary
;
go

use AMLibrary
;
go

select 
	USER_NAME() as 'User Name',
	DB_NAME() as 'Database Name'
;
go