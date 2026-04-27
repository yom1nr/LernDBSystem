/*
script file :createTableExample.sql
 for Oracle

This script contains statements to insert data into tables in Lab3

*/
insert into branch
values ('SUT', 'Korat', 2000000);
insert into branch
values ('Mall', 'Korat', 1000000);

/*Data for account table*/
insert into account
values (1, 'SUT', 150);
insert into account
values (3, 'Mall', 200);

/*Data for loan table*/
insert into loan
values (101, 'SUT', 2000);
insert into loan
values (102, 'Mall', 5000);

/*Data for customer table*/
insert into customer
values ('Som', 'Mitr-Pab', 'Korat');
insert into customer
values ('Dang', 'Univ', 'Korat');

/*Data for depositor table*/
insert into depositor
values ('Som',1);
insert into depositor
values ('Dang',3);

/*Data for borrower table*/
insert into borrower
values ('Dang',101);
insert into borrower
values ('Dang',102);







