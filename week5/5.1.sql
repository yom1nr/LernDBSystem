SELECT e.FIRST_NAME, d.NAME
FROM employee e
INNER JOIN department d
ON e.DEPT_ID = d.DEPT_ID
WHERE d.NAME = 'Operations';

SELECT o.FIRST_NAME AS Officer_Name, i.FIRST_NAME AS Individual_Name
FROM officer o
INNER JOIN individual i
ON o.CUST_ID = i.CUST_ID;

SELECT 
    sub.EMP_ID,
    sub.FIRST_NAME AS Emp_First_Name, 
    sub.LAST_NAME AS Emp_Last_Name,
    sup.FIRST_NAME AS Manager_First_Name, 
    sup.LAST_NAME AS Manager_Last_Name
FROM employee sub
INNER JOIN employee sup 
ON sub.SUPERIOR_EMP_ID = sup.EMP_ID
LIMIT 5;