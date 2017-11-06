
-- -----------------------------------------------------
-- View `mydb`.`LeadAuthorManuscripts`
-- -----------------------------------------------------
-- DROP VIEW IF EXISTS `ruizhen_db`.`LeadAuthorManuscripts` ;
-- DROP TABLE IF EXISTS `ruizhen_db`.`LeadAuthorManuscripts`;
-- USE `ruizhen_db`;
-- CREATE  OR REPLACE VIEW `LeadAuthorManuscripts` AS
-- SELECT last_name, Author.id_author, id_manuscript
-- FROM Author
-- INNER JOIN Manuscript_Authors ON Manuscript_Authors.id_author = Author.id_author;
-- 
DROP VIEW IF EXISTS `ruizhen_db`.`LeadAuthorManuscripts` ;
DROP TABLE IF EXISTS `ruizhen_db`.`LeadAuthorManuscripts`;
USE `ruizhen_db`;
CREATE  OR REPLACE VIEW `LeadAuthorManuscripts` AS
SELECT last_name, Author.id_author, Manuscript.id_manuscript, date_last_status_changed, status
FROM Author
INNER JOIN Manuscript_Authors ON Manuscript_Authors.author_order = 1 AND Manuscript_Authors.id_author = Author.id_author
INNER JOIN Manuscript ON Manuscript_Authors.id_manuscript = Manuscript.id_manuscript
ORDER BY last_name ASC, Author.id_author ASC, date_last_status_changed ASC;

-- -----------------------------------------------------
-- View `mydb`.`AnyAuthorManuscripts`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ruizhen_db`.`AnyAuthorManuscripts` ;
DROP TABLE IF EXISTS `ruizhen_db`.`AnyAuthorManuscripts`;
USE `ruizhen_db`;
CREATE  OR REPLACE VIEW `AnyAuthorManuscripts` AS
SELECT Manuscript_Authors.id_manuscript, Manuscript_Authors.id_author, Author.last_name, Author.first_name ,Manuscript.date_last_status_changed
FROM Manuscript_Authors
INNER JOIN Author ON Manuscript_Authors.id_author = Author.id_author
INNER JOIN Manuscript ON Manuscript.id_manuscript = Manuscript_Authors.id_manuscript
ORDER BY Author.last_name ASC,  Manuscript.date_last_status_changed ASC;

-- -----------------------------------------------------
-- View `mydb`.`PublishedIssues`
-- Permissions: Author, Editor, Reviewer.
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ruizhen_db`.`PublishedIssues` ;
DROP TABLE IF EXISTS `ruizhen_db`.`PublishedIssues`;
USE `ruizhen_db`;
CREATE  OR REPLACE VIEW `PublishedIssues` AS
SELECT Issues.publication_year, Issues.publication_period, Manuscript.title, Manuscript_Publication.number_of_pages
FROM  Issues
INNER JOIN Manuscript_Publication ON  Issues.publication_date IS NOT NULL AND Manuscript_Publication.issue_num = Issues.id_issue
INNER JOIN Manuscript ON Manuscript.id_manuscript = Manuscript_Publication.id_manuscript
ORDER BY Issues.publication_year ASC, Issues.id_issue ASC, Manuscript_Publication.number_of_pages ASC;


-- -----------------------------------------------------
-- View `mydb`.`ReviewQueue`
-- Permissions: Editor.
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ruizhen_db`.`ReviewQueue`;
DROP TABLE IF EXISTS `ruizhen_db`.`ReviewQueue`;
USE `ruizhen_db`;
CREATE OR REPLACE VIEW `ReviewQueue` AS
SELECT Author.first_name, Author.last_name, Manuscript.id_manuscript, Manuscript_Authors.id_author, group_concat(Reviewer.id_reviewer separator '-') 
FROM  Manuscript 
INNER JOIN Manuscript_Authors ON Manuscript_Authors.id_manuscript = Manuscript.id_manuscript AND Manuscript_Authors.author_order = 1 AND Manuscript.status=2
INNER JOIN Author ON Author.id_author = Manuscript_Authors.id_author 
INNER JOIN Review_Decision ON Review_Decision.id_manuscript = Manuscript.id_manuscript
INNER JOIN Reviewer ON Review_Decision.id_reviewer  = Reviewer. id_reviewer
GROUP BY Manuscript.id_manuscript
ORDER BY Manuscript.date_last_status_changed ASC;

-- -----------------------------------------------------
-- View `mydb`.`WhatsLeft`
-- Permissions: Editor.
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ruizhen_db`.`WhatsLeft`;
DROP TABLE IF EXISTS `ruizhen_db`.`WhatsLeft`;
USE `ruizhen_db`;
CREATE OR REPLACE VIEW `WhatsLeft` AS
SELECT Manuscript.id_manuscript, Manuscript.status, Manuscript.date_last_status_changed
FROM Manuscript;

-- -----------------------------------------------------
-- View `mydb`.`ReviewStatus`
-- Permissions: Editor, Reviewer.
-- -----------------------------------------------------

DELIMITER $$
DROP FUNCTION IF EXISTS SetViewRevId $$
CREATE FUNCTION SetViewRevId(rev_id_query INT) 
RETURNS INTEGER DETERMINISTIC
BEGIN
	SET @rev_id = rev_id_query;
 RETURN @rev_id;
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS GetViewRevId $$
CREATE FUNCTION GetViewRevId() RETURNS int(11)
BEGIN
IF(@rev_id IS NULL) THEN
	SET @rev_id = 114;
END IF;
RETURN @rev_id;
END $$


DELIMITER ;
DROP VIEW IF EXISTS `ruizhen_db`.`ReviewStatus`;
DROP TABLE IF EXISTS `ruizhen_db`.`ReviewStatus`;
USE `ruizhen_db`;
CREATE OR REPLACE VIEW `ReviewStatus` AS
    SELECT 
        `review_decision`.`date_assigned` AS `date_assigned`,
        `manuscript`.`id_manuscript` AS `id_manuscript`,
        `manuscript`.`title` AS `title`,
        `review_decision`.`appropriateness` AS `appropriateness`,
        `review_decision`.`clarity` AS `clarity`,
        `review_decision`.`methodology` AS `methodology`,
        `review_decision`.`contribution` AS `contribution`,
        `review_decision`.`decision` AS `decision`
    FROM
        (`review_decision`
        JOIN `manuscript` ON (((`review_decision`.`id_reviewer` = GETVIEWREVID())
            AND (`manuscript`.`id_manuscript` = `review_decision`.`id_manuscript`))))
    ORDER BY `manuscript`.`date_received`;
-- 

-- helper view for trigger implementation
-- -----------------------------------------------------
-- View `mydb`.`SupportedRIcode`
-- Permissions: Editor
-- -----------------------------------------------------
DROP VIEW IF EXISTS `ruizhen_db`.`SupportedRIcode`;
DROP TABLE IF EXISTS `ruizhen_db`.`SupportedRIcode`;
USE `ruizhen_db`;
CREATE OR REPLACE VIEW `SupportedRIcode` AS
(SELECT id_reviewer, interest_code_1
FROM Reviewer_Interest WHERE interest_code_1 IS NOT NULL)
UNION ALL
(SELECT id_reviewer,interest_code_2
FROM Reviewer_Interest WHERE interest_code_2 IS NOT NULL)
UNION ALL
(SELECT id_reviewer, interest_code_3
FROM Reviewer_Interest WHERE interest_code_3 IS NOT NULL)
ORDER BY interest_code_1;

