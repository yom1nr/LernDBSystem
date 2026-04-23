/*
Script file :createTableBank.sql
for Oracle

This script contains statements to create tables in Lab3,Lab8

*/

create table branch
(
branch_name char(9)      not null,
branch_city varchar(20) not null,
asset       float       null,
CONSTRAINT branch_pk PRIMARY KEY (branch_name)  
)
;

create table account
(
account_number int  not null,
branch_name char(9)   not null,
balance     float   not null,
CONSTRAINT account_pk PRIMARY KEY (account_number)  ,
CONSTRAINT account_fk FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
)
;

create table loan
(
loan_number int  not null,
branch_name char(9)   not null,
amount     float   not null,
CONSTRAINT loan_pk PRIMARY KEY (loan_number)  ,
CONSTRAINT loan_fk FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
)
;

create table customer
(
customer_name  char(9)  not null,
customer_street varchar(20)   not null,
customer_city    varchar(20)   not null,
CONSTRAINT customer_pk PRIMARY KEY (customer_name) 
)
;

create table depositor
(
customer_name  char(9)  not null,
account_number int  not null,
CONSTRAINT depositor_pk PRIMARY KEY (customer_name ,account_number)  ,
CONSTRAINT depositor_fk1 FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
CONSTRAINT depositor_fk2 FOREIGN KEY (account_number) REFERENCES account(account_number)
)
;

create table borrower
(
customer_name  char(9)  not null,
loan_number int  not null,
CONSTRAINT borrower_pk PRIMARY KEY (customer_name ,loan_number)  ,
CONSTRAINT borrower_fk1 FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
CONSTRAINT borrower_fk2 FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
)
;