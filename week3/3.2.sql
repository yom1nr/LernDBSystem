-- 3.2.1
UPDATE product
SET pname = 'iPhone11'
WHERE pname = 'iPhone';
-- 3.2.2
UPDATE Manufacturer
SET City = 'Rayong'
WHERE mname = 'Meji';
-- 3.2.3
UPDATE product 
SET instock = 0
WHERE pid = '2';
-- 3.2.4
UPDATE product
SET Type = 'Drink', instock = 300
WHERE pid = '3' ;		

