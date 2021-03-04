INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_catsecurity', 'catsecurity', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_catsecurity', 'catsecurity', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    ('society_catsecurity', 'catsecurity', 1)
;

INSERT INTO `jobs` (name, label) VALUES
    ('catsecurity', 'catsecurity')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('catsecurity',0,'recruit','Recruit',600,'{}','{}'),
	('catsecurity',0,'recruit','Bodyguard',650,'{}','{}'),
	('catsecurity',0,'recruit','Manager',700,'{}','{}'),
	('catsecurity',1,'boss','Boss',750,'{}','{}'),
;

INSERT INTO `items` (`name`, `label`) VALUES
    (bulletproof, Bulletproof),
	(komatialexisferou, Resource of Bulletproof)
;