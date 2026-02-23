use hospital;
CREATE TABLE patientType (
    id INT
);
ALTER TABLE patientType ADD type_name VARCHAR(50);
ALTER TABLE patientType CHANGE id type_id INT;
ALTER TABLE patientType ADD PRIMARY KEY (type_id);
ALTER TABLE Patient ADD tid INT;
ALTER TABLE Patient 
ADD CONSTRAINT fk_patient_type 
FOREIGN KEY (tid) REFERENCES patientType(type_id);
CREATE TABLE Disease (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    level INT
);
DROP TABLE Disease;