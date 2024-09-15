USE family_tree

INSERT INTO members (
    id,
    first_name,
    last_name,
    initial_last_name,
    birth_date,
    death_date
) VALUES 
    (1, 'Sebald', 'Horn', 'Buchner', '1930-01-01', NULL),
    (2, 'Marie', 'Horn', NULL, '1990-03-09', NULL),
    (3, 'Emily', 'Horn', 'Bauer', '1950-06-10', NULL),
    (4, 'Fritz', 'Horn', NULL, '1950-06-02', NULL),
    (5, 'Chantal', 'Horn', NULL, '1988-03-22', NULL),
    (6, 'Ahmed', 'Horn', NULL, '1990-03-25', NULL),
    (7, 'Rosalie', 'Cortez', NULL, '1991-01-26', NULL),
    (8, 'Sebalda', 'Horn', NULL, '1930-01-01', NULL),
    (9, 'FirstChildAhmed', 'Horn', NULL, '2000-01-01', NULL),
    (10, 'SecondChildAhmed', 'Horn', NULL, '2000-01-01', NULL),
    (11, 'ChildAhmed', 'Cortez', NULL, '2000-01-01', NULL),
    (12, 'SecWifeAhmed', 'Horn', NULL, '1990-01-01', NULL),
    (13, 'ThirdWifeAhmed', 'Horn', NULL, '1990-01-01', NULL);

INSERT INTO relationships (
    member_1_id,
    member_2_id,
    relationship
) VALUES 
    (1, 8, 'spouse'),
    (1, 4, 'parent'),
    (8, 4, 'parent'),
    (4, 3, 'spouse'),
    (3, 2, 'parent'),
    (3, 5, 'parent'),
    (3, 6, 'parent'),
    (4, 2, 'parent'),
    (4, 5, 'parent'),
    (4, 6, 'parent'),
    (6, 7, 'spouse'),
    (6, 12, 'spouse'),
    (6, 13, 'spouse'),
    (6, 10, 'parent'),
    (6, 11, 'parent'),
    (12, 9, 'parent'),
    (12, 10, 'parent'),
    (6, 9, 'parent'),
    (7, 11, 'parent');