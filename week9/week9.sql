DELIMITER //
CREATE PROCEDURE getAccountCustomer()
BEGIN
    SELECT * FROM account 
    NATURAL JOIN depositor 
    NATURAL JOIN customer;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getTotalAsset()
BEGIN
    SELECT SUM(asset) AS totalAsset 
    FROM branch;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE getAssetAvgBalance(
    IN b_name VARCHAR(50), 
    OUT b_asset FLOAT, 
    OUT avg_a_balance FLOAT
)
BEGIN
    SELECT asset INTO b_asset 
    FROM branch 
    WHERE branch_name = b_name;

    SELECT AVG(balance) INTO avg_a_balance 
    FROM account 
    WHERE branch_name = b_name;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE checkAccountStatus(
    IN a_number INT, 
    OUT a_status VARCHAR(20)
)
BEGIN
    DECLARE a_balance FLOAT DEFAULT 0;
    DECLARE total_loan FLOAT DEFAULT 0;

    SELECT balance INTO a_balance FROM account WHERE account_number = a_number;

    SELECT SUM(amount) INTO total_loan 
    FROM loan 
    NATURAL JOIN borrower 
    WHERE customer_name = (SELECT customer_name FROM depositor WHERE account_number = a_number);

    IF a_balance > total_loan THEN 
        SET a_status = 'OK';
    ELSEIF a_balance = total_loan THEN 
        SET a_status = 'Warning';
    ELSE 
        SET a_status = 'Critical';
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE InsertAccountCustomer(
    IN acc_num INT, IN b_name VARCHAR(50), IN bal FLOAT,
    IN c_name VARCHAR(50), IN c_street VARCHAR(50), IN c_city VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT CONCAT('Duplicate key (', acc_num, ') occurred') AS message;
    END;

    INSERT IGNORE INTO customer VALUES (c_name, c_street, c_city);
    INSERT INTO account VALUES (acc_num, b_name, bal);
    INSERT INTO depositor VALUES (c_name, acc_num);
END //
DELIMITER ;



DELIMITER //
CREATE FUNCTION GenAccountNumber(a_number INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a_number + 100;
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION BranchNameToID(b_name VARCHAR(50)) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE b_id VARCHAR(10);
    IF b_name = 'SUT' THEN 
        SET b_id = '0001';
    ELSEIF b_name = 'Mall' THEN 
        SET b_id = '0002';
    ELSE 
        SET b_id = 'Unknown';
    END IF;
    RETURN b_id;
END //
DELIMITER ;
