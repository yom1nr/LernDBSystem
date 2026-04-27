CREATE OR REPLACE VIEW loan_view AS
SELECT branch_name, SUM(amount)
FROM loan
GROUP BY branch_name
HAVING SUM(amount) > 3000;
SELECT * FROM loan_view;

CREATE OR REPLACE VIEW join_view AS
SELECT a.account_number, a.branch_name, a.balance, c.customer_name
FROM account a
INNER JOIN depositor d ON a.account_number = d.account_number
INNER JOIN customer c ON d.customer_name = c.customer_name
WHERE a.branch_name = 'SUT';
SELECT * FROM join_view;

CREATE OR REPLACE VIEW account_view AS
SELECT * FROM account
WHERE balance < 200
WITH CHECK OPTION;
SELECT * FROM account_view;

INSERT INTO account_view VALUES(4, 'SUT', 500);