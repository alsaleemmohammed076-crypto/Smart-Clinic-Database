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