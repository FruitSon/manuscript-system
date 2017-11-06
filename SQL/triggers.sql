

DELIMITER $$

-- Trigger 1
-- When an author is submitting a new manuscript to the system with an RICode 
-- for which there is no reviewer who handles that RICode you should raise an exception 
-- that informs the author the paper can not be considered at this time.

DROP TRIGGER IF EXISTS RIcode_check$$
CREATE TRIGGER RIcode_check 
	BEFORE INSERT ON Manuscript
	FOR EACH ROW 
    BEGIN
		DECLARE num_reviewer INT;
		DECLARE msg VARCHAR(128);
		IF new.ri_code NOT IN (SELECT * FROM ruizhen_db.supportedricode) THEN
			SET msg = CONCAT('Exception: No reviewers have interest in RICode - ', CAST(new.ri_code AS CHAR), ', the paper will not be considered yet.');
			SIGNAL SQLSTATE '45000' SET message_text = msg;
-- 			ELSEIF (num_reviewer <3 AND num_reviewer>0) THEN
-- 			SET msg = CONCAT('Exception: Not enough reviewers have interest in RICode - ', CAST(new.ri_code AS CHAR), ', the paper will not be considered yet.');
-- 			SIGNAL SQLSTATE '45000' SET message_text = msg;
		END IF;		
END$$

-- Trigger 2
-- When a reviewer resigns any manuscript in “UnderReview” state for which that reviewer was the only reviewer 
-- AND there is another reviewer in the system with the matching RICode that isn’t already assigned to review it, 
-- that manuscript must be reset to “submitted” state and an appropriate exception message displayed. 
-- If no reviewer with the required RICode is available, the manuscript should be rejected.
DROP TRIGGER IF EXISTS Review_resign$$
CREATE TRIGGER Review_resign
	AFTER DELETE ON Review_Decision 
	FOR EACH ROW
	BEGIN
		DECLARE num_reviewer INT;
		DECLARE num_cur_reviewer INT;
		DECLARE msg VARCHAR(128);


		DECLARE cur_ri_code INT;
-- 		SET cur_ri_code := (SELECT ri_code FROM Manuscript WHERE Manuscript.id_manuscript = old.id_manuscript) ;
-- 		SET num_reviewer := (SELECT COUNT( interest_code_1 = (SELECT ri_code FROM Manuscript WHERE Manuscript.id_manuscript = old.id_manuscript)) FROM SupportedRIcode);
 		SET num_cur_reviewer := (SELECT COUNT(old.id_manuscript) FROM Review_Decision);
		
		-- The only reviewer interested in this field resigns review, reject
		IF (old.id_manuscript NOT IN (SELECT id_manuscript FROM Review_Decision))  AND 
			((SELECT ri_code FROM Manuscript WHERE Manuscript.id_manuscript = old.id_manuscript)  NOT IN (SELECT interest_code_1 FROM SupportedRIcode WHERE SupportedRIcode.id_reviewer != old.id_reviewer) ) THEN
				UPDATE Manuscript
				SET Manuscript.status = 2 WHERE Manuscript.id_manuscript = old.id_manuscript;
		-- has other reviewer interested in this field avaliable, set status to submitted
		ELSEIF (old.id_manuscript NOT IN (SELECT id_manuscript FROM Review_Decision)) AND 
			((SELECT ri_code FROM Manuscript WHERE Manuscript.id_manuscript = old.id_manuscript)  IN (SELECT interest_code_1 FROM SupportedRIcode WHERE SupportedRIcode.id_reviewer != old.id_reviewer) ) THEN
				UPDATE Manuscript
				SET Manuscript.status = 0 WHERE Manuscript.id_manuscript = old.id_manuscript;
		END IF;
END$$

DELIMITER ;