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


-- Добавляем данные в таблицу Sector
INSERT INTO Sector (coordinates, luminous_intensity, outside_objects, object_number, unknown_object_number, detailed_object_number, notes) VALUES
('Sector 1A', 'High', 'Asteroids', 10, 2, 5, 'Observation sector 1A'),
('Sector 2B', 'Medium', 'Comets', 15, 1, 7, 'Observation sector 2B'),
('Sector 3C', 'Low', 'Satellites', 8, 4, 3, 'Observation sector 3C'),
('Sector 4D', 'Very High', 'Space debris', 20, 0, 10, 'Observation sector 4D'),
('Sector 5E', 'Medium-High', 'Spacecraft', 12, 3, 6, 'Observation sector 5E');

-- Добавляем данные в таблицу Objects
INSERT INTO Objects (type, deter_acc, quantity, date, notes) VALUES
('Star', 'High', 5, '2024-06-15 10:30:00', 'Observation of stars'),
('Planet', 'Medium', 3, '2024-06-16 11:00:00', 'Observation of planets'),
('Comet', 'Low', 7, '2024-06-17 12:45:00', 'Observation of comets'),
('Asteroid', 'Very High', 2, '2024-06-18 09:20:00', 'Observation of asteroids'),
('Nebula', 'High', 4, '2024-06-19 08:10:00', 'Observation of nebulas');

-- Добавляем данные в таблицу Positions
INSERT INTO Positions (earth_pos, moon_pos, sun_pos) VALUES
('30°N, 50°E', '10°N, 20°E', '0°N, 0°E'),
('35°N, 55°E', '15°N, 25°E', '5°N, 5°E'),
('40°N, 60°E', '20°N, 30°E', '10°N, 10°E'),
('45°N, 65°E', '25°N, 35°E', '15°N, 15°E'),
('50°N, 70°E', '30°N, 40°E', '20°N, 20°E');

-- Добавляем данные в таблицу Observation
INSERT INTO Observation (ntob_id, sctr_id, obj_id, pos_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5);


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
CREATE PROCEDURE `MergeTables`(IN table1_name VARCHAR(255), IN table2_name VARCHAR(255))
BEGIN
    SET @sql = CONCAT('SELECT * FROM ', table1_name, ' JOIN ', table2_name, ' ON ', table1_name, '.id = ', table2_name, '.id');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
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