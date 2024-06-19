SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

DROP DATABASE IF EXISTS `AstronomyDB`;
CREATE DATABASE AstronomyDB;

USE AstronomyDB;

CREATE TABLE NaturalObject (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    galaxy VARCHAR(255),
    accuracy DECIMAL(10, 2),
    flux DECIMAL(10, 2),
    associated TEXT,
    notes TEXT
);

CREATE TABLE Sector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(255),
    luminous_intensity VARCHAR(255),
    outside_objects VARCHAR(255),
    object_number INT,
    unknown_object_number INT,
    detailed_object_number INT,
    notes TEXT
);

CREATE TABLE Objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    deter_acc VARCHAR(255),
    quantity INT,
    date TIMESTAMP,
    notes TEXT
);

CREATE TABLE Positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_pos VARCHAR(255),
    moon_pos VARCHAR(255),
    sun_pos VARCHAR(255)
);

CREATE TABLE Observation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ntob_id INT,
    sctr_id INT,
    obj_id INT,
    pos_id INT,
    FOREIGN KEY (ntob_id) REFERENCES NaturalObject(id),
    FOREIGN KEY (sctr_id) REFERENCES Sector(id),
    FOREIGN KEY (obj_id) REFERENCES Objects(id),
    FOREIGN KEY (pos_id) REFERENCES Positions(id)
);

USE AstronomyDB;

-- Добавляем данные в таблицу NaturalObject
INSERT INTO NaturalObject (type, galaxy, accuracy, flux, associated, notes) VALUES
('Star', 'Andromeda', 0.92, 1200.0, 'Star Cluster E', 'Яркая звезда в галактике Андромеды.'),
('Planet', 'Milky Way', 0.88, 600.0, 'Moon', 'Планета с газовой атмосферой.'),
('Nebula', 'Orion', 0.78, 2500.0, 'Nebula Cluster F', 'Красивая туманность в созвездии Орион.'),
('Galaxy', 'NGC 1300', 0.91, 2800.0, 'Galaxy Group G', 'Спиральная галактика.'),
('Quasar', 'Leo', 0.85, 1700.0, 'Quasar Cluster H', 'Яркий источник излучения.'),
('Black Hole', 'Messier 87', 0.97, NULL, 'None', 'Супермассивное черное дыра.'),
('Supernova', 'SN 1993J', 0.75, NULL, 'None', 'Энергичный взрыв звезды.'),
('Asteroid', 'Jupiter', 0.63, NULL, 'None', 'Маленькое тело, вращающееся вокруг планеты.'),
('Satellite', 'Mars', 0.82, NULL, 'None', 'Исследовательский спутник Красной планеты.');



DELIMITER //
CREATE TRIGGER after_update_NaturalObject
AFTER UPDATE ON NaturalObject
FOR EACH ROW
BEGIN
    UPDATE NaturalObject
    SET date_update = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
//

DELIMITER //
CREATE PROCEDURE MergeTables(IN table1_name VARCHAR(255), IN table2_name VARCHAR(255))
BEGIN
    SET @sql = CONCAT('SELECT * FROM ', table1_name, ' JOIN ', table2_name, ' ON ', table1_name, '.id = ', table2_name, '.id');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//

DELIMITER //
CREATE PROCEDURE `UpdateNaturalObject`(IN textId INT, IN type VARCHAR(255), IN galaxy VARCHAR(255), IN accuracy DECIMAL(10, 2), IN flux DECIMAL(10, 2), IN associated TEXT, IN notes TEXT)
BEGIN
   UPDATE NaturalObject
   SET type = type,
       galaxy = galaxy,
       accuracy = accuracy,
       flux = flux,
       associated = associated,
       notes = notes
   WHERE id = textId;
END;
//

COMMIT;