/* Purpose: Inserting data into table objects in the database AMLibrary
Script Date: June 12, 2022
Developed by: Jinyu JIAO
*/

use AMLibrary
;
go



/*
alter table Membership.Member
	alter column Adult_no int null
;
go
*/


/* 1. Adult table */
insert into Membership.Adult(Adult_No, Street, City, Zip, Phone_no, Expr_date, Mem_Email)
values
('A001','2195 René-Lévesque Blvd','Montreal','H3B 4W8','5145832359','2023/03/21',NULL),
('A002','2331 Scarth Street','Montreal','S4P 3Y2','5144885262','2023/04/30','kristin200891@cudimex.com'),
('A004','2617 Ste. Catherine Ouest','Montreal','H3A 4G4','5144484221','2023/04/30',NULL),
('A005','1511 Ste. Catherine Ouest','Montreal','H3C 3X6','5145832359','2023/05/1','dablgg4@boosterclubs.store'),
('A006','1511 Ste. Catherine Ouest','Montreal','H3C 3X6','5145832359','2023/05/30','frysters03@mamasuna.com'),
('A008','1909 Scarth Street','Montreal','S4P 3Y2','5144831097','2023/06/01','ku9ku@mymailcr.com'),
('A011','954 rue Levy','Montreal','H3C 5K4','5149159542','2023/06/30','galitovskayagaly@masjoco.com'),
('A012','684 rue Levy','Montreal','H3C 5K4','5149704108','2023/06/30','qwert2405@alvinneo.com'),
('A013','2347 Duke Street','Montreal','H3C 5K4','5142077431','2023/07/02','sergiofvc@superhostformula.com'),
('A014','3616 rue Ontario Ouest','Montreal','H2X 1Y8','5148450006','2022/07/05','gijmfjb@lamiproi.com'),
('A015','1436 Sherbrooke Ouest','Montreal','H4A 1H3','5145138060','2022/07/29','mlbatteo@mymailcr.com'),
('A016','2088 Papineau Avenue','Montreal','H2K 4J5','5142961335','2023/08/03','lagarathan@gasss.net'),
('A017','3255 chemin Hudson','Montreal','H4J 1M9','5142687705','2023/12/30','ap003@devfiltr.com'),
('A018','1519 rue Ontario Ouest','Montreal','H2X 1Y8','5142848226','2023/06/01','triumfmebel@riniiya.com'),
('A019','529 rue Levy','Montreal','H3C 5K4','5147060556','2023/05/1','dablgg4@boosterclubs.store')
;
go

/* 2. Member table */
insert into Membership.Member(Member_No, MemFN, MemMI, MemLN, Juvenile_No, Adult_No)
values
('M0001','Andrew','J.','Fuller', null,'A001'),
('M0002','Nancy','D.','Davolio',null,'A002'),
('M0003','Hayden',null,'Davolio','J001',NULL),
('M0004','Janet','','Leverling',null,'A004'),
('M0005','Margaret','','Peacock',null,'A005'),
('M0006','Steven','','Peacock',NULL,'A006'),
('M0007','Odell','J.','Peacock','J002',NULL),
('M0008','Michael','','Suyama',null,'A008'),
('M0009','Jewel','','Suyama','J003',NULL),
('M0010','Kristen','S.','Suyama','J004',NULL),
('M0011','Robert','K.','King',null,'A011'),
('M0012','Laura','','Callahan',null,'A012'),
('M0013','Anne','','Dodsworth',null,'A013'),
('M0014','Lennie','','Kit',null,'A014'),
('M0015','Ricki','M.','Dale',null,'A015'),
('M0016','Hennie','','Reynolds', null,'A016'),
('M0017','Andrina ','','Butler',null,'A017'),
('M0018','Melissa','','Marshall',null,'A018'),
('M0019','Liam ','','Ford',null,'A019'),
('M0020','Jason','','Ford','J005',NULL)
;
go

/* 3. Juvenile table */
INSERT INTO Membership.Juvenile (Juvenile_No, BirthDate, Parent_Mem_No)
VALUES
('J001','2006/05/05','M0002'),
('J002','2008/03/25','M0005'),
('J003','2007/09/08','M0008'),
('J004','2012/01/12','M0008'),
('J005','2015/11/16','M0019')
;
GO

/* 4. Publisher table */
INSERT INTO Books.Publisher (Publisher_No, Publisher_Name, Publisher_Year)
VALUES
('P001', 'Harper & Brothers (US)', '1938'),
('P002', 'Collins', '1934'),
('P003', 'New Amsterdam Books', '1978'),
('P004', 'William Morrow', '1938'),
('P005', 'Charles Scribner''s Sons', '1925'),
('P006', 'Scholastic, Inc.', '2017'),
('P007', 'George Allen & Unwin(UK)', '1937'),
('P008', 'George M. Hill Company', '1900'),
('P009', 'Smith, Elder & Co. of London', '1847'),
('P010', 'Foreign Languages Press', '1791')
;
GO




/* 5. Category table */
INSERT INTO Books.Category (Category_No, Category)
VALUES
('AD','Adventure'),
('AU','Autobiographical'),
('AV','Avant-garde Novel'),
('CH','Children''s'),
('FA','Fantasy'),
('HF','Historical Fiction'),
('HR','Horror'),
('RM','Romance'),
('SF','Science Fiction'),
('TH','Thriller')
;
GO

/* 6. Synopses table */
INSERT INTO Books.Synopses (Synopses_No, Synopses)
VALUES 
('S001','The extraordinary story of a boy called Wart – ignored by everyone except his tutor, Merlyn – who goes on to become King Arthur.'),
('S002','Burmese Days focuses on a handful of Englishmen who meet at the European Club to drink whisky and to alleviate the acute and unspoken loneliness of life in 1920s Burma—where Orwell himself served as an imperial policeman—during the waning days of British imperialism.'),
('S003','The book explores one of Kadare''s recurring themes: how the past affects the present. The novel concerns about the centuries-old tradition of hospitality, blood feuds, and revenge killing in the highlands of north Albania in the 1930s.'),
('S004','This story outlines ancient mythological Gods struggling to be relevant in contemporary America.'),
('S005','Having left the Midwest to work in the bond business in the summer of 1922, Nick settles in West Egg, Long Island, among the nouveau riche epitomized by his next-door neighbor Jay Gatsby. A mysterious man of thirty, Gatsby is the subject of endless fascination to the guests at his lavish all-night parties.'),
('S006','Beginning eighteen years after the conclusion of the final novel, Harry Potter and the Deathly Hallows, Cursed Child shows us how Harry is adapting to his greatest challenge, a struggle more difficult than vanquishing the most evil wizard in the world: parenthood.'),
('S007','Bilbo Baggins is a hobbit who enjoys a comfortable, unambitious life, rarely traveling any farther than his pantry or cellar. But his contentment is disturbed when the wizard Gandalf and a company of dwarves arrive on his doorstep one day to whisk him away on an adventure.'),
('S008','Follow the adventures of young Dorothy Gale and her dog, Toto, as their Kansas house is swept away by a cyclone and they find themselves in a strange land called Oz.'),
('S009','An unconventional love story that broadened the scope of romantic fiction, Jane Eyre is ultimately the tale of one woman’s fight to claim her independence and self-respect in a society that has no place for her.'),
('S010','For more than a century and a half, Dream of the Red Chamber has been recognized in China as the greatest of its novels, a Chinese Romeo-and-Juliet love story and a portrait of one of the world''s great civilizations.')
;
GO

/* 7. Author table */
INSERT INTO Books.AUTHOR (Author_no, AuthorFN,AuthorMI,AuthorLN)
VALUES
('A001', 'Terence', 'H.','White'),
('A002', 'George ', NULL,'Orwell'),
('A003', 'Ismail', NULL,'Kadare'),
('A004', 'Neil', NULL,'Gaiman'),
('A005', 'Francis', 'S.K.','Fitzgerald'),
('A006', 'Joanne', 'K.','Rowling'),
('A007', 'John', 'R.R.','Tolkien'),
('A008', 'Lyman', 'F.','Baum'),
('A009', 'Charlotte', null,'Bronte'),
('A010', 'Xueqin', null,'Cao')
;
GO


/* 8. Title table */
INSERT INTO Books.TITLE (Title_No, TITLE, AUTHOR_NO, CATEGORY_NO, SYNOPSES_NO)
VALUES
('T001', 'The Sword in the Stone', 'A001', 'FA','S001'),
('T002', 'Burmese Days', 'A002', 'HF','S002'),
('T003', 'Broken April', 'A003', 'HF','S003'),
('T004', 'American Gods', 'A004', 'FA','S004'),
('T005', 'The Great Gatsby', 'A005', 'HF','S005'),
('T006', 'Harry Potter and the Cursed Child', 'A006', 'CH','S006'),
('T007', 'The Hobbit, or There and Back Again', 'A007', 'CH','S007'),
('T008', 'The Wonderful Wizard of OZ', 'A008', 'CH','S008'),
('T009', 'Jane Eyre', 'A009', 'FA','S009'),
('T010', 'A Dream of Red Mansions', 'A010', 'FA','S010')
;
GO


/* 9. Item table */
INSERT INTO Books.Item (ISBN, TITLE_NO, PUBLISHER_NO,  TRANSLATION, COVER)
VALUES
('979-4-430-85470-8','T001','P001','English','Soft'),
('979-85376-4-757-7','T002','P002','English','Hard'),
('978-020-905-950-5','T003','P003','English','Soft'),
('979-507-82-4238-7','T004','P004','English','Soft'),
('978-63103-17-47-2','T005','P005','English','Hard'),
('978-1000-6727-8-6','T006','P006','English','Soft'),
('979-69763-578-8-8','T007','P007','English','Hard'),
('979-49041-43-57-4','T008','P008','English','Soft'),
('979-0-500-47840-8','T009','P009','English','Soft'),
('978-855-8872-26-3','T010','P010','Chinese','Soft')

;
GO


/* 10. Copy table */
INSERT INTO Books.Copy ( COPY_NO, ISBN_COPY_NO, ISBN, ON_LOAN, LOANABLE)
VALUES
('1','979-4-430-85470-8-1','979-4-430-85470-8','N','N'),
('1','979-85376-4-757-7-1','979-85376-4-757-7','N','N'),
('2','978-020-905-950-5-1','978-020-905-950-5','Y','Y'),
('2','978-020-905-950-5-2','978-020-905-950-5','N','Y'),
('2','979-507-82-4238-7-1','979-507-82-4238-7','N','Y'),
('2','979-507-82-4238-7-2','979-507-82-4238-7','Y','Y'),
('2','978-63103-17-47-2-1','978-63103-17-47-2','N','N'),
('2','978-63103-17-47-2-2','978-63103-17-47-2','N','Y'),
('3','978-1000-6727-8-6-1','978-1000-6727-8-6','N','Y'),
('3','978-1000-6727-8-6-2','978-1000-6727-8-6','N','Y'),
('3','978-1000-6727-8-6-3','978-1000-6727-8-6','N','Y'),
('1','979-69763-578-8-8-1','979-69763-578-8-8','N','N'),
('2','979-49041-43-57-4-1','979-49041-43-57-4','Y','N'),
('2','979-49041-43-57-4-2','979-49041-43-57-4','N','N'),
('1','979-0-500-47840-8-1','979-0-500-47840-8','N','Y'),
('1','978-855-8872-26-3-1','978-855-8872-26-3','N','Y')
;
GO



/* ********************************************************** */
/* 11. Librarian table */
INSERT INTO Transactions.Librarian (LIB_NO, LIBFN, LIBMI, LIBLN)
VALUES 
('L1','Nyasia ',NULL,'Evans'),
('L2','Julissa','S.',' Walsh'),
('L3','Matteo',null,' Quinn')
;
GO

/* 12. Reservation table */
INSERT INTO Transactions.Reservation (Log_Date, Member_No, ISBN_COPY_NO)
VALUES
('6/18/2022','M0006','978-63103-17-47-2-1'),
('6/18/2022','M0013','979-69763-578-8-8-1'),
('6/20/2022','M0012','979-4-430-85470-8-1'),
('6/20/2022','M0017','979-85376-4-757-7-1')
;
GO

/* 13. Loan table */
INSERT INTO Transactions.Loan (Borrow_Time, Due_date, Return_Date, Member_No, ISBN_COPY_NO, Lib_No)
VALUES 
('20210102 3:40:43 PM','2021/01/09','2021/01/05','M0006','979-4-430-85470-8-1','L1'),
('2/3/2021  3:50:43 PM','2021/02/10','2/10/2021','M0013','979-0-500-47840-8-1','L2'),
('5/15/2021  3:55:12 PM','2021/05/22','5/25/2021','M0005','978-63103-17-47-2-2','L1'),
('5/15/2021  10:20:43 AM','2021/05/22','5/22/2021','M0017','979-507-82-4138-7-2','L3'),
('6/30/2021  11:05:06 AM','2021/07/07','7/5/2021','M0007','978-1000-6727-8-6-2','L3'),
('7/15/2021  12:15:06 PM','2021/07/22','7/23/2021','M0008','978-1000-6727-8-6-3','L1'),
('10/1/2021  3:05:06 PM','2021/10/08','10/8/2021','M0020','979-69763-578-8-8-1','L1'),
('11/14/2021  4:45:06 PM','2021-11-21','11/18/2021','M0010','979-49041-43-57-4-2','L2'),
('11/15/2021  1:27:06 PM','2021-11-22','11/30/2021','M0015','979-0-500-47840-8-1','L2'),
('11/16/2021  9:45:06 AM','2021-11-23','11/22/2021','M0004','978-855-8872-26-3-1','L2'),
('2/21/2022  11:38:06 AM','2022-02-28','2/28/2022','M0007','979-69763-578-8-8-1','L1'),
('3/22/2022  5:02:15 PM','2022-03-29','3/30/2022','M0014','978-63103-17-47-2-1','L3'),
('5/9/2022  1:09:00 PM','2022-05-16','5/16/2022','M0011','978-020-905-950-5-1','L3'),
('5/10/2022  2:47:52 PM','2022-05-17','5/17/2022','M0020','979-49041-43-57-4-2','L1'),
('6/11/2022  3:13:42 PM','2022-06-18','6/18/2022','M0003','979-49041-43-57-4-1','L2'),
('6/18/2022  4:01:03 PM','2022-06-25',null,'M0002','978-020-905-950-5-1','L3'),
('6/18/2022  1:15:16 PM','2022-06-25',null,'M0001','979-507-82-4238-7-2','L1'),
('6/20/2022  2:59:55 PM','2022-06-27',null,'M0009','979-49041-43-57-4-1','L2')
;
GO



/* 14. MemLoanReserve table 
INSERT INTO Transactions.MemLoanReserve (Synopses_No, Synopses)
VALUES 
;
GO
*/

--Delete From Membership.Juvenile
--DBCC CHECKIDENT ('Membership.Juvenile', RESEED, 0)
;

