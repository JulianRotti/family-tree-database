CREATE DATABASE IF NOT EXISTS family_tree;
USE family_tree;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS relationships;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    initial_last_name VARCHAR(50),
    birth_date DATE,
    death_date DATE,
    UNIQUE KEY unique_member (first_name, last_name, birth_date)
) ENGINE=InnoDB;

CREATE TABLE relationships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_1_id INT NOT NULL,
    member_2_id INT NOT NULL,
    relationship ENUM('parent', 'spouse') NOT NULL,
    connection_hash CHAR(32) AS (CONCAT(LEAST(member_1_id, member_2_id), '-', GREATEST(member_1_id, member_2_id))) STORED,
    FOREIGN KEY (member_1_id) REFERENCES members(id), -- ON DELETE CASCADE,
    FOREIGN KEY (member_2_id) REFERENCES members(id), -- ON DELETE CASCADE,
    UNIQUE (connection_hash, relationship)
) ENGINE=InnoDB;

-- #FIXME Workaround for failing 'ON DELETE CASCADE' in relationships table 
DELIMITER //

CREATE TRIGGER before_member_delete
BEFORE DELETE ON members
FOR EACH ROW
BEGIN
    DELETE FROM relationships
    WHERE member_1_id = OLD.id
       OR member_2_id = OLD.id;
END //

DELIMITER ;