CREATE DATABASE MyJoinsDB;

 CREATE TABLE MyJoinsDB.Employee  
(
    id INT AUTO_INCREMENT NOT NULL primary key,
	firstName VARCHAR(30) NOT NULL,   			 
    lastName VARCHAR(30) NOT NULL, 				 
    phone VARCHAR(20) NOT NULL
);

INSERT MyJoinsDB.Employee( firstName, lastName, phone)
VALUES
('Петро', 'Петров', '(091)7612343'),
('Степан', 'Степанов', '(092)7612343'),
('Олег', 'Олегович', '(093)7612343'),
('Віктор', 'Вікторов', '(094)7612343');
 SELECT * FROM  MyJoinsDB.Employee ;


  CREATE TABLE MyJoinsDB.position 
(	
     positionId INT not null,
     position VARCHAR(30) NOT NULL,    
     salary double NOT NULL, 	     
     FOREIGN KEY(positionId) references Employee(id),
     PRIMARY KEY (positionId)
);
INSERT INTO MyJoinsDB.position																			   
(positionId, position, salary)
VALUES
(1, 'Директор', 50000.00),
(2, 'Заступник Директора', 35000.00),
(3, 'Продавець', 10000.00),
(4, 'Менеджер', 15000.00);
SELECT * FROM  MyJoinsDB.position;
 
 
 CREATE TABLE MyJoinsDB.workingStatus   
(		 
     EmployeeID INT not null,
     famStatus VARCHAR(30) NOT NULL,  
     dateBirth DATE NOT NULL, 			
     address VARCHAR(100) NOT NULL, 		
     FOREIGN KEY(EmployeeID) references Employee(id),
     PRIMARY KEY (EmployeeID)
);
INSERT INTO MyJoinsDB.workingStatus 																			   
(EmployeeID, famStatus, dateBirth, address)
VALUES
(1, 'не одружений', '1991-06-16', 'вул. Добрівлянська / 64'),
(2, 'одружений', '1992-03-01', 'вул. Січових Стрільців / 2'),
(3, 'не одружений', '1993-09-20', 'вул. Львівська / 3'),
(4, 'одружений', '1994-10-28', 'вул. Колесси / 4');
SELECT * FROM  MyJoinsDB.workingStatus;
 

SELECT address as место_жительства ,
(SELECT phone FROM MyJoinsDB.Employee WHERE id = EmployeeID) AS телефон 
FROM MyJoinsDB.workingStatus;


SELECT   
(SELECT dateBirth  FROM MyJoinsDB.Employee WHERE  id = EmployeeID ) AS ДР,
(SELECT phone  FROM MyJoinsDB.Employee WHERE  id = EmployeeID ) AS телефон
FROM MyJoinsDB.workingStatus
WHERE famStatus IN (SELECT 'не одружений' FROM MyJoinsDB.workingStatus);


CREATE TEMPORARY TABLE MyJoinsDB.TmpTable
SELECT
(SELECT dateBirth  FROM MyJoinsDB.Employee WHERE  id = EmployeeID ) AS Birth_Date,
(SELECT phone  FROM MyJoinsDB.Employee WHERE  id = EmployeeID ) AS Phone,
(SELECT position  FROM MyJoinsDB.position WHERE  positionId = EmployeeID ) AS Title_Job
FROM MyJoinsDB.workingStatus; 
SELECT Birth_Date, Phone FROM MyJoinsDB.TmpTable WHERE Title_Job = 'Продавець';