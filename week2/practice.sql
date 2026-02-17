-- 1. สร้างตารางเปล่าๆ มีแค่ id
CREATE TABLE patientType (
    id INT
);

-- 2. เพิ่มคอลัมน์ชื่อ type_name
ALTER TABLE patientType ADD type_name VARCHAR(50);

-- 3. เปลี่ยนชื่อคอลัมน์จาก id เป็น type_id
ALTER TABLE patientType CHANGE id type_id INT;

-- 4. กำหนดให้ type_id เป็น Primary Key
ALTER TABLE patientType ADD PRIMARY KEY (type_id);

-- 5. กลับไปที่ตาราง Patient (จากข้อ 2.2) เพิ่มคอลัมน์ tid
ALTER TABLE Patient ADD tid INT;

-- 6. เชื่อม FK จาก Patient(tid) ไปหา patientType(type_id)
ALTER TABLE Patient 
ADD CONSTRAINT fk_patient_type 
FOREIGN KEY (tid) REFERENCES patientType(type_id);

-- 7. สร้างตาราง Disease เล่นๆ
CREATE TABLE Disease (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    level INT
);

-- 8. ลบตาราง Disease ทิ้ง
DROP TABLE Disease;