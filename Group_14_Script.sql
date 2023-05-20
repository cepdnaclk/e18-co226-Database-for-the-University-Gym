/*Group 14
  University Gym
  E/18/077
  E/18/147
  E/18/379*/

DROP DATABASE IF EXISTS PROJECT;
CREATE DATABASE PROJECT;
USE PROJECT;

/*Create all necessary tables*/
-- DROP TABLE IF EXISTS Student;
CREATE TABLE Student(
	RegistrationNumber VARCHAR(10) PRIMARY KEY, 
	Name VARCHAR(100), 
	EmailAddress VARCHAR(50));

-- DROP TABLE IF EXISTS StudentContactNumber;
CREATE TABLE StudentContactNumber(
	RegistrationNumber VARCHAR(10), 
	ContactNumber VARCHAR(15),
	PRIMARY KEY (RegistrationNumber, ContactNumber),
	index(RegistrationNumber));

-- DROP TABLE IF EXISTS SportsCaptain;
CREATE TABLE SportsCaptain(
	RegistrationNumber VARCHAR(10) PRIMARY KEY, 
	Sport VARCHAR(50),
	index(RegistrationNumber));
	
-- DROP TABLE IF EXISTS Visitor;
CREATE TABLE Visitor(
	VisitorID VARCHAR(10) PRIMARY KEY, 
	Name VARCHAR(100), 
	Description VARCHAR(200));

-- DROP TABLE IF EXISTS VisitorContactNumber;
CREATE TABLE VisitorContactNumber(
	VisitorID VARCHAR(10), 
	ContactNumber VARCHAR(15),
	PRIMARY KEY (VisitorID, ContactNumber),
	index(VisitorID));

-- DROP TABLE IF EXISTS GymnasiumStaff;
CREATE TABLE GymnasiumStaff(
	EmployeeID VARCHAR(10) PRIMARY KEY, 
	NationalID VARCHAR(15), 
	EmployeeName VARCHAR(100), 
	YearOfEmployment YEAR);

-- DROP TABLE IF EXISTS StaffContactNumber;
CREATE TABLE StaffContactNumber(
	EmployeeID VARCHAR(10), 
	ContactNumber VARCHAR(15),
	PRIMARY KEY (EmployeeID, ContactNumber),
	index(EmployeeID));

-- DROP TABLE IF EXISTS SportingCompetition;
CREATE TABLE SportingCompetition(
	CompetitionID VARCHAR(10) PRIMARY KEY, 
	NameOfCompetition VARCHAR(200), 
	Date DATE, 
	OrganizerDetails VARCHAR(500));

-- DROP TABLE IF EXISTS Achievements;
CREATE TABLE Achievements(
	AchievementID VARCHAR(10) PRIMARY KEY, 
	StudentRegistrationNumber VARCHAR(10), 
	CompetitionID VARCHAR(10), 
	Achievements VARCHAR(1000),
	index(StudentRegistrationNumber),
	index(CompetitionID));

-- DROP TABLE IF EXISTS GymEquipment;
CREATE TABLE GymEquipment(
	EquipmentID VARCHAR(10) PRIMARY KEY, 
	EquipmentType VARCHAR(100), 
	EquipmentDescription VARCHAR(200), 
	Availability VARCHAR(20));

-- DROP TABLE IF EXISTS GymEquipmentReservation;
CREATE TABLE GymEquipmentReservation(
	ReservationID VARCHAR(10) PRIMARY KEY, 
	StudentRegistrationNumber VARCHAR(10), 
	EquipmentID VARCHAR(10), 
	ReservedDateTime DATETIME,
	ReturnedDateTime DATETIME,
	index(StudentRegistrationNumber),
	index(EquipmentID));
	
-- DROP TABLE IF EXISTS SportingArena;
CREATE TABLE SportingArena(
	ArenaID VARCHAR(10) PRIMARY KEY, 
	ArenaType VARCHAR(100), 
	ArenaDescription VARCHAR(200), 
	Availability VARCHAR(20));

-- DROP TABLE IF EXISTS StadiumReservation;
CREATE TABLE StadiumReservation(
	ReservationID VARCHAR(10) PRIMARY KEY, 
	ArenaID VARCHAR(10), 
	VisitorID VARCHAR(10), 
	StudentRegistrationNumber VARCHAR(10), 
	ReservedDateTime DATETIME, 
	ReturnedDateTime DATETIME,
	index(ArenaID),
	index(VisitorID),
	index(StudentRegistrationNumber));
	
-- DROP TABLE IF EXISTS Gymstaff_Student;
CREATE TABLE Gymstaff_Student(
	ReferenceID VARCHAR(10) PRIMARY KEY,
	EmployeeID VARCHAR(10),
	StudentRegistrationNumber VARCHAR(10),
	index(EmployeeID),
	index(StudentRegistrationNumber));
	
-- DROP TABLE IF EXISTS Gymstaff_SportsCaptain;
CREATE TABLE Gymstaff_SportsCaptain(
	ReferenceID VARCHAR(10) PRIMARY KEY,
	EmployeeID VARCHAR(10),
	StudentRegistrationNumber VARCHAR(10),
	index(EmployeeID),
	index(StudentRegistrationNumber));
	
-- DROP TABLE IF EXISTS Gymstaff_Visitor;
CREATE TABLE Gymstaff_Visitor(
	ReferenceID VARCHAR(10) PRIMARY KEY,
	EmployeeID VARCHAR(10),
	VisitorID VARCHAR(10),
	index(EmployeeID),
	index(VisitorID));
	
-- DROP TABLE IF EXISTS Student_SportingCompetition;
CREATE TABLE Student_SportingCompetition(
	ReferenceID VARCHAR(10) PRIMARY KEY,
	StudentRegistrationNumber VARCHAR(10),
	CompetitionID VARCHAR(10),
	index(StudentRegistrationNumber),
	index(CompetitionID));

/*Triggers*/
/*A trigger to update the availability of gym equipments*/
CREATE TRIGGER GymEqp1
AFTER INSERT ON GymEquipmentReservation
FOR EACH ROW
UPDATE GymEquipment
SET Availability = 'Occupied'
WHERE EquipmentID = NEW.EquipmentID;

/*A trigger to update the availability of gym equipments*/
DELIMITER //
CREATE TRIGGER GymEqp2
AFTER UPDATE ON GymEquipmentReservation
FOR EACH ROW
BEGIN
    IF NEW.ReturnedDateTime IS NOT NULL THEN    
		UPDATE GymEquipment
		SET GymEquipment.Availability = 'Vacant'
		WHERE GymEquipment.EquipmentID = NEW.EquipmentID;
    END IF;
END //
DELIMITER ;

/*A trigger to update the availability of sporting arenas*/
CREATE TRIGGER ARENA_RES
AFTER INSERT ON StadiumReservation
FOR EACH ROW
UPDATE SportingArena
SET Availability = 'Occupied'
WHERE ArenaID = NEW.ArenaID;

/*A trigger to update the availability of sporting arenas*/
DELIMITER //
CREATE TRIGGER ARENA_RET
AFTER UPDATE ON StadiumReservation
FOR EACH ROW
BEGIN
	IF NEW.ReturnedDateTime IS NOT NULL THEN
		UPDATE SportingArena
		SET SportingArena.Availability = 'Vacant'
		WHERE SportingArena.ArenaID = NEW.ArenaID;
	END IF;
END //
DELIMITER ;


/*PROCEDURES TO POPULATE THE TABLES*/
/*Insert data into the student table*/
DELIMITER //
CREATE PROCEDURE InsertDataStudent (IN RegNum VARCHAR(10), IN Name VARCHAR(100), IN Email VARCHAR(50), IN CONTACT1 VARCHAR(15), IN CONTACT2 VARCHAR(15), IN CONTACT3 VARCHAR(15))
BEGIN
	INSERT INTO Student (RegistrationNumber, Name, EmailAddress) VALUES (RegNum, Name, Email);
	IF CONTACT1 IS NOT NULL THEN
		INSERT INTO StudentContactNumber (RegistrationNumber, ContactNumber) VALUES (RegNum, CONTACT1);
	END IF;
	IF CONTACT2 IS NOT NULL THEN
		INSERT INTO StudentContactNumber (RegistrationNumber, ContactNumber) VALUES (RegNum, CONTACT2);
	END IF;
	IF CONTACT3 IS NOT NULL THEN
		INSERT INTO StudentContactNumber (RegistrationNumber, ContactNumber) VALUES (RegNum, CONTACT3);
	END IF;
END //
DELIMITER ;

/*Insert data into the sports captain detail*/
DELIMITER //
CREATE PROCEDURE InsertDataSportsCaptain (IN RegNum VARCHAR(10), IN Sport VARCHAR(50))
BEGIN
	INSERT INTO SportsCaptain (RegistrationNumber, Sport) VALUES (RegNum, Sport);
END //
DELIMITER ;

/*Insert data into the staff table*/
DELIMITER //
CREATE PROCEDURE InsertDataStaff (IN EmployeeID VARCHAR(10) ,IN NationalID VARCHAR(15), IN EmployeeName VARCHAR(100), IN YearOfEmployment YEAR, IN CONTACT1 VARCHAR(15), IN CONTACT2 VARCHAR(15), IN CONTACT3 VARCHAR(15))
BEGIN
	INSERT INTO GymnasiumStaff (EmployeeID, NationalID, EmployeeName, YearOfEmployment) VALUES (EmployeeID, NationalID, EmployeeName, YearOfEmployment);
	IF CONTACT1 IS NOT NULL THEN
		INSERT INTO StaffContactNumber (EmployeeID, ContactNumber) VALUES (EmployeeID, CONTACT1);
	END IF;
	IF CONTACT2 IS NOT NULL THEN	
		INSERT INTO StaffContactNumber (EmployeeID, ContactNumber) VALUES (EmployeeID, CONTACT2);
	END IF;
	IF CONTACT3 IS NOT NULL THEN	
		INSERT INTO StaffContactNumber (EmployeeID, ContactNumber) VALUES (EmployeeID, CONTACT3);
	END IF;
END //
DELIMITER ;

/*Insert data into the visitor table*/
DELIMITER //
CREATE PROCEDURE InsertDataVisitor (IN VisitorID VARCHAR(10), IN Name VARCHAR(100), IN Description VARCHAR(200), IN CONTACT1 VARCHAR(15), IN CONTACT2 VARCHAR(15), IN CONTACT3 VARCHAR(15))
BEGIN
	INSERT INTO Visitor (VisitorID, Name, Description) VALUES (VisitorID, Name, Description);
	IF CONTACT1 IS NOT NULL THEN
		INSERT INTO VisitorContactNumber (VisitorID, ContactNumber) VALUES (VisitorID, CONTACT1);
	END IF;
	IF CONTACT2 IS NOT NULL THEN
		INSERT INTO VisitorContactNumber (VisitorID, ContactNumber) VALUES (VisitorID, CONTACT2);
	END IF;
	IF CONTACT3 IS NOT NULL THEN
		INSERT INTO VisitorContactNumber (VisitorID, ContactNumber) VALUES (VisitorID, CONTACT3);
	END IF;
END //
DELIMITER ;

/*Insert data into the gym equipment table*/
DELIMITER //
CREATE PROCEDURE InsertGymEquipment (IN EquipmentID VARCHAR (10), IN EquipmentType VARCHAR(100), IN EquipmentDescription VARCHAR (200), IN Availability VARCHAR(20))
BEGIN
	INSERT INTO GymEquipment (EquipmentID, EquipmentType, EquipmentDescription, Availability) VALUES (EquipmentID, EquipmentType, EquipmentDescription, Availability);
END //
DELIMITER ;

/*Insert data into the gym equipment reservation table*/
DELIMITER //
CREATE PROCEDURE InsertGymEquipmentReservation (IN inReservationID VARCHAR(10), IN StudentRegistrationNumber VARCHAR(10), IN EquipmentID VARCHAR(10), IN ReservedDateTime DATETIME, IN ReturnedDateTime DATETIME)  
BEGIN
	INSERT INTO GymEquipmentReservation (ReservationID, StudentRegistrationNumber, EquipmentID,ReservedDateTime, ReturnedDateTime) VALUES (inReservationID, StudentRegistrationNumber, EquipmentID , ReservedDateTime, ReturnedDateTime);
END //
DELIMITER ;

/*Insert the returned date and time*/
DELIMITER //
CREATE PROCEDURE GymEquipmentReturn (IN ResID VARCHAR(10), IN Returned DATETIME)
BEGIN
	UPDATE GymEquipmentReservation
	SET ReturnedDateTime = Returned
	WHERE ReservationID = ResID;
END //
DELIMITER ;

/*Insert data into the sporting arena table*/
DELIMITER //
CREATE PROCEDURE InsertSportingArena (IN ArenaID VARCHAR(10), IN ArenaType VARCHAR(100), IN ArenaDescription VARCHAR(100), IN Availability VARCHAR(20))
BEGIN
	INSERT INTO SportingArena (ArenaID, ArenaType, ArenaDescription, Availability) VALUES (ArenaID, ArenaType, ArenaDescription, Availability);
END //
DELIMITER ;

/*Insert data into the sporting arena reservation table*/
DELIMITER //
CREATE PROCEDURE InsertStadiumReservation (IN ReservationID VARCHAR (10), IN ArenaID VARCHAR (10), IN VisitorID VARCHAR(10) , IN StudentRegistrationNumber VARCHAR(10), IN ReservedDateTime DATETIME, IN ReturnedDateTime DATETIME)  
BEGIN
	INSERT INTO StadiumReservation (ReservationID,  ArenaID ,  VisitorID  , StudentRegistrationNumber,  ReservedDateTime , ReturnedDateTime) VALUES ( ReservationID,  ArenaID ,  VisitorID  , StudentRegistrationNumber,  ReservedDateTime , ReturnedDateTime);
END //
DELIMITER ;

/*Insert the returned date and time*/
DELIMITER //
CREATE PROCEDURE ArenaReturn (IN ResID VARCHAR(10), IN Returned DATETIME)
BEGIN
	UPDATE StadiumReservation
	SET ReturnedDateTime = Returned
	WHERE ReservationID = ResID;
END //
DELIMITER ;

/*Insert data into the sporting competition table*/
DELIMITER //
CREATE PROCEDURE InsertSportingCompetition (IN CompetitionID VARCHAR (10), IN NameOfCompetition VARCHAR (100), IN Date DATE, IN OrganizerDetails VARCHAR (200))
BEGIN
	INSERT INTO SportingCompetition (CompetitionID, NameOfCompetition, Date, OrganizerDetails) VALUES (CompetitionID, NameOfCompetition, Date, OrganizerDetails);
END //
DELIMITER ;

/*Insert data into the achievements table*/
DELIMITER //
CREATE PROCEDURE InsertAchievements (IN AchievementID VARCHAR(10), IN StudentRegistrationNumber VARCHAR (10),IN  CompetitionID VARCHAR (10) , IN Achievements VARCHAR(1000))
BEGIN 
	INSERT INTO Achievements (AchievementID,  StudentRegistrationNumber , CompetitionID , Achievements ) VALUES (AchievementID,  StudentRegistrationNumber , CompetitionID , Achievements);
END //
DELIMITER ;






/*Insert data into the Gymstaff_Student table*/
DELIMITER //
CREATE PROCEDURE InsertGymstaff_Student (IN ReferenceID VARCHAR(10), IN EmployeeID VARCHAR(10),IN  StudentRegistrationNumber VARCHAR(10))
BEGIN 
	INSERT INTO Gymstaff_Student (ReferenceID, EmployeeID , StudentRegistrationNumber) VALUES (ReferenceID,  EmployeeID, StudentRegistrationNumber);
END //
DELIMITER ;

/*Insert data into the Gymstaff_SportsCaptain table*/
DELIMITER //
CREATE PROCEDURE InsertGymstaff_SportsCaptain (IN ReferenceID VARCHAR(10), IN EmployeeID VARCHAR(10), IN  StudentRegistrationNumber VARCHAR(10))
BEGIN 
	INSERT INTO Gymstaff_SportsCaptain (ReferenceID, EmployeeID, StudentRegistrationNumber) VALUES (ReferenceID,  EmployeeID, StudentRegistrationNumber);
END //
DELIMITER ;

/*Insert data into the Gymstaff_Visitor table*/
DELIMITER //
CREATE PROCEDURE InsertGymstaff_Visitor (IN ReferenceID VARCHAR(10), IN EmployeeID VARCHAR(10), IN  VisitorID VARCHAR(10))
BEGIN 
	INSERT INTO Gymstaff_Visitor (ReferenceID, EmployeeID, VisitorID) VALUES (ReferenceID, EmployeeID, VisitorID);
END //
DELIMITER ;

/*Insert data into the Student_SportingCompetition table*/
DELIMITER //
CREATE PROCEDURE InsertStudent_SportingCompetition (IN ReferenceID VARCHAR(10), IN StudentRegistrationNumber VARCHAR(10), IN  CompetitionID VARCHAR(10))
BEGIN 
	INSERT INTO Student_SportingCompetition (ReferenceID, StudentRegistrationNumber, CompetitionID) VALUES (ReferenceID, StudentRegistrationNumber, CompetitionID);
END //
DELIMITER ;


CALL InsertDataStudent('E/17/169', 'KALPAGE R.F.D','e18169@eng.pdn.ac.lk', '0726954541','08437788745','0857523745');
CALL InsertDataStudent('E/18/356', 'SUNITH K.Q.S','e18356@eng.pdn.ac.lk', '07264527522', null, null);
CALL InsertDataStudent('E/18/549', 'WELLAGE HJG','e18549@eng.pdn.ac.lk', '072547575', null, null);
CALL InsertDataStudent('E/17/546', 'UPALI KAJ','e174546@eng.pdn.ac.lk', '0742172257', '08122574425', null);
CALL InsertDataStudent('E/18/564', 'ABEYGUNASEKARA OA','e18564@eng.pdn.ac.lk', '0727524752', null, null);
CALL InsertDataStudent('E/16/546', 'DEVAL PO','e18546@eng.pdn.ac.lk', null, null, '037520422');
CALL InsertDataStudent('E/18/548', 'PUNYASIRI UKA','e15428@eng.pdn.ac.lk', '072694242', null, null);
CALL InsertDataStudent('E/18/456', 'NISANKA QT','e18785@eng.pdn.ac.lk', '0724527452', null, null);
CALL InsertDataStudent('E/18/541', 'RAMANAN IU','e17235@eng.pdn.ac.lk', '075442727', null, null);
CALL InsertDataStudent('E/17/356', 'WIJEPALA MNN','e18635@eng.pdn.ac.lk', '072527725', null, '08437523745');
CALL InsertDataStudent('E/16/154', 'JAYAKODY YWT','e1214@eng.pdn.ac.lk', '07272572', null, null);
CALL InsertDataStudent('E/16/144', 'AHMED KA','e1575@eng.pdn.ac.lk', '07275277', null, '0752572727');
CALL InsertDataStudent('E/16/153', 'MAHMOOD Y','e12452@eng.pdn.ac.lk', '075324074527', null, null);
CALL InsertDataStudent('E/17/597', 'APONSO KAS','e14525@eng.pdn.ac.lk', '07432752', null, null);
CALL InsertDataStudent('E/18/763', 'RATHNAYAKA KA','e1725@eng.pdn.ac.lk', '0757237427', null, null);
CALL InsertDataStudent('E/18/123', 'KARUNATILAKE YU','e1855@eng.pdn.ac.lk', '07254327524', null, '0527477752');
CALL InsertDataStudent( 'S/18/564', 'KARUNATILAKE SDF','fgs@gamil.com', '07254327524', null, '0527477752');
CALL InsertDataStudent( 'S/18/154', 'PERERA DSF','fssgfdas@gamil.com', '07254327524', null, '0527477752');
CALL InsertDataStudent( 'S/18/541', 'KUSUMSIRI MJH','dasgfd@gamil.com', '07254327524', null, '0527477752');
CALL InsertDataStudent( 'S/18/542', 'ARIYARATNE T','dfa@gamil.com', '07254327524', null, '0527477752');
CALL InsertDataStudent( 'S/18/546', 'DAYA NH','dfsadsf@gamil.com', '07254327524', null, '0527477752');


CALL InsertDataSportsCaptain ('E/18/763', 'Cricket');
CALL InsertDataSportsCaptain ('E/17/546', 'Rugby');
CALL InsertDataSportsCaptain ('E/17/597', 'FootBall');
CALL InsertDataSportsCaptain ('E/16/144', 'Athletics');
CALL InsertDataSportsCaptain ('E/16/154', 'Swimming');
CALL InsertDataSportsCaptain ('E/16/546', 'Karate');
CALL InsertDataSportsCaptain ('E/18/549', 'Badminton');
CALL InsertDataSportsCaptain ('E/17/169', 'Hockey');
CALL InsertDataSportsCaptain ('E/17/356', 'Baseball');
CALL InsertDataSportsCaptain ('E/18/123', 'Boxing');
CALL InsertDataSportsCaptain ('S/18/154', 'Rowing');
CALL InsertDataSportsCaptain ('S/18/542', 'Sailing');
CALL InsertDataSportsCaptain ('S/18/546', 'Water polo');


CALL InsertGymEquipment ('EQP2', 'Basket ball','Belongs to the basket ball team', 'Vacant');
CALL InsertGymEquipment ('EQP3', 'Badminton Racket','Nike', 'Vacant');
CALL InsertGymEquipment ('EQP4', 'Badminton Racket','Nike', 'Vacant');
CALL InsertGymEquipment ('EQP5', 'Badminton Racket','To be repaired', 'Vacant');
CALL InsertGymEquipment ('EQP6', 'Badminton Racket','Nike', 'Vacant');
CALL InsertGymEquipment ('EQP7', 'Badminton Racket','Soft', 'Vacant');
CALL InsertGymEquipment ('EQP8', 'Basket ball','Belongs to the basket ball team', 'Vacant');
CALL InsertGymEquipment ('EQP9', 'Basket ball','Belongs to the basket ball team', 'Vacant');
CALL InsertGymEquipment ('EQP10', 'Football','Old one', 'Vacant');
CALL InsertGymEquipment ('EQP11', 'Football','', 'Vacant');
CALL InsertGymEquipment ('EQP12', 'Football',null, 'Vacant');
CALL InsertGymEquipment ('EQP13', 'Football',null, 'Vacant');
CALL InsertGymEquipment ('EQP14', 'Cricket Bat',null, 'Vacant');
CALL InsertGymEquipment ('EQP15', 'Cricket Bat','Broke by a student', 'Vacant');
CALL InsertGymEquipment ('EQP16', 'Cricket Bat',null, 'Vacant');
CALL InsertGymEquipment ('EQP17', 'Cricket Bat','To be seasoned', 'Vacant');
CALL InsertGymEquipment ('EQP18', 'Dumbell 5Kg',null, 'Vacant');
CALL InsertGymEquipment ('EQP19', 'Dumbell 5Kg',null, 'Vacant');
CALL InsertGymEquipment ('EQP20', 'Dumbell 5Kg',null, 'Vacant');
CALL InsertGymEquipment ('EQP21', 'Dumbell 5Kg',null, 'Vacant');


CALL InsertGymEquipmentReservation ('R11', 'E/17/169', 'EQP2',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R12', 'E/18/356', 'EQP3',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R13', 'E/18/549', 'EQP4',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R14', 'E/17/546', 'EQP5',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R15', 'E/18/564', 'EQP6',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R16', 'E/16/546', 'EQP7',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R17', 'E/18/548', 'EQP8',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R18', 'E/18/456', 'EQP9',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R19', 'E/18/541', 'EQP10',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R20', 'E/17/356', 'EQP11',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R21', 'E/16/154', 'EQP12',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R22', 'E/16/144', 'EQP13',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R23', 'E/16/153', 'EQP14',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R24', 'E/17/597', 'EQP15',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R25', 'E/18/763', 'EQP16',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R26', 'E/18/123', 'EQP17',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R27', 'S/18/564', 'EQP18',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R28', 'S/18/154', 'EQP19',CURRENT_TIMESTAMP(), null);
CALL InsertGymEquipmentReservation ('R29', 'S/18/546', 'EQP20',CURRENT_TIMESTAMP(), null);

CALL InsertDataVisitor ('V21', 'Latha Walpola', 'Rvdec Music concert Organizer', '08152542', '0773646315', null);
CALL InsertDataVisitor ('V2', 'Saveen Amarasekara', 'Master in charge of Baseeball TCK', '08452544124', '0773646315', null);
CALL InsertDataVisitor ('V3', 'Suneshka Amarashinghe', 'Master in charge of Athletics TCK', '082577452', '0773646315', null);
CALL InsertDataVisitor ('V4', 'Indeewari Gunewardena', 'Master in charge of Football TCK', '08452045520', '0773646315', null);
CALL InsertDataVisitor ('V5', 'Supun Dharmagunawardhana', 'Master in charge of Rugby TCK', '08154201542', '0773646315', null);
CALL InsertDataVisitor ('V6', 'Duminda Sumangala', 'Master in charge of Hockey TCK', '542054452', '0773646315', null);
CALL InsertDataVisitor ('V7', 'Salitha Herath', 'Principal-Nugawela Central', '042540', '0773646315', null);
CALL InsertDataVisitor ('V8', 'Sanjeewan Jayakody', 'Principal-Hillwood Collge', null, '077304245', null);
CALL InsertDataVisitor ('V9', 'Gajanayake Amaradeva', 'Principal-Bahayagiri Vidyalaya', '0812223209', '0774021', null);
CALL InsertDataVisitor ('V10', 'Tennakoon Addararachchi', 'Principal-Upahara Vidyalaya', '0812223209', '0774204015', null);
CALL InsertDataVisitor ('V11', 'Gamalath Rahula', 'Principal-Vidyartha College', null, '0774040315', null);
CALL InsertDataVisitor ('V12', 'Preyalal Anula', 'Principal-Mahamaya College', '0812223209', '0773646315',4040240);
CALL InsertDataVisitor ('V13', 'Priyanath Sumangala', null, '0812223209', '0773646315', 404021);
CALL InsertDataVisitor ('V14', 'Salitha Herath', null, '0812223209', null, null);
CALL InsertDataVisitor ('V15', 'Niwunhalla Wimalaratne', null, '0812223209', '0773646315', 41040240);
CALL InsertDataVisitor ('V16', 'Gunarathna Paranavithana', null, '0812223209', '0773646315', null);
CALL InsertDataVisitor ('V17', 'Chinthaka Wimaladharma', null, '0812223209', '0773646315', 04140420);
CALL InsertDataVisitor ('V18', 'Shashiman Chandrasiri', null, '0812223209', null, null);
CALL InsertDataVisitor ('V19', 'Sumudu Fonseca', null, '0812223209', null, null);
CALL InsertDataVisitor ('V20', 'Viranga Niroshan', null, '0812223209', null, null);

CALL InsertSportingArena ('A2', 'Badminton Court1', null, 'vacant');
CALL InsertSportingArena ('A3', 'Badminton Court2', null,  'vacant');
CALL InsertSportingArena ('A4', 'Badminton Court3', null,  'vacant');
CALL InsertSportingArena ('A5', 'Tennis Court1', null,  'vacant');
CALL InsertSportingArena ('A6', 'Tennis Court2', null, 'vacant');
CALL InsertSportingArena ('A7', 'Tennis Court3', 'Repair net', 'vacant');
CALL InsertSportingArena ('A8', 'Tennis Court4', null, 'vacant');
CALL InsertSportingArena ('A9', 'Cricket Grounds', 'Cut grass on 12th April', 'vacant');
CALL InsertSportingArena ('A10', 'Rugby/Football Grounds', 'Cut grass on 12th April', 'vacant');
CALL InsertSportingArena ('A11', 'Swimming Pool', 'Clean pool on 23th Feb', 'vacant');
CALL InsertSportingArena ('A12', 'Gym', null,  'vacant');
CALL InsertSportingArena ('A13', 'Table Tennis', null,  'vacant');
CALL InsertSportingArena ('A14', 'Gynasium Workout Area', 'Count the dumbells', 'vacant');
CALL InsertSportingArena ('A15', 'Athletic Grounds', null,  'vacant');

CALL InsertStadiumReservation ('R2', 'A2', 'V2', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R3', 'A3', 'V3', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R4', 'A4', 'V4', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R5', 'A5', 'V5', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R6', 'A6', 'V6', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R7', 'A7', 'V7', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R8', 'A8', 'V8', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R9', 'A9', 'V11', null, CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R10', 'A10',null,  'E/17/169',  CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R11', 'A11',null,  'E/16/546',   CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R12', 'A12', null, 'S/18/564',  CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R13', 'A13',null,  'E/18/549',  CURRENT_TIMESTAMP(), null);
CALL InsertStadiumReservation ('R14', 'A14',null,  'E/18/763',  CURRENT_TIMESTAMP(), null);


CALL InsertDataStaff ('EMP1', '820782497V', 'BANDARA D.S.', '2005', '0717894564', '0812944564', null);
CALL InsertDataStaff ('EMP2', '840749766V', 'PERERA K.S.', '2008', '0717846464', '0812216564', '0717667895');
CALL InsertDataStaff ('EMP3', '880749757V', 'HERATH J.S.', '2012', '0717899864', '0812285564', null);
CALL InsertDataStaff ('EMP4', '926872497V', 'WIJEPALA S.', '2015', '0717784564', '0812235564', null);
CALL InsertDataStaff ('EMP5', '720798497V', 'BANDARA N.', '2005', '0717855564', null, null);
CALL InsertDataStaff ('EMP6', '910702497V', 'WIMALARATHNE R.', '2004', '0777894564', '0142294564', '0857647895');
CALL InsertDataStaff ('EMP7', '880798797V', 'AHMED T.', '2003', '0717894544', '0812294324', '0717647955');
CALL InsertDataStaff ('EMP8', '850702497V', 'ARIYARATNE P', '1999', '0751894564', null, null);
CALL InsertDataStaff ('EMP9', '870702497V', 'PERERA W.R.', '2003', '0717884564', null, null);
CALL InsertDataStaff ('EMP10', '929802497V', 'JAYASURIYA T.U.', '2017', '0117894974', '0811494564', '0735647895');
CALL InsertDataStaff ('EMP11', '720702497V', 'WIJEPALA I.O.', '2018', '0418794564', '0812274564', '0719247895');
CALL InsertDataStaff ('EMP12', '730702497V', 'KUMARA E.T.', '2014', '0817894564', '0812294234', '0717645495');
CALL InsertDataStaff ('EMP13', '740702497V', 'JAYAWARDANA D.F.', '2012', '0917894564', '0818994564', '0367647895');
CALL InsertDataStaff ('EMP14', '750702497V', 'SANGAKKARA T.S.', '2001', '0017894564', '0812984564', '0715647895');
CALL InsertDataStaff ('EMP15', '820702497V', 'WIJEPALA Y.S.', '2002', '0117894564', null, null);
CALL InsertDataStaff ('EMP16', '920702497V', 'MALINGA D.R.', '2003', '0617894564', '0812874564', '0717614895');
CALL InsertDataStaff ('EMP17', '930702497V', 'KUSUMSIRI U.I.', '2004', '0517894564', null, null);
CALL InsertDataStaff ('EMP18', '940702497V', 'MENDIS D.S.', '2006', '0417894564', null, null);
CALL InsertDataStaff ('EMP19', '95702497V', 'WIJEPALA P.S.', '2007', '0278942564', null, null);
CALL InsertDataStaff ('EMP20', '960702497V', 'AHMED E.G.', '2008', '0737894564', '0742294564', null);

/*Sporting Competitions*/
CALL InsertSportingCompetition ('C1', 'Sri Lanka University Games', '2022-10-10', 'Organized by the UGC');
CALL InsertSportingCompetition ('C2', 'Inter Faculty Meet', '2022-11-10', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C3', 'All Island Athletics Meet', '2022-04-20', 'Organized by the UGC');
CALL InsertSportingCompetition ('C4', 'Word University Games Trial- Swimming', '2022-03-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C5', 'Sri Lanka University Games- Athletics', '2022-03-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C6', 'Sri Lanka University Games- Hockey', '2022-04-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C7', 'Sri Lanka University Games- Rugger', '2022-03-27', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C8', 'Sri Lanka University Games- Cricket', '2022-05-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C9', 'Sri Lanka University Games- Tennis', '2022-05-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C10', 'Sri Lanka University Games- Badminton', '2022-07-10', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C11', 'Sri Lanka University Games- Table tennis', '2022-04-17', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C12', 'Sports Meet- Faculty of Engineering', '2022-05-10', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C13', 'Sports Meet- Faculty of Arts', '2022-05-12', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C14', 'Sports Meet- Faculty of Physical Science', '2022-05-13', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C15', 'Sports Meet- Faculty of Dental Sciences', '2022-05-20', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C16', 'Sports Meet- Faculty of Agriculture', '2022-05-27', 'Organized by the Physical Education Department - UOP');
CALL InsertSportingCompetition ('C17', 'Sri Lanka University Games- Boxing', '2022-03-30', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C18', 'Sri Lanka University Games- Base Ball', '2022-05-04', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C19', 'Sri Lanka University Games- Chess', '2022-03-09', 'Organized by the Sports Ministry');
CALL InsertSportingCompetition ('C20', 'Sri Lanka University Games- Carom', '2022-03-14', 'Organized by the Sports Ministry');

/*Achievements*/
CALL InsertAchievements ('A1', 'E/17/169', 'C1', 'Best sports man');
CALL InsertAchievements ('A2', 'E/18/356', 'C1', '1st in the 100m flat race');
CALL InsertAchievements ('A3', 'E/18/549', 'C7', 'Member of the rugger team that were first runners up');
CALL InsertAchievements ('A4', 'E/17/546', 'C17', 'Won the title of "Best boxer"');
CALL InsertAchievements ('A5', 'E/16/546', 'C20', 'Won 2nd place');
CALL InsertAchievements ('A6', 'E/16/144', 'C9', '1st place- Womens Doubles');
CALL InsertAchievements ('A7', 'E/16/153', 'C5', 'Member of the relay team that placed 1st in the 4x100m relay - Mens');
CALL InsertAchievements ('A8', 'E/17/597', 'C1', 'Won the title of "champion swimmer"');
CALL InsertAchievements ('A9', 'E/18/763', 'C16', '1st place in the 200m butterfly event- Swimmimng');
CALL InsertAchievements ('A10', 'E/18/123', 'C10', '3rd place- Singles Mens');
CALL InsertAchievements ('A11', 'S/18/564', 'C4', '2nd place in the 100m back stroke');
CALL InsertAchievements ('A12', 'S/18/154', 'C3', 'Member of the 4x100m relay team (Boys) - 3rd place');
CALL InsertAchievements ('A13', 'S/18/541', 'C11', 'Winner of the womens single');
CALL InsertAchievements ('A14', 'S/18/542', 'C1', 'Awarded the prize for best athlete');
CALL InsertAchievements ('A15', 'S/18/546', 'C2', '2nd place 200m flat race- Womens');
CALL InsertAchievements ('A16', 'E/16/546', 'C2', '1st place high jump- Mens');
CALL InsertAchievements ('A17', 'E/16/546', 'C19', '1st place- Womens');
CALL InsertAchievements ('A18', 'E/18/549', 'C4', '1st place - 50m Breast sroke - womens');
CALL InsertAchievements ('A19', 'E/18/549', 'C10', '1st place- Singles- Men');
CALL InsertAchievements ('A20', 'E/18/549', 'C18', 'Won the award for the player of the tournament');

CALL InsertGymstaff_Student ('REF1', 'EMP1', 'E/17/169');
CALL InsertGymstaff_Student ('REF2', 'EMP1', 'E/18/356');
CALL InsertGymstaff_Student ('REF3', 'EMP3', 'E/18/549');
CALL InsertGymstaff_Student ('REF4', 'EMP1', 'E/17/546');
CALL InsertGymstaff_Student ('REF5', 'EMP4', 'E/18/564');
CALL InsertGymstaff_Student ('REF6', 'EMP5', 'E/16/546');
CALL InsertGymstaff_Student ('REF7', 'EMP3', 'E/18/548');
CALL InsertGymstaff_Student ('REF8', 'EMP9', 'E/18/456');
CALL InsertGymstaff_Student ('REF9', 'EMP10', 'E/18/541');
CALL InsertGymstaff_Student ('REF10', 'EMP6', 'E/17/356');
CALL InsertGymstaff_Student ('REF11', 'EMP7', 'E/16/154');
CALL InsertGymstaff_Student ('REF12', 'EMP9', 'E/16/144');
CALL InsertGymstaff_Student ('REF13', 'EMP8', 'E/16/153');
CALL InsertGymstaff_Student ('REF14', 'EMP8', 'E/17/597');
CALL InsertGymstaff_Student ('REF15', 'EMP2', 'E/18/763');
CALL InsertGymstaff_Student ('REF16', 'EMP8', 'E/18/123');
CALL InsertGymstaff_Student ('REF17', 'EMP1', 'S/18/564');
CALL InsertGymstaff_Student ('REF18', 'EMP2', 'S/18/154');
CALL InsertGymstaff_Student ('REF19', 'EMP7', 'S/18/541');
CALL InsertGymstaff_Student ('REF20', 'EMP14', 'S/18/546');

CALL InsertGymstaff_Visitor ('REF2', 'EMP3', 'V2');
CALL InsertGymstaff_Visitor ('REF3', 'EMP2', 'V3');
CALL InsertGymstaff_Visitor ('REF4', 'EMP5', 'V4');
CALL InsertGymstaff_Visitor ('REF5', 'EMP4', 'V5');
CALL InsertGymstaff_Visitor ('REF6', 'EMP7', 'V6');
CALL InsertGymstaff_Visitor ('REF7', 'EMP1', 'V7');
CALL InsertGymstaff_Visitor ('REF8', 'EMP2', 'V8');
CALL InsertGymstaff_Visitor ('REF9', 'EMP3', 'V11');

CALL InsertGymstaff_SportsCaptain ('REF101', 'EMP1', 'E/18/763');
CALL InsertGymstaff_SportsCaptain ('REF102', 'EMP2', 'E/17/546');
CALL InsertGymstaff_SportsCaptain ('REF103', 'EMP3', 'E/17/597');
CALL InsertGymstaff_SportsCaptain ('REF104', 'EMP4', 'E/16/144');
CALL InsertGymstaff_SportsCaptain ('REF105', 'EMP5', 'E/16/144');
CALL InsertGymstaff_SportsCaptain ('REF106', 'EMP6', 'E/16/154');
CALL InsertGymstaff_SportsCaptain ('REF107', 'EMP7', 'E/16/154');
CALL InsertGymstaff_SportsCaptain ('REF108', 'EMP8', 'E/16/154');
CALL InsertGymstaff_SportsCaptain ('REF109', 'EMP9', 'S/18/542');
CALL InsertGymstaff_SportsCaptain ('REF110', 'EMP10', 'S/18/542');
CALL InsertGymstaff_SportsCaptain ('REF111', 'EMP11', 'E/17/356');
CALL InsertGymstaff_SportsCaptain ('REF112', 'EMP12', 'E/17/356');
CALL InsertGymstaff_SportsCaptain ('REF113', 'EMP13', 'E/18/763');
CALL InsertGymstaff_SportsCaptain ('REF114', 'EMP14', 'S/18/542');
CALL InsertGymstaff_SportsCaptain ('REF115', 'EMP15', 'E/17/169');
CALL InsertGymstaff_SportsCaptain ('REF116', 'EMP16', 'E/18/123');
CALL InsertGymstaff_SportsCaptain ('REF117', 'EMP17', 'S/18/542');
CALL InsertGymstaff_SportsCaptain ('REF118', 'EMP18', 'S/18/542');
CALL InsertGymstaff_SportsCaptain ('REF119', 'EMP19', 'E/18/763');
CALL InsertGymstaff_SportsCaptain ('REF120', 'EMP20', 'E/17/169');

CALL InsertStudent_SportingCompetition ('REF1', 'E/17/169', 'C1');
CALL InsertStudent_SportingCompetition ('REF2', 'E/18/356', 'C1');
CALL InsertStudent_SportingCompetition ('REF3', 'E/18/549', 'C2');
CALL InsertStudent_SportingCompetition ('REF4', 'E/17/546', 'C4');
CALL InsertStudent_SportingCompetition ('REF5', 'E/18/564', 'C10');
CALL InsertStudent_SportingCompetition ('REF6', 'E/16/546', 'C5');
CALL InsertStudent_SportingCompetition ('REF7', 'E/18/548', 'C19');
CALL InsertStudent_SportingCompetition ('REF8', 'E/18/456', 'C13');
CALL InsertStudent_SportingCompetition ('REF9', 'E/18/541', 'C16');
CALL InsertStudent_SportingCompetition ('REF10', 'E/17/356', 'C16');
CALL InsertStudent_SportingCompetition ('REF11', 'E/16/154', 'C20');
CALL InsertStudent_SportingCompetition ('REF12', 'E/16/144', 'C6');
CALL InsertStudent_SportingCompetition ('REF13', 'E/16/153', 'C19');
CALL InsertStudent_SportingCompetition ('REF14', 'E/17/597', 'C15');
CALL InsertStudent_SportingCompetition ('REF15', 'E/18/763', 'C1');
CALL InsertStudent_SportingCompetition ('REF16', 'E/18/123', 'C13');
CALL InsertStudent_SportingCompetition ('REF19', 'S/18/564', 'C13');
CALL InsertStudent_SportingCompetition ('REF20', 'S/18/154', 'C17');

CALL GymEquipmentReturn ('R11', CURRENT_TIMESTAMP());
CALL ArenaReturn ('R10', CURRENT_TIMESTAMP());

ALTER TABLE StudentContactNumber ADD FOREIGN KEY (RegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE SportsCaptain ADD FOREIGN KEY (RegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE VisitorContactNumber ADD FOREIGN KEY (VisitorID) REFERENCES Visitor (VisitorID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE StaffContactNumber ADD FOREIGN KEY (EmployeeID) REFERENCES GymnasiumStaff (EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Achievements ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Achievements ADD FOREIGN KEY (CompetitionID) REFERENCES SportingCompetition (CompetitionID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE GymEquipmentReservation ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE GymEquipmentReservation ADD FOREIGN KEY (EquipmentID) REFERENCES GymEquipment (EquipmentID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE StadiumReservation ADD FOREIGN KEY (ArenaID) REFERENCES SportingArena (ArenaID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE StadiumReservation ADD FOREIGN KEY (VisitorID) REFERENCES Visitor (VisitorID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE StadiumReservation ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_Student ADD FOREIGN KEY (EmployeeID) REFERENCES GymnasiumStaff (EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_Student ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_SportsCaptain ADD FOREIGN KEY (EmployeeID) REFERENCES GymnasiumStaff (EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_SportsCaptain ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES SportsCaptain (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_Visitor ADD FOREIGN KEY (EmployeeID) REFERENCES GymnasiumStaff (EmployeeID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Gymstaff_Visitor ADD FOREIGN KEY (VisitorID) REFERENCES Visitor (VisitorID) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Student_SportingCompetition ADD FOREIGN KEY (StudentRegistrationNumber) REFERENCES Student (RegistrationNumber) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Student_SportingCompetition ADD FOREIGN KEY (CompetitionID) REFERENCES SportingCompetition (CompetitionID) ON UPDATE CASCADE ON DELETE CASCADE;
