use checkcinema;
CREATE TABLE OnAir_Movie (
    MovieID INT NOT NULL,
    MovieName VARCHAR(100),
    MovieGenre VARCHAR(50),
    MovieDuration INT,
    PRIMARY KEY (MovieID)
);

CREATE TABLE Theater (
    TheaterNumber INT NOT NULL,
    Capacity INT,
    PRIMARY KEY (TheaterNumber)
);

CREATE TABLE Schedule (
    ScheduleID INT NOT NULL,
    ScheduleDateTime DATETIME,
    MovieID INT,          -- เตรียมไว้ทำ FK ชี้ไปหาตารางหนัง
    TheaterNumber INT,    -- เตรียมไว้ทำ FK ชี้ไปหาตารางโรงหนัง
    PRIMARY KEY (ScheduleID),
    FOREIGN KEY (MovieID) REFERENCES OnAir_Movie(MovieID),
    FOREIGN KEY (TheaterNumber) REFERENCES Theater(TheaterNumber)
);

CREATE TABLE Ticket (
    TicketID INT NOT NULL,
    SeatNo VARCHAR(10),
    Price FLOAT,          -- หรือใช้ INT ก็ได้ครับ
    ScheduleID INT,       -- เตรียมไว้ทำ FK ชี้ไปหาตารางรอบหนัง
    PRIMARY KEY (TicketID),
    FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID)
);