USE myCountry;
CREATE TABLE Province (
Province_id VARCHAR(13) NOT NULL,
    Province_Name VARCHAR(100),
    Population INT,
    Location TINYTEXT,
    Provide_Size FLOAT,
    PRIMARY KEY (Province_id)
);
INSERT INTO Province (Province_id, Province_Name, Population, Location, Provide_Size) 
VALUES 
('1', 'Nakhon Ratchasima', 2582089, 'Northeast', 20494),
('2', 'Bangkok', 5494936, 'Central', 1568.7),
('3', 'Chiang Mai', 1792474, 'North', 20107.0),
('4', 'Phuket', 420212, 'South', 543.0);