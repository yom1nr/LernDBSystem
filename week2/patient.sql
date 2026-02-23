use hospital;
CREATE TABLE Patient (
    patient_id INT NOT NULL,
    patient_name VARCHAR(100),
    doctor_id INT,
    PRIMARY KEY (patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);