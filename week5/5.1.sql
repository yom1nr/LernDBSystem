SELECT e.FIRST_NAME, d.NAME
FROM employee e
INNER JOIN department d
ON e.DEPT_ID = d.DEPT_ID
WHERE d.NAME = 'Operations';

SELECT 
	o.FIRST_NAME AS Officer_Name, 
    i.FIRST_NAME AS Individual_Name
FROM customer c
INNER JOIN officer o 	ON c.CUST_ID = o.CUST_ID
INNER JOIN individual i ON c.CUST_ID = i.CUST_ID;

SELECT 
    worker.EMP_ID, 
    worker.FIRST_NAME, 
    worker.LAST_NAME, 
    manager.FIRST_NAME, 
    manager.LAST_NAME
FROM employee worker
LEFT JOIN employee manager 
ON worker.SUPERIOR_EMP_ID = manager.EMP_ID
LIMIT 5;