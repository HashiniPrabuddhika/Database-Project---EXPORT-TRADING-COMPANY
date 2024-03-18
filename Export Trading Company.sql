-- Group 40 - Export Trading Company--

drop database if exists ETC;

CREATE database ETC;

use ETC;

create table SUPPLIER (
	Supplier_ID varchar(10) not null,
    Supplier_Name varchar(15) not null,
    Email varchar(30),
    Contact_NO varchar(10),
    Street varchar(20) not null,
    City varchar(20) not null,
    Province varchar(20) not null,
    
    primary key (Supplier_ID)
);

create table PRODUCT (
	Product_ID varchar(10) not null,
    Supplier_ID varchar(10) not null,
    Product_Name varchar(15) not null,
    Product_Brand varchar(15) not null,
    Unit_Price decimal(4,1) not null,
    Quantity_Available int not null,
    Product_Description varchar(50),
    
    primary key (Product_ID,Product_Name,Product_Brand)
);

create table ORDERS (
	Order_ID varchar(10) not null,
    Product_ID varchar(10) not null,
    SP_ID varchar(10) not null,
    Order_Quantity int not null,
    Added_Date date not null,
    
    primary key (Order_ID)
);

create table SUPPLIER_PAYMENT (
	SP_ID varchar(10) not null,
    Order_ID varchar(10) not null,
    Supplier_ID varchar(10) not null,
    Total_Payment decimal(5,1) not null,
    Payment_Date date not null,
    Payment_Method varchar(15) not null,
    Bank_Name varchar(20) not null,
    Bank_Branch varchar(20) not null,
    Account_No varchar(12) not null,
    
    primary key (SP_ID)
);

create table SHIPMENT (
	Shipment_ID varchar(10) not null,
    Customer_ID varchar(10) not null,
    Ship_Code varchar (10) not null,
    Shipping_Date date,
    Estimate_Delivery date,
    Origin_Location varchar(15) not null,
    Destination varchar(15) not null,
    Shipment_Weight decimal(4,1) not null,
    
    primary key (Shipment_ID)
);

create table SHIP (
	Ship_Code varchar(10) not null,
    SC_Name varchar(20) not null,
    Ship_Name varchar(10) not null,
    Ship_Operator varchar(20) not null,
    Shipping_Route varchar(10) not null,
    Dead_weight decimal(4,1) not null,
    
    primary key (Ship_Code)
);

create table SHIPPING_COMPANY (
	SC_Name varchar(10) not null,
    SC_Street varchar(20),
    SC_Province varchar(20) not null,
    SC_City varchar(20) not null,
    Contact_No varchar(20) not null,
    Coverage_Area varchar(20) not null,
    Freight_Rate decimal(3,1) not null,
    
    primary key (SC_Name)
);

create table EMPLOYEE (
	Employee_ID varchar(10) not null,
    Employee_Name varchar(20) not null,
    Manager_ID varchar(10),
    Birth_Date date not null,
    Employed_Date date not null,
    Job_Title varchar(10),
    Age int not null,
    Married boolean not null,
    Employee_Street varchar(25) not null,
	Employee_City varchar(25) not null,
	Employee_Province varchar(25) not null,
    
    primary key (Employee_ID)
);

create table Employee_Contacts (
	Employee_ID varchar(10) not null,
	Contact_No varchar(10) not null
);

create table FOREIGN_CUSTOMER (
	Customer_ID varchar(10) not null,
    Customer_Name varchar(20) not null,
	Customer_Address varchar(30),
    Contact_No varchar(20) not null,
    Country varchar(10) not null,
    
    primary key (Customer_ID)
);

create table CUSTOMER_FEEDBACK (
	Product_Name varchar(10) not null,
    Customer_ID varchar(10) not null,
    Feedback varchar(30) not null,
    
    primary key(Customer_ID,Product_Name)
);

create table CUSTOMER_PAYMENT (
	CPayment_ID varchar(10) not null,
    Customer_ID varchar(10) not null,
    CPayment_Method varchar(15) not null,
	CPayment_Amount decimal(5,1) not null,
    CPayment_Date varchar(10) not null,
    Exchange_Rate varchar(10) not null,
    
    primary key (CPayment_ID)
);

create table CUSTOMER_REQUEST (
	Product_Name varchar(10) not null,
    Customer_ID varchar(10) not null,
    Product_Quantity int not null,
    
    primary key(Customer_ID,Product_Name)
);

show tables;

alter table Product add constraint fk_SupID foreign key(Supplier_ID) references SUPPLIER(Supplier_ID) on delete cascade;

alter table ORDERS add constraint fk_ProID foreign key(Product_ID) references PRODUCT(Product_ID) on delete cascade,
add constraint fk_ShipmentID foreign key(SP_ID) references SHIPMENT(Shipment_ID) on delete cascade;

alter table SUPPLIER_PAYMENT add constraint fk_OrdID foreign key(Order_ID) references ORDERS(Order_ID) on delete cascade,
add constraint fk_SupplierID foreign key(Supplier_ID) references SUPPLIER(Supplier_ID) on delete cascade;

alter table SHIPMENT  add constraint fk_CustomID foreign key(Customer_ID) references FOREIGN_CUSTOMER(Customer_ID) on delete cascade;

alter table SHIP add constraint fk_CompanyID foreign key(SC_Name) references SHIPPING_COMPANY(SC_Name) on delete cascade;

alter table EMPLOYEE add constraint fk_ManagerID foreign key(Manager_ID) references EMPLOYEE(Employee_ID) on delete cascade;

alter table EMPLOYEE_CONTACTS add constraint fk_EmpID foreign key(Employee_ID) references EMPLOYEE(Employee_ID) on delete cascade;

alter table CUSTOMER_FEEDBACK add constraint fk_CustomerID foreign key(Customer_ID) references FOREIGN_CUSTOMER(Customer_ID) on delete cascade;

alter table CUSTOMER_PAYMENT add constraint fk_CustomerPayID foreign key(Customer_ID) references FOREIGN_CUSTOMER(Customer_ID) on delete cascade;

alter table CUSTOMER_REQUEST add constraint fk_CustomerReqID foreign key(Customer_ID) references FOREIGN_CUSTOMER(Customer_ID) on delete cascade;

/*trigger for age calculation DONT USE YET*/ 
DELIMITER //
create trigger TriggerAge
Before update on employee
for each row
begin
set new.Age = timestampdiff(year,new.Birth_Date,curdate());
end;
//
DELIMITER ;

/*insert values to Employee table*/
INSERT INTO EMPLOYEE (Employee_ID, Employee_Name, Manager_ID, Birth_Date, Employed_Date, Job_Title, Age, Married, Employee_Street, Employee_City , Employee_Province)
VALUES ('E001', 'Kamal Perera', null, '1985-05-10', '2020-01-15', 'Manager', 38, TRUE, 'Main St','Kurunagala','NorthWest');
INSERT INTO EMPLOYEE VALUES ('E002', 'Anura Dias', null, '1990-09-20', '2018-03-10', 'Supervisor', 33, FALSE, '25th St','Dehiwala','Western');
INSERT INTO EMPLOYEE VALUES ('E003', 'Saman ', 'E002', '1988-03-15', '2021-07-05', 'Clerk', 35, TRUE, 'River Road','Kalutara','Western');
INSERT INTO EMPLOYEE VALUES ('E004', 'Eva Williams', 'E002', '1995-12-28', '2019-05-20', 'Clerk', 28, TRUE, 'Ranawiru St','Declo St','Eastern');
INSERT INTO EMPLOYEE VALUES ('E005', 'Sam Brown', 'E001', '1987-07-03', '2022-02-12', 'Clerk', 36, FALSE, 'Head St','Hapugala','South');
INSERT INTO EMPLOYEE VALUES ('E006', 'Grace Davis', 'E002', '1992-11-14', '2023-01-08', 'Clerk', 31, TRUE, 'Samagi St','Maha Nuwara','Central');

INSERT INTO EMPLOYEE_CONTACTS (Employee_ID,Contact_No)
VALUES ('E001','0035647382');
INSERT INTO EMPLOYEE_CONTACTS VALUES ('E001','0035647388');
INSERT INTO EMPLOYEE_CONTACTS VALUES ('E002','0029845378');
INSERT INTO EMPLOYEE_CONTACTS VALUES ('E002','0025472197');
INSERT INTO EMPLOYEE_CONTACTS VALUES ('E003','0014528824');
INSERT INTO EMPLOYEE_CONTACTS VALUES ('E004','0013741362');


INSERT INTO SUPPLIER(Supplier_ID,Supplier_Name,Email,Contact_NO,Street,City,Province)
VALUES ('S001','Richard Brooker','Rich001@gmail.com','0012343256','Bakers Road','Colombo','Westarn');
INSERT INTO SUPPLIER VALUES('S002','Donald sean','Don002@gmail.com','0924563789','1st Road','Nuwara Eliya','Central');
INSERT INTO SUPPLIER VALUES('S003','Dean Rollo','Dean003@gmail.com','0937286908','Garment Road','Galewela','Central');
INSERT INTO SUPPLIER VALUES('S004','Eric sawyer','Eric004@gmail.com','0991234143','B Road','Gampaha','Western');
INSERT INTO SUPPLIER VALUES('S005','Samuel drake','Sam005@gmail.com','0027865412','Sea Road','Galle','South');
INSERT INTO SUPPLIER VALUES('S006','Crystal blake','Blake006@gmail.com','0775684109','Temple Road','Kalutara','Western');

INSERT INTO FOREIGN_CUSTOMER (Customer_ID, Customer_Name, Customer_Address, Contact_No, Country)
VALUES ('CS001', 'John Smith', '123 International St', '+1 (555) 1234567', 'USA');
INSERT INTO FOREIGN_CUSTOMER VALUES ('CS002', 'Miranda Holmes', '456 Global Ave', '+1 (555) 987-6543', 'Mexico');
INSERT INTO FOREIGN_CUSTOMER VALUES ('CS003', 'Cole Müller', '789 International Rd', '+49 123456789', 'Germany');
INSERT INTO FOREIGN_CUSTOMER VALUES ('CS004', 'Luis Falcon', '101 Worldwide Blvd', '+52 987654321', 'Mexico');
INSERT INTO FOREIGN_CUSTOMER VALUES ('CS005', 'Sophie Turner', '222 Global Lane', '+33 123456789', 'France');

INSERT INTO PRODUCT (Product_ID, Supplier_ID, Product_Name, Product_Brand, Unit_Price, Quantity_Available, Product_Description)
VALUES ('P001', 'S001', 'Laptop', 'Dell', 899.9, 20, 'High-performance laptop');
INSERT INTO PRODUCT VALUES ('P002', 'S001', 'Smartphone', 'Samsung', 699.5, 30, 'Latest Android smartphone');
INSERT INTO PRODUCT VALUES ('P003', 'S002', 'Tablet', 'Apple', 499.0, 30, 'iOS tablet with Retina display');
INSERT INTO PRODUCT VALUES ('P004', 'S003', 'Desktop PC', 'HP', 749.8, 40, 'Powerful desktop computer');
INSERT INTO PRODUCT VALUES ('P005', 'S003', 'Keyboard', 'Logitech', 49.9, 50, 'Wireless keyboard with multimedia keys');
INSERT INTO PRODUCT VALUES ('P006', 'S003', 'Tablet', 'Samsung', 449.9, 20, ' tablet');
INSERT INTO PRODUCT VALUES ('P007', 'S002', 'Keyboard', 'Fantech', 49.9, 30, 'Wireless keyboard with multimedia keys');

INSERT INTO SHIPPING_COMPANY (SC_Name, SC_Street, SC_City, SC_Province, Contact_No, Coverage_Area, Freight_Rate)
VALUES ('RealSea', 'Seaside St','Galle','South', '0011234567', 'Local', 5.0);
INSERT INTO SHIPPING_COMPANY VALUES ('S&D', 'Cole St','Colombo','Western', '001876543', 'National', 7.5);
INSERT INTO SHIPPING_COMPANY VALUES ('DSpeed', 'Rain St','Jaffna','North', '0013337777', 'International', 10.2);
INSERT INTO SHIPPING_COMPANY VALUES ('LineT', 'Corner St','Galle','South', '0018889999', 'Regional', 6.3);
INSERT INTO SHIPPING_COMPANY VALUES ('WhaleCall', 'Army St','Hambanthota','South', '0012223333', 'Local', 4.8);

INSERT INTO SHIP (Ship_Code, SC_Name, Ship_Name, Ship_Operator, Shipping_Route, Dead_weight)
VALUES ('SC01', 'S&D', 'Reed One', 'Cap. Rolo', 'Route1', 100.5);
INSERT INTO SHIP VALUES ('SC02', 'DSpeed', 'SMCfive', 'Cap. Fin', 'Route2', 150.3);
INSERT INTO SHIP VALUES ('SC03', 'WhaleCall', 'GreenWhale', 'Cap. diggins', 'Route3', 120.2);
INSERT INTO SHIP VALUES ('SC04', 'S&D', 'Cam One', 'Cap. Pale', 'Route4', 180.7);
INSERT INTO SHIP VALUES ('SC05', 'LineT', 'ZoloRide', 'Cap. Peris', 'Route5', 90.8);

INSERT INTO SHIPMENT (Shipment_ID, Customer_ID, Ship_Code, Shipping_Date, Estimate_Delivery, Origin_Location, Destination, Shipment_Weight)
VALUES ('ST001', 'CS001', 'SC01', '2023-09-15', '2023-09-20', 'Galle', 'London', 250.5);
INSERT INTO SHIPMENT VALUES ('ST002', 'CS002', 'SC02', '2023-09-16', '2023-09-22', 'Galle', 'New York', 180.3);
INSERT INTO SHIPMENT VALUES ('ST003', 'CS003', 'SC03', '2023-09-17', '2023-09-25', 'Hambanthota', 'Cole Island', 120.2);
INSERT INTO SHIPMENT VALUES ('ST004', 'CS004', 'SC04', '2023-09-18', '2023-09-26', 'Colombo', 'London', 210.7);
INSERT INTO SHIPMENT VALUES ('ST005', 'CS005', 'SC05', '2023-09-19', '2023-09-28', 'Colombo', 'Morokko', 150.8);

INSERT INTO ORDERS (Order_ID, Product_ID, SP_ID, Order_Quantity, Added_Date)
VALUES ('ODR001', 'P001', 'ST001', 10, '2023-09-15');
INSERT INTO ORDERS VALUES ('ODR002', 'P002', 'ST002', 5, '2023-09-16');
INSERT INTO ORDERS VALUES ('ODR003', 'P003', 'ST003', 8, '2023-09-17');
INSERT INTO ORDERS VALUES ('ODR004', 'P004', 'ST004', 15, '2023-09-18');
INSERT INTO ORDERS VALUES ('ODR005', 'P005', 'ST005', 12, '2023-09-19');

INSERT INTO SUPPLIER_PAYMENT (SP_ID, Order_ID, Supplier_ID, Total_Payment, Payment_Date, Payment_Method, Bank_Name, Bank_Branch, Account_No)
VALUES ('SPAY001', 'ODR001', 'S001', 500.0, '2023-09-15', 'BankTransfer', 'BOC Bank', 'Main Branch', '1234567890');
INSERT INTO SUPPLIER_PAYMENT VALUES ('SPAY002', 'ODR002', 'S002', 300.5, '2023-09-16', 'Cheque', 'Commerical Bank', 'Main Branch', '9876543210');
INSERT INTO SUPPLIER_PAYMENT VALUES ('SPAY003', 'ODR003', 'S003', 800.2, '2023-09-17', 'BankTransfer', 'HND Bank', 'Galle Branch', '5555555555');
INSERT INTO SUPPLIER_PAYMENT VALUES ('SPAY004', 'ODR004', 'S004', 1200.7, '2023-09-18', 'BankTransfer', 'BOC Bank', 'Main Branch', '1111222233');
INSERT INTO SUPPLIER_PAYMENT VALUES ('SPAY005', 'ODR005', 'S005', 950.8, '2023-09-19', 'Cheque', 'BOC Bank', 'Main Branch', '4444333322');

INSERT INTO CUSTOMER_PAYMENT (CPayment_ID, Customer_ID, CPayment_Method, CPayment_Amount, CPayment_Date, Exchange_Rate)
VALUES ('CP001', 'CS001', 'CreditCard', 150.0, '2023-09-15', '1.2');
INSERT INTO CUSTOMER_PAYMENT VALUES ('CP002', 'CS002', 'PayPal', 75.5, '2023-09-16', '1.1');
INSERT INTO CUSTOMER_PAYMENT VALUES ('CP003', 'CS003', 'BankTransfer', 200.2, '2023-09-17', '1.3');
INSERT INTO CUSTOMER_PAYMENT VALUES ('CP004', 'CS004', 'CreditCard', 180.7, '2023-09-18', '1.4');
INSERT INTO CUSTOMER_PAYMENT VALUES ('CP005', 'CS005', 'PayPal', 120.8, '2023-09-19', '1.2');

INSERT INTO CUSTOMER_REQUEST (Product_Name,Customer_ID,Product_Quantity)
VALUES ('Laptop','CS001',20);
INSERT INTO CUSTOMER_REQUEST VALUES ('Tablet','CS001',10);
INSERT INTO CUSTOMER_REQUEST VALUES ('Smartphone','CS002',10);
INSERT INTO CUSTOMER_REQUEST VALUES ('Tablet','CS003',10);
INSERT INTO CUSTOMER_REQUEST VALUES ('Latop','CS004',5);
INSERT INTO CUSTOMER_REQUEST VALUES ('Desktop PC','CS003',10);

INSERT INTO CUSTOMER_FEEDBACK (Product_Name,Customer_ID,Feedback)
VALUES ('Laptop','CS001','Product is good');
INSERT INTO CUSTOMER_FEEDBACK VALUES ('Smartphone','CS001','Product is good');
INSERT INTO CUSTOMER_FEEDBACK VALUES ('Desktop PC','CS002','Product is very good');
INSERT INTO CUSTOMER_FEEDBACK VALUES ('Smartphone','CS003','Average Quality');
INSERT INTO CUSTOMER_FEEDBACK VALUES ('Laptop','CS002','Product is very good');

/*update delete*/

/*employee*/
UPDATE EMPLOYEE set Married = false where Employee_ID = 'E002';
UPDATE EMPLOYEE set Job_Title = 'Manager' where Employee_ID = 'E005';

DELETE FROM EMPLOYEE where Employee_ID = 'EE006';

/*employee_contacts*/
UPDATE EMPLOYEE_CONTACTS set Contact_No = '0875643425' where Employee_ID = 'E002' and Contact_No = '0025472197';
UPDATE EMPLOYEE_CONTACTS set Contact_No = '0874518467' where Employee_ID = 'E004' and Contact_No = '0013741362';

DELETE FROM EMPLOYEE_CONTACTS where Employee_ID = 'EE002' and Contact_No = '0029845378';

/*supplier*/
UPDATE SUPPLIER set Email = 'Eric004@gmail.com' where Supplier_ID = 'S004';
UPDATE SUPPLIER set Contact_No = '0027865412' where Supplier_ID = 'S005';

DELETE FROM SUPPLIER where Supplier_ID = 'S006';

/*FOREIGN_CUSTOMER*/
UPDATE FOREIGN_CUSTOMER set Contact_No = '+49 123456890' where Customer_ID = 'CS003';
UPDATE FOREIGN_CUSTOMER set Customer_Address = '111 Roman Street' where Customer_ID = 'CS004';

DELETE FROM FOREIGN_CUSTOMER where Customer_ID = 'CS005';

/*PRODUCT*/
UPDATE PRODUCT set Quantity_Available = 25 where Product_ID = 'P001';
UPDATE PRODUCT set Unit_Price = 459.8 where Product_ID = 'P003';

DELETE FROM PRODUCT where Product_ID = 'P004';

/*Shipping_company*/
UPDATE SHIPPING_COMPANY set Contact_No = '0018779569' where SC_Name = 'LineT';
UPDATE SHIPPING_COMPANY set Freight_Rate = 4.5 where SC_Name = 'S&D';

DELETE FROM SHIPPING_COMPANY where SC_Name = 'RealSea';

/*SHIP*/
UPDATE SHIP set Ship_Operator = 'Cpt. Price' where Ship_Code = 'SC03';
UPDATE SHIP set Ship_Name = 'Red One' where Ship_Code = 'SC01';

DELETE FROM SHIP where Ship_Code = 'SC05';

/*SHIPMENT*/
UPDATE SHIPMENT set Shipment_Weight = '185.3' where Shipment_ID = 'ST002';
UPDATE SHIPMENT set Destination = 'New York' where Shipment_ID = 'ST003';

DELETE FROM SHIPMENT where Shipment_ID = 'SC004';

/*ORDERS*/
UPDATE ORDERS set SP_ID = 'ST004' where Order_ID = 'ODR002';
UPDATE ORDERS set Order_Quantity = 10 where Order_ID = 'ODR003';

DELETE FROM ORDERS where Order_ID = 'ODR004';

/*SUPPLIER_PAYMENT*/
UPDATE SUPPLIER_PAYMENT set Total_Payment = 550.0 where SP_ID = 'SPAY001';
UPDATE SUPPLIER_PAYMENT set Payment_Date = '2023-09-18' where SP_ID = 'SPAY002';

DELETE FROM SUPPLIER_PAYMENT where SP_ID = 'SPAY003';

/*CUSTOMER_PAYMENT*/
UPDATE CUSTOMER_PAYMENT set CPayment_Amount = 80.5 where CPayment_ID = 'CP002';
UPDATE CUSTOMER_PAYMENT set CPayment_Date = '2023-09-16' where CPayment_ID = 'CP003';

DELETE FROM CUSTOMER_PAYMENT where CPayment_ID = 'CP004';

/*CUSTOMER_REQUEST*/
UPDATE CUSTOMER_REQUEST set Product_Quantity = 15 where Product_Name = 'Tablet' and Customer_ID = 'CS001';
UPDATE CUSTOMER_REQUEST set Product_Name = 'Smartphone' where Product_Name = 'Desktop PC' and Customer_ID = 'CS003';

DELETE FROM CUSTOMER_REQUEST where Product_Name = 'Latop' and Customer_ID = 'CS004';

/*CUSTOMER_FEEDBACK*/
UPDATE CUSTOMER_FEEDBACK set Feedback = 'Product is very good' where Product_Name = 'Smartphone' and Customer_ID = 'CS001';
UPDATE CUSTOMER_FEEDBACK set Product_Name = 'Tablet' where Product_Name = 'Laptop' and Customer_ID = 'CS002';

DELETE FROM CUSTOMER_FEEDBACK where Product_Name = 'Smartphone' and Customer_ID = 'CS003';

/*SELECT*/
SELECT * FROM EMPLOYEE;
SELECT * FROM EMPLOYEE where Employee_Province = 'Western';

/*Project*/
SELECT * FROM PRODUCT;
SELECT Product_ID,Product_Name,Product_Name FROM PRODUCT;

/*Cartesian*/
SELECT * FROM SHIP;
SELECT * FROM SHIPPING_COMPANY;
SELECT * FROM SHIP CROSS JOIN SHIPPING_COMPANY;

/*USER VIEW*/
CREATE VIEW view1 as SELECT Supplier_ID,Supplier_Name from SUPPLIER;
SELECT * FROM view1;

/*Rename*/
RENAME TABLE EMPLOYEE_CONTACTS TO CONTACTS;
SHOW tables;

/*Aggregation*/
SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT where Unit_Price = (SELECT MAX(Unit_Price) FROM PRODUCT);

/* LIKE*/
SELECT * FROM SHIP;
SELECT * FROM SHIP where (Ship_Name LIKE '%One');

/*complex*/
/*union*/
SELECT * FROM EMPLOYEE;
(SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Manager')
Union
(SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Supervisor');

/*intersect*/
SELECT * FROM ORDERS;
SELECT * FROM SHIPMENT;
SELECT Order_ID,Order_Quantity as Quantity FROM ORDERS as o inner join SHIPMENT AS s on o.SP_ID = s.Shipment_ID where o.Order_Quantity > 5 and s.Shipment_Weight > 200;

/*set difference*/
SELECT * FROM SHIP;
SELECT * FROM SHIPPING_COMPANY;
SELECT Ship_Code,Ship_Operator as Operator FROM SHIP as s inner join SHIPPING_COMPANY AS sc on s.SC_Name= sc.SC_Name where s.Dead_weight > 100 and sc.Coverage_Area != 'National';

/*division*/
SELECT * FROM PRODUCT;
SELECT DISTINCT Supplier_ID FROM PRODUCT WHERE Supplier_ID = 'S002' OR Supplier_ID = 'S003';

SELECT DISTINCT Product_Name FROM PRODUCT AS P WHERE EXISTS (SELECT Supplier_ID FROM PRODUCT AS PP WHERE (Supplier_ID = 'S002' OR Supplier_ID = 'S003') AND (p.Product_Name = PP.Product_Name));

/*Inner join*/
CREATE VIEW View2 as SELECT Customer_ID,Customer_Name,Contact_No FROM FOREIGN_CUSTOMER;
CREATE VIEW View3 as SELECT * FROM CUSTOMER_PAYMENT;
SELECT * FROM View2;
SELECT * FROM View3;

SELECT * FROM View2 as v2 inner join View3 as v3 on v2.Customer_ID = v3.Customer_ID where v3.CPayment_Amount < 160;

/*Natural join*/
CREATE VIEW View4 as SELECT Supplier_ID,Supplier_Name,Contact_No FROM SUPPLIER;
CREATE VIEW View5 as SELECT * FROM SUPPLIER_PAYMENT;
SELECT * FROM View4;
SELECT * FROM View5;

SELECT * FROM View4 as v4 natural join View5 as v5 where v5.Bank_Name = 'BOC Bank';

/*Right outer join*/
CREATE VIEW View6 as SELECT Product_ID,Product_Name,Product_Brand,Supplier_ID as Supplier FROM PRODUCT;
CREATE VIEW View7 as SELECT Supplier_ID,Supplier_Name,Contact_No,City FROM SUPPLIER;
SELECT * FROM View6;
SELECT * FROM View7;

SELECT * FROM View6 as v6 right outer join View7 as v7 on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle';

/*Left outer join*/
SELECT * FROM View6;
SELECT * FROM View7;

SELECT * FROM View6 as v6 left outer join View7 as v7 on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle';

/*Full outer join*/
CREATE VIEW View8 as (SELECT * FROM View6 as v6 right outer join View7 as v7 on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');
CREATE VIEW View9 as (SELECT * FROM View6 as v6 left outer join View7 as v7 on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');

SELECT * FROM View8;
SELECT * FROM View9;

(Select * FROM View8)
union
(Select * FROM View9);

/*Outer union*/
SELECT * FROM SHIPMENT;
SELECT * FROM FOREIGN_CUSTOMER;

CREATE VIEW view10 as 
((SELECT Shipment_ID,Customer_ID,Ship_Code,Shipping_Date,Estimate_Delivery,Shipment_Weight FROM SHIPMENT natural join FOREIGN_CUSTOMER)
union
(SELECT Shipment_ID,Customer_ID,Ship_Code,Shipping_Date,Estimate_Delivery,NULL FROM SHIPMENT));

SELECT * FROM View10;

SELECT * FROM View10 as v10 where (Customer_ID in (SELECT Customer_ID FROM FOREIGN_CUSTOMER) and Shipment_Weight IS NOT Null);

/*Nested query 1*/
SELECT * FROM ORDERS;
SELECT * FROM PRODUCT;

SELECT Order_ID,Order_Quantity FROM ORDERS AS o WHERE o.Product_ID IN (SELECT Product_ID FROM PRODUCT AS p WHERE p.Supplier_ID = 'S001');

/*Nested query 2*/
SELECT * FROM CUSTOMER_FEEDBACK;
SELECT * FROM FOREIGN_CUSTOMER;

SELECT Product_Name,Feedback FROM CUSTOMER_FEEDBACK AS cf WHERE cf.Customer_ID IN (SELECT Customer_ID FROM FOREIGN_CUSTOMER AS c WHERE c.Country = 'Mexico');

/*Nested query 3*/
SELECT * FROM SHIP;
SELECT * FROM SHIPPING_COMPANY;

SELECT Ship_Code,Ship_Name,Ship_Operator,Shipping_Route FROM SHIP AS s WHERE s.SC_Name IN (SELECT SC_Name FROM SHIPPING_COMPANY AS c WHERE c.SC_City = 'South');

/* TUNING */
/*UNION*/
SHOW INDEX FROM EMPLOYEE;

EXPLAIN ((SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Manager')
Union
(SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Supervisor'));

CREATE INDEX Job_Title_IND ON EMPLOYEE(Job_Title);
SHOW INDEX FROM EMPLOYEE;

EXPLAIN ((SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Manager')
Union
(SELECT Employee_Name as Name,Employed_Date as EDate FROM EMPLOYEE where Job_Title = 'Supervisor'));

/*intersect*/
SHOW INDEX FROM ORDERS;

EXPLAIN (SELECT Order_ID,Order_Quantity as Quantity FROM ORDERS as o 
inner join SHIPMENT AS s on o.SP_ID = s.Shipment_ID where o.Order_Quantity = 10 and s.Shipment_Weight > 200);

CREATE INDEX Order_Quantity_IND ON ORDERS(Order_Quantity);
SHOW INDEX FROM ORDERS;

EXPLAIN (SELECT Order_ID,Order_Quantity as Quantity FROM ORDERS as o 
inner join SHIPMENT AS s on o.SP_ID = s.Shipment_ID where o.Order_Quantity = 10 and s.Shipment_Weight > 200);

/* set difference*/
SHOW INDEX FROM SHIP;
SHOW INDEX FROM SHIPPING_COMPANY;

Explain(SELECT Ship_Code,Ship_Operator as Operator FROM SHIP as s 
inner join SHIPPING_COMPANY AS sc on s.SC_Name= sc.SC_Name where s.Dead_weight > 100 and sc.Coverage_Area != 'National');

CREATE INDEX Dead_weight_IND ON SHIP(Dead_weight);
SHOW INDEX FROM SHIP;

Explain(SELECT Ship_Code,Ship_Operator as Operator FROM SHIP as s 
inner join SHIPPING_COMPANY AS sc on s.SC_Name= sc.SC_Name where s.Dead_weight > 100 and sc.Coverage_Area != 'National');

/*NATURAL JOIN*/
SHOW INDEX FROM SUPPLIER;
SHOW INDEX FROM SUPPLIER_PAYMENT;

EXPLAIN (SELECT * FROM View4 as v4 natural join View5 as v5 where v5.Bank_Name = 'BOC Bank');

CREATE INDEX Bank_Name_IND ON SUPPLIER_PAYMENT(Bank_Name);
SHOW INDEX FROM SUPPLIER_PAYMENT;

EXPLAIN (SELECT * FROM View4 as v4 natural join View5 as v5 where v5.Bank_Name = 'BOC Bank');

/*RIGHT OUTER */
SHOW INDEX FROM PRODUCT;
SHOW INDEX FROM SUPPLIER;

EXPLAIN (SELECT * FROM View6 as v6 right outer join View7 as v7 
on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');

CREATE INDEX City_IND ON SUPPLIER(City);
SHOW INDEX FROM SUPPLIER;

EXPLAIN (SELECT * FROM View6 as v6 right outer join View7 as v7 
on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');

/*LEFT OUTER */
SHOW INDEX FROM PRODUCT;
SHOW INDEX FROM SUPPLIER;

EXPLAIN (SELECT * FROM View6 as v6 left outer join View7 as v7 
on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');

/*CREATE INDEX City_IND ON SUPPLIER(City);*/
SHOW INDEX FROM SUPPLIER;

EXPLAIN (SELECT * FROM View6 as v6 left outer join View7 as v7 
on v6.Supplier = v7.Supplier_ID where v7.City = 'Colombo' or v7.City = 'Galle');

/*full outer join*/
SHOW INDEX FROM PRODUCT;
SHOW INDEX FROM SUPPLIER;

EXPLAIN ((Select * FROM View8)
union
(Select * FROM View9));

/*CREATE INDEX City_IND ON SUPPLIER(City);*/
SHOW INDEX FROM SUPPLIER;

EXPLAIN ((Select * FROM View8)
union
(Select * FROM View9));

/*NESTED QUERY 1*/
SHOW INDEX FROM PRODUCT;
SHOW INDEX FROM ORDERS;

EXPLAIN(SELECT Order_ID,Order_Quantity FROM ORDERS AS o WHERE o.Product_ID 
IN (SELECT Product_ID FROM PRODUCT AS p WHERE p.Supplier_ID = 'S001'));

CREATE INDEX Supplier_ID_IND ON PRODUCT(Supplier_ID);

EXPLAIN(SELECT Order_ID,Order_Quantity FROM ORDERS AS o WHERE o.Product_ID 
IN (SELECT Product_ID FROM PRODUCT AS p WHERE p.Supplier_ID = 'S001'));

/*NESTED QUERY 2*/
SHOW INDEX FROM CUSTOMER_FEEDBACK;
SHOW INDEX FROM FOREIGN_CUSTOMER;

EXPLAIN(SELECT Product_Name,Feedback FROM CUSTOMER_FEEDBACK AS cf 
WHERE cf.Customer_ID IN (SELECT Customer_ID FROM FOREIGN_CUSTOMER AS c WHERE c.Country = 'Mexico'));

CREATE INDEX Country_IND ON FOREIGN_CUSTOMER(COUNTRY);
SHOW INDEX FROM FOREIGN_CUSTOMER;

EXPLAIN(SELECT Product_Name,Feedback FROM CUSTOMER_FEEDBACK AS cf 
WHERE cf.Customer_ID IN (SELECT Customer_ID FROM FOREIGN_CUSTOMER AS c WHERE c.Country = 'Mexico'));

/*NESTED QUERY 3*/
SHOW INDEX FROM SHIP;
SHOW INDEX FROM SHIPPING_COMPANY;

EXPLAIN(SELECT Ship_Code,Ship_Name,Ship_Operator,Shipping_Route FROM SHIP AS s 
WHERE s.SC_Name IN (SELECT SC_Name FROM SHIPPING_COMPANY AS c WHERE c.SC_City = 'South'));

CREATE INDEX SC_City_IND ON SHIPPING_COMPANY(SC_City);
SHOW INDEX FROM SHIPPING_COMPANY;
EXPLAIN(SELECT Ship_Code,Ship_Name,Ship_Operator,Shipping_Route FROM SHIP AS s 
WHERE s.SC_Name IN (SELECT SC_Name FROM SHIPPING_COMPANY AS c WHERE c.SC_City = 'South'));
