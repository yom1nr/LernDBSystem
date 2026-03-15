CREATE TABLE Manufacturer (
    mid VARCHAR(100) PRIMARY KEY,      
    mname VARCHAR(100),       
    City VARCHAR(100)        
);

CREATE TABLE Product (
    pid VARCHAR(100) PRIMARY KEY,     
    pname VARCHAR(100),      
    price DECIMAL(10,2),      
    Type VARCHAR(50),      
    instock INT,             
    mid VARCHAR(100),                
    FOREIGN KEY (mid) REFERENCES Manufacturer(mid) 
);

INSERT INTO Manufacturer (mid, mname, City) VALUES
('1', 'Apple', 'BKK'),
('2', 'Meji', 'Korat'),
('3', 'Nintendo', 'BKK');

INSERT INTO Product (pid, pname, price, Type, instock, mid) VALUES
	('1', 'iPhone', 50000, 'Technology', 10, '1'),
	('2', 'Nintendo Switch', 10000, 'Technology', 5, '3'),
	('3', 'Milk', 10, 'Food', 50, '2');
    
INSERT INTO Manufacturer (mid, mname, City) VALUES
('4', 'Nvidia', 'USA'),
('5', 'Sony', 'Chonburi');

INSERT INTO Product (pid, pname, price, Type, instock, mid) VALUES
('4', 'RTX 5080', 40000, 'Technology', 20, '4'),
('5', 'PlayStation 5', 18000, 'Technology', 15, '5'),
('6', 'PlayStation 4', 12000, 'Technology', 30, '5');

UPDATE Manufacturer 
SET 
	City = 'LA' 
WHERE
	mid = '4';
    
INSERT INTO Manufacturer (mid, mname, City) VALUES
('6', 'Logitech', 'BKK'),
('7', 'Puma', 'MILAN'),
('8', 'Coca-Cola', 'Pathum Thani'),
('9', 'Nike', 'MIAMI'),
('10', 'Adidas', 'SSK');

INSERT INTO Product (pid, pname, price, Type, instock, mid) VALUES
('6', 'Wireless Mouse', 1500, 'Technology', 100, '6'),
('7', ' Ultra 6', 5500, 'Fashion', 200, '7'),
('8', 'Coke Zero', 15, 'Drink', 500, '8'),
('9', 'Air Force 1', 3500, 'Fashion', 30, '9'),
('10', 'Ultraboost', 6500, 'Fashion', 25, '10');
    
    
    
    
    
    
    
    