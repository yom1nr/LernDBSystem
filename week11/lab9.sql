CREATE TABLE members (
    id INT(5) NOT NULL,
    userid varchar(50) NOT NULL,
    password varchar(50) NOT NULL,
    name varchar(100) NULL,
    tel varchar(20) NULL,
    age INT NULL,
    activated varchar(1) NULL,
    salary INT NULL,
    promotion varchar(1) NULL,
    PRIMARY KEY (id)
);

INSERT INTO members (id, userid, password, name, tel, age, activated, salary, promotion) VALUES
(1, 'Husky', '1234', 'Malee flower', '044-111222', 33, 'Y', 10000, NULL),
(2, 'Bean', 'zxcvb', 'Green bean', '044-222333', 12, 'N', 20000, NULL),
(3, 'Tana', '1234qaz', 'Tana Khon', '044-555888', 18, 'Y', 30000, NULL);


DELIMITER //
CREATE TRIGGER before_members_insert
BEFORE INSERT ON members
FOR EACH ROW
BEGIN
    IF NEW.age >= 18 THEN
        SET NEW.activated = 'Y';
    ELSE
        SET NEW.activated = 'N';
    END IF;
END //
DELIMITER ;

-- ทดสอบคนที่ 1 (อายุ 25 ต้องได้ activated = 'Y')
INSERT INTO members (id, userid, password, name, tel, age, activated, salary, promotion) 
VALUES (4, 'std1', '0987', 'May May', '044-214445', 25, NULL, 10000, NULL);

-- ทดสอบคนที่ 2 (อายุ 10 ต้องได้ activated = 'N')
INSERT INTO members (id, userid, password, name, tel, age, activated, salary, promotion) 
VALUES (5, 'std2', '5555', 'Jan May', '044-334445', 10, NULL, 15000, NULL);


DELIMITER //
CREATE TRIGGER before_members_update
BEFORE UPDATE ON members
FOR EACH ROW
BEGIN
    -- เช็คเฉพาะกรณีที่มีการเปลี่ยนแปลงค่า salary
    IF NEW.salary > OLD.salary THEN
        SET NEW.promotion = 'Y';
    ELSEIF NEW.salary < OLD.salary THEN
        SET NEW.promotion = 'N';
    END IF;
END //
DELIMITER ;

UPDATE members SET salary = 20000 WHERE id = 1;

-- สร้างตารางสำหรับเก็บ Archive
CREATE TABLE membersArchives LIKE members;

DELIMITER //
CREATE TRIGGER before_members_delete
BEFORE DELETE ON members
FOR EACH ROW
BEGIN
    -- เอาข้อมูลทั้งหมดจาก OLD (ตัวที่กำลังจะถูกลบ) ไปยัดใส่ตาราง Archive
    INSERT INTO membersArchives (id, userid, password, name, tel, age, activated, salary, promotion)
    VALUES (OLD.id, OLD.userid, OLD.password, OLD.name, OLD.tel, OLD.age, OLD.activated, OLD.salary, OLD.promotion);
END //
DELIMITER ;

-- ดูข้อมูลในตารางหลัก (สมมติว่าเราจะเล็งลบ ID = 2 ของคุณ Bean)
SELECT * FROM members;

-- ดูข้อมูลในตาราง Archive (ตอนนี้ควรจะยังไม่มีข้อมูลอะไร)
SELECT * FROM membersArchives;

DELETE FROM members WHERE id = 2;

-- 1. ตรวจสอบตารางหลัก: ข้อมูล id = 2 ต้องหายไปแล้ว
SELECT * FROM members;

-- 2. ตรวจสอบตาราง Archive: ข้อมูล id = 2 ต้องมาโผล่ในนี้ครบทุกคอลัมน์!
SELECT * FROM membersArchives;