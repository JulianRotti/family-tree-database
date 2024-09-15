CREATE DATABASE IF NOT EXISTS family_tree;
USE family_tree;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS relationships;
DROP PROCEDURE IF EXISTS get_family_tree;

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

DELIMITER //

CREATE PROCEDURE get_family_tree(IN memberId INT)
BEGIN
    DROP TABLE IF EXISTS temp_combined;
    -- Create a temporary table to hold combined results
    CREATE TABLE temp_combined AS

    -- Use a CTE to get descendants
    WITH RECURSIVE descendants AS (
        -- Base case: Start with the given member
        SELECT 
            r.member_1_id AS member_1_id,
            m.id AS member_2_id,
            'parent' AS relationship
        FROM 
            members m
        JOIN 
            relationships r ON m.id = r.member_2_id
        WHERE 
            r.relationship = 'parent' 
            AND r.member_1_id = memberId
        
        UNION ALL
        
        -- Recursive case: Find descendants of the previously found descendants
        SELECT 
            r.member_1_id AS member_1_id,
            m.id AS member_2_id,
            'parent' AS relationship
        FROM 
            members m
        JOIN 
            relationships r ON m.id = r.member_2_id
        JOIN 
            descendants d ON r.member_1_id = d.member_2_id
        WHERE 
            r.relationship = 'parent'
    ),
    spouses AS (
        -- Find spouses of the members in the descendants CTE
        SELECT 
            r.member_1_id AS member_1_id,
            r.member_2_id AS member_2_id,
            'spouse' AS relationship
        FROM 
            relationships r
        WHERE 
            (r.member_1_id IN (SELECT member_1_id FROM descendants) 
            OR r.member_2_id IN (SELECT member_2_id FROM descendants))
            AND r.relationship = 'spouse'
    ),
        -- Now include children of the spouses recursively
    spouse_descendants AS (
        SELECT 
            r.member_1_id AS member_1_id,
            r.member_2_id AS member_2_id,
            'parent' AS relationship
        FROM 
            relationships r
        JOIN 
            spouses s ON s.member_2_id = r.member_1_id
        WHERE 
            r.relationship = 'parent'
    )
    -- Insert descendants and spouses into temp_combined
    SELECT * FROM descendants
    UNION ALL
    SELECT * FROM spouses
    UNION ALL 
    SELECT * FROM spouse_descendants;

    -- First result set: Return the combined relationships
    SELECT * FROM temp_combined;

    SELECT * FROM members
    WHERE id IN (SELECT member_2_id FROM temp_combined UNION SELECT member_1_id FROM temp_combined);

    -- Cleanup: Drop the temporary table
    DROP TABLE IF EXISTS temp_combined;
END //

DELIMITER ;

