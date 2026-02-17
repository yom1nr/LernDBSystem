use hospital;
CREATE TABLE Doctor (
	doctor_id INT NOT NULL,
    doctor_name VARCHAR(100),
    doctor_gender VARCHAR(10),
    ward VARCHAR(50),
    PRIMARY KEY (doctor_id)
);