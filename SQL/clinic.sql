CREATE DATABASE SmartClinic;

CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender ENUM('Male','Female'),
    BirthDate DATE,
    Phone VARCHAR(20) UNIQUE,
    Address VARCHAR(100)
);

CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2)
);

CREATE TABLE Doctor (
    EmployeeID INT PRIMARY KEY,
    Specialization VARCHAR(50),
    RoomNumber VARCHAR(10),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Receptionist (
    EmployeeID INT PRIMARY KEY,
    Shift VARCHAR(20),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status VARCHAR(20),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID)
);

CREATE TABLE Treatment (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    Diagnosis TEXT,
    Notes TEXT,
    AppointmentID INT UNIQUE,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);

CREATE TABLE Medicine (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100),
    Dosage VARCHAR(50),
    Price DECIMAL(8,2),
    TreatmentID INT,
    FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID)
);

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    Amount DECIMAL(8,2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(30),
    PatientID INT,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

INSERT INTO Patient(FirstName,LastName,Gender,BirthDate,Phone,Address) VALUES
('Mohammed','Alsaleem','Male','2002-01-10','01011111111','Cairo'),
('Mohammed','Alhumud','Male','2001-05-11','01022222222','Giza'),
('Adel','Almalki','Male','1998-08-20','01033333333','Alex'),
('Mona','Ibrahim','Female','2000-12-15','01044444444','Tanta'),
('Abdulrahman','Alabdulwahid','Male','1997-03-30','01055555555','Mansoura');

INSERT INTO Employee(Name,Phone,Email,Salary) VALUES
('Dr. Ahmed', '01111111111', 'ahmed@clinic.com', 20000),
('Dr. Sara', '01122222222', 'sara@clinic.com', 18000),
('Nour', '01133333333', 'nour@clinic.com', 6000),
('Mona', '01144444444', 'mona@clinic.com', 6500),
('Dr. Ali', '01155555555', 'ali@clinic.com', 22000),
('Dr. Omar', '01166666666', 'omar@clinic.com', 21000),
('Dr. Hany', '01177777777', 'hany@clinic.com', 19500),
('Salma', '01188888888', 'salma@clinic.com', 6200),
('Yasmine', '01199999999', 'yasmine@clinic.com', 6400),
('Laila', '01200000000', 'laila@clinic.com', 6100);

INSERT INTO Doctor VALUES
(1, 'Cardiology', 'A1'),
(2, 'Dentistry', 'B3'),
(5, 'Orthopedics', 'C2'),
(6, 'Dermatology', 'D1'),
(7, 'Neurology', 'E2');

INSERT INTO Receptionist VALUES
(3, 'Morning'),
(4, 'Evening'),
(8, 'Morning'),
(9, 'Evening'),
(10, 'Morning');

INSERT INTO Appointment (AppointmentDate,AppointmentTime,Status,PatientID,DoctorID) VALUES
('2026-08-01', '10:00:00', 'Completed', 1, 1),
('2026-08-01', '11:00:00', 'Completed', 2, 2),
('2026-08-02', '09:30:00', 'Pending', 3, 5),
('2026-08-03', '12:00:00', 'Completed', 4, 6),
('2026-08-04', '01:00:00', 'Pending', 5, 7);

INSERT INTO Treatment(Diagnosis,Notes,AppointmentID) VALUES
('Flu','Take rest',1),
('Tooth Pain','Need filling',2),
('Back Pain','Physiotherapy',3),
('Fracture','X-Ray',4),
('Checkup','Healthy',5);

INSERT INTO Medicine(MedicineName,Dosage,Price,TreatmentID) VALUES
('Panadol','2/day',50,1),
('Augmentin','3/day',120,1),
('Ibuprofen','1/day',70,2),
('Vitamin D','1/day',90,3),
('Calcium','1/day',110,4);

INSERT INTO Payment(Amount,PaymentDate,PaymentMethod,PatientID) VALUES
(300,'2026-08-01','Cash',1),
(450,'2026-08-01','Visa',2),
(350,'2026-08-02','Cash',3),
(700,'2026-08-03','Visa',4),
(250,'2026-08-04','Cash',5);

-- SELECT statement
SELECT * FROM Patient;

-- Another SELECT statement
SELECT FirstName, LastName, Phone FROM Patient;

-- JOIN query
SELECT
P.FirstName,
P.LastName,
D.Specialization,
A.AppointmentDate,
A.AppointmentTime
FROM Appointment A
JOIN Patient P ON A.PatientID = P.PatientID
JOIN Doctor D ON A.DoctorID = D.EmployeeID;

-- Nested query
SELECT Name FROM Employee WHERE EmployeeID 
IN (SELECT DoctorID FROM Appointment);

-- Aggregate function with GROUP BY
SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointment GROUP BY DoctorID;

-- UPDATE statement
UPDATE Patient SET Phone='01099999999' WHERE PatientID=1;

-- DELETE statement
DELETE FROM Payment WHERE PaymentID=5;

-- Create one VIEW
CREATE VIEW PatientAppointments AS
SELECT
P.FirstName,
P.LastName,
A.AppointmentDate,
A.AppointmentTime,
A.Status
FROM Patient P
JOIN Appointment A ON P.PatientID=A.PatientID;

-- Create one TRIGGER
DELIMITER $$
CREATE TRIGGER CheckPaymentAmount
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
IF NEW.Amount < 0 THEN
SET NEW.Amount = 0;
END IF;
END $$
DELIMITER ;