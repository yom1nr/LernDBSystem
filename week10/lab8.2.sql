DELIMITER //
CREATE PROCEDURE transfer_money (
    IN amount_transfer FLOAT,
    IN from_acc_num INT,
    IN to_acc_num INT
)
BEGIN
    DECLARE errorStatus BOOLEAN DEFAULT FALSE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET errorStatus = TRUE;
    DECLARE EXIT HANDLER FOR NOT FOUND SET errorStatus = TRUE;

    START TRANSACTION;

    UPDATE account 
    SET balance = balance - amount_transfer 
    WHERE account_number = from_acc_num;

    UPDATE account 
    SET balance = balance + amount_transfer 
    WHERE account_number = to_acc_num;

    IF errorStatus = TRUE THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //
DELIMITER ;
CALL transfer_money(10, 1, 3);
SELECT * FROM account;
CALL transfer_money(10, 1, 8);

DELIMITER //
CREATE PROCEDURE loan_money (
    IN loan_number INT,
    IN b_name CHAR(9),
    IN amount FLOAT,
    IN customer_name CHAR(9),
    IN acc_number INT
)
BEGIN
    DECLARE errorStatus BOOLEAN DEFAULT FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET errorStatus = TRUE;
    DECLARE EXIT HANDLER FOR NOT FOUND SET errorStatus = TRUE;

    START TRANSACTION;

    INSERT INTO loan (loan_number, branch_name, amount) 
    VALUES (loan_number, b_name, amount);

    INSERT INTO borrower (customer_name, loan_number) 
    VALUES (customer_name, loan_number);

    UPDATE branch 
    SET asset = asset - amount 
    WHERE branch_name = b_name;

    UPDATE account 
    SET balance = balance + amount 
    WHERE account_number = acc_number;

    IF errorStatus = TRUE THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //
DELIMITER ;

CALL loan_money(103, 'SUT', 20000, 'Som', 1);
SELECT * FROM account;

CALL loan_money(104, 'SUT', 20000, 'Som', 5);