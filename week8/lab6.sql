CREATE DATABASE IF NOT EXISTS project_database;
USE project_database;

CREATE TABLE teacher (
    Teacher_id INT(11) PRIMARY KEY,
    Teacher_name VARCHAR(100),
    Gender VARCHAR(10),
    DOB DATE
);

INSERT INTO teacher (Teacher_id, Teacher_name, Gender, DOB) 
VALUES 
(1, 'Ann', 'Female', '1900-12-26'),
(2, 'Bird', 'Male', '1981-01-15');
USE project_database;
CREATE TABLE IF NOT EXISTS major (
    Major_id INT(11) PRIMARY KEY,
    Major_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS student (
    Student_id VARCHAR(8) PRIMARY KEY,
    Student_name VARCHAR(100),
    GPA DECIMAL(3,2),
    Gender VARCHAR(10),
    DOB DATE,
    Teacher_id INT(11),
    Major_id INT(11),
    FOREIGN KEY (Teacher_id) REFERENCES teacher(Teacher_id) ON UPDATE NO ACTION ON DELETE SET NULL,
    FOREIGN KEY (Major_id) REFERENCES major(Major_id) ON UPDATE NO ACTION ON DELETE SET NULL
);

INSERT INTO major (Major_id, Major_name) VALUES 
(1, 'CPE'), 
(2, 'ME'), 
(3, 'CE'), 
(4, 'TE');

INSERT INTO student (Student_id, Student_name, GPA, Gender, DOB, Teacher_id, Major_id) 
VALUES ('B1', 'Orange', 1.23, 'Female', '2020-03-02', 2, 4);