DROP USER IF EXISTS 'dev_user'@'localhost';
-- Create a dedicated MySQL user (if needed)
CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'dev_user';
GRANT ALL PRIVILEGES ON family_tree.* TO 'dev_user'@'localhost';
FLUSH PRIVILEGES;

