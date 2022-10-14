CREATE DATABASE ShopDB;
  
 CREATE TABLE ShopDB.Customer  
(
    Customerid INT AUTO_INCREMENT NOT NULL primary key,
	firstNameC VARCHAR(30) NOT NULL,   			 
    lastNameC VARCHAR(30) NOT NULL, 				 
	dateOfStart date 	
);
INSERT ShopDB.Customer( firstNameC, lastNameC, dateOfStart)
VALUES
('Петро', 'Петренко', now()),
('Василь', 'Василенко', now()),
('Олег', 'Сенько', now());
 SELECT * FROM ShopDB.Customer;
  
  
  CREATE TABLE ShopDB.delivery 
(
    deliveryId INT AUTO_INCREMENT NOT NULL,
    IDCustomer int NOT NULL, 
	city VARCHAR(30) not null,   
    street varchar(30),
    house int, 	
    FOREIGN KEY(IDCustomer) references Customer(Customerid),
    PRIMARY KEY (deliveryid, IDCustomer)
);
INSERT ShopDB.delivery(IDCustomer, city, street, house)
VALUES
(1, 'Львів', 'Чорновола', 15),
(1, 'Львів', 'Богдана Хмельницкого', 16),
(2, 'Київ', 'Хрещатик', 5),
(3, 'Вінниця', 'Тараса Шевченка', 5);
 SELECT * FROM ShopDB.delivery;
  
  
  CREATE TABLE ShopDB.phone  
(
	phone VARCHAR(20) NOT NULL,
    IDCustomerPhone int NOT NULL, 
    FOREIGN KEY(IDCustomerPhone) references Customer(Customerid),
    PRIMARY KEY (IDCustomerPhone, phone)
);
INSERT ShopDB.phone(IDCustomerPhone, phone)
VALUES
(1, '(099)0000001'),
(1, '(099)0000002'),
(2, '(099)0000003'),
(3, '(099)0000004');

 SELECT * FROM ShopDB.phone; 
  
  
 CREATE TABLE ShopDB.Employee 
(
    Employeeid INT AUTO_INCREMENT NOT NULL,
	lastName VARCHAR(30) NOT NULL,   			
    firstName VARCHAR(30) NOT NULL, 				
    position VARCHAR(30) NOT NULL, 	            
	PRIMARY KEY (Employeeid)
);
INSERT ShopDB.Employee(lastName, firstName , position)
VALUES
('Білецький', 'Андрій', 'Продавець'),
('Лялечкина', 'Светлана', 'Менеджер');
 SELECT * FROM ShopDB.Employee; 


  CREATE TABLE ShopDB.store  
(
    storeid INT AUTO_INCREMENT NOT NULL,
	art VARCHAR(30) NOT NULL,  
    nameProduct VARCHAR(100) NOT NULL,  
    price double NOT NULL, 
    currency VARCHAR(10),
    totalStock double DEFAULT 0,
	PRIMARY KEY (storeid)
);
INSERT ShopDB.store(art, nameProduct, price, currency, totalStock)
VALUES
('123', 'Ламінат', 30, '$', 100),
('321', 'Плінтус', 32, '$', 150),
('231', 'Паркет', 50, '$', 320),
('412', 'Фкрнітура', 10, '$', 1000),
('214', 'Ламінат', 35, '$', 250);
 SELECT * FROM ShopDB.store; 
 
 
 CREATE TABLE ShopDB.Orders2
(    
	OrderID int AUTO_INCREMENT NOT NULL,  
    PRIMARY KEY (OrderID),       
    OrderDate date NOT NULL, 
    
    IDEmployee int,  
	FOREIGN KEY(IDEmployee) REFERENCES ShopDB.Employee(Employeeid),    
    
 	IDCustomer int,
 	FOREIGN KEY(IDCustomer) REFERENCES ShopDB.Customer(Customerid),    
    
    IDdelivery int,
    FOREIGN KEY(IDdelivery, IDCustomer) REFERENCES ShopDB.delivery(deliveryID, IDCustomer), 
    
    IDphone VARCHAR(20) NOT NULL  
);
INSERT ShopDB.Orders2(OrderDate, IDEmployee, IDCustomer, IDdelivery, IDphone)
VALUES
(now(), 1, 1, 1, '(099)0000001'),
(now(), 2, 2, 3, '(099)0000002'),
(now(), 2, 3, 4, '(095)0000003');
 SELECT * FROM ShopDB.OrdersV2; 
  
  
 CREATE TABLE ShopDB.OrderDetails 
(
    idTest int auto_increment not null,
	DetailsOrderID int NOT NULL, 		
	LineItem int NOT NULL,  	
	IDstore int NOT NULL,    	
	totalQty int NOT NULL,  	
    FOREIGN KEY(DetailsOrderID) REFERENCES ShopDB.Orders2(OrderID),
	FOREIGN KEY(IDstore) REFERENCES ShopDB.store(storeid),  
	PRIMARY KEY (idTest)
);
INSERT ShopDB.OrderDetails(DetailsOrderID, LineItem, IDstore, totalQty)
VALUES
		(1, 1, 1, 20),
        (1, 2, 2, 18), 
        (2, 1, 2, 15),
        (2, 2, 3, 30), 
		(3, 1, 4, 5),
		(3, 2, 5, 5),
		(3, 3, 1, 5);
 SELECT * FROM ShopDB.OrderDetails; 
 
 
 CREATE TEMPORARY TABLE ShopDB.Table_Customer_Worker
 SELECT
  DetailsOrderID ,
  LineItem as поз_в_заказ,
 (SELECT IDEmployee  FROM ShopDB.Orders2 WHERE  DetailsOrderID = OrderID ) AS Worker_ID,
 (SELECT CONCAT(firstName, ' ', lastName)  FROM ShopDB.employee WHERE  employee.Employeeid = Worker_ID ) AS Worker,
  
 (SELECT IDCustomer  FROM ShopDB.Orders2 WHERE  DetailsOrderID = OrderID ) AS Customer_ID,
 (SELECT CONCAT(firstNameC, ' ', lastNameC)  FROM ShopDB.customer WHERE  Customerid = Customer_ID ) AS Customer,
  
 (SELECT price * totalQty from ShopDB.store WHERE store.storeid =  OrderDetails.IDstore ) AS TotalPrice
FROM ShopDB.OrderDetails;

select * from ShopDB.Table_Customer_Worker;


SELECT
 DetailsOrderID  as №замовлення,
 COUNT(DetailsOrderID) as Кількість,
 sum(TotalPrice) as Сума, 
 Worker as Робітник, 
 Customer as Покупець 

 FROM ShopDB.Table_Customer_Worker 
 group by Table_Customer_Worker.DetailsOrderID
 having Сума  > 200;
 