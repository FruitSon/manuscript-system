-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ruizhen_db` DEFAULT CHARACTER SET utf8 ;
USE `ruizhen_db` ;

-- -----------------------------------------------------
-- Table `mydb`.`Issues`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Issues` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Issues` (
  `id_issue` INT NOT NULL DEFAULT 1,
  `publication_date` DATETIME NULL,
  `publication_year` INT NULL,
  `publication_period` INT NULL,
  `pages` INT NULL,
  PRIMARY KEY (`id_issue`))
ENGINE = InnoDB
AUTO_INCREMENT = 2;

-- -----------------------------------------------------
-- Table `mydb`.`Manuscript_Publication`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Manuscript_Publication` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Manuscript_Publication` (
  `id_manuscript` INT NOT NULL,
  `issue_num` INT NOT NULL DEFAULT 1,
  `typeset` Boolean NOT NULL,
  `number_of_pages` INT NULL,
  `order_in_issue` INT NULL,
  `beginning_page` INT NULL,
  `accepted_date` DATETIME NULL,
  PRIMARY KEY (`id_manuscript`, `issue_num`),
  INDEX `id_issue_idx` (`issue_num` ASC),
  CONSTRAINT `fk_id_manuscript`
    FOREIGN KEY (`id_manuscript`)
    REFERENCES `ruizhen_db`.`Manuscript` (`id_manuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_issue_num`
    FOREIGN KEY (`issue_num`)
    REFERENCES `ruizhen_db`.`Issues` (`id_issue`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Editors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Editors` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Editors` (
  `id_editor` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NULL,
  PRIMARY KEY (`id_editor`))
ENGINE = InnoDB
AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table `mydb`.`Manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Manuscript` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Manuscript` (
  `id_manuscript` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `ri_code` INT NOT NULL,
  `status` INT NOT NULL,
  `id_publication` INT NULL,
  `date_received` DATETIME NOT NULL,
  `date_last_status_changed` DATETIME NOT NULL,
  `file` BLOB NOT NULL,
  `id_editor` INT NOT NULL,
  PRIMARY KEY (`id_manuscript`),
  INDEX `fk_Manuscript_Editors1_idx` (`id_editor` ASC),
  INDEX `fk_id_publication_idx` (`id_publication` ASC),
  CONSTRAINT `fk_id_publication`
    FOREIGN KEY (`id_publication`)
    REFERENCES `ruizhen_db`.`Manuscript_Publication` (`issue_num`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manuscript_Editors1`
    FOREIGN KEY (`id_editor`)
    REFERENCES `ruizhen_db`.`Editors` (`id_editor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4;


-- -----------------------------------------------------
-- Table `mydb`.`Affiliation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Affiliation` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Affiliation` (
  `id_affiliation` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_affiliation`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Address` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Address` (
  `id_address` INT NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(45) NOT NULL,
  `street_2` VARCHAR(45) NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zip_code` VARCHAR(45) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_address`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Author` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Author` (
  `id_author` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `emai` VARCHAR(45) NOT NULL,
  `id_address` INT NOT NULL,
  `id_affiliation` INT NOT NULL,
  `password` VARCHAR(45) NULL,
   PRIMARY KEY (`id_author`, `id_affiliation`),
  INDEX `id_address_idx` (`id_affiliation` ASC),
  CONSTRAINT `fk_Authors_Affiliation`
    FOREIGN KEY (`id_affiliation`)
    REFERENCES `ruizhen_db`.`Affiliation` (`id_affiliation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_address`
    FOREIGN KEY (`id_address`)
    REFERENCES `ruizhen_db`.`Address` (`id_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Manuscript_Authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Manuscript_Authors` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Manuscript_Authors` (
  `id_manuscript` INT NOT NULL,
  `id_author` INT NOT NULL,
  `author_order` VARCHAR(45) NULL,
  PRIMARY KEY (`id_manuscript`,`author_order`),
  INDEX `author1_primary_idx` (`id_author` ASC),
  CONSTRAINT `fk_author`
    FOREIGN KEY (`id_author`)
    REFERENCES `ruizhen_db`.`Author` (`id_author`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manuscript`
    FOREIGN KEY (`id_manuscript`)
    REFERENCES `ruizhen_db`.`Manuscript` (`id_manuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Interest_Field`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Interest_Field` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Interest_Field` (
  `id_interest` INT NOT NULL AUTO_INCREMENT,
  `field` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_interest`))
ENGINE = InnoDB
AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table `mydb`.`Reviewer_Interest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Reviewer_Interest` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Reviewer_Interest` (
  `id_reviewer` INT NOT NULL AUTO_INCREMENT,
  `interest_code_1` INT NOT NULL,
  `interest_code_2` INT NULL,
  `interest_code_3` INT NULL,
  PRIMARY KEY (`id_reviewer`),
  INDEX `interest_code_1_idx` (`interest_code_1` ASC),
  INDEX `interest_code_2_fk_idx` (`interest_code_2` ASC),
  INDEX `interest_code_3_fk_idx` (`interest_code_3` ASC),
  CONSTRAINT `interest_code_fk`
    FOREIGN KEY (`interest_code_1`)
    REFERENCES `ruizhen_db`.`Interest_Field` (`id_interest`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interest_code_2_fk`
    FOREIGN KEY (`interest_code_2`)
    REFERENCES `ruizhen_db`.`Interest_Field` (`id_interest`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interest_code_3_fk`
    FOREIGN KEY (`interest_code_3`)
    REFERENCES `ruizhen_db`.`Interest_Field` (`id_interest`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Reviewer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Reviewer` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Reviewer` (
  `id_reviewer` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `id_affiliation` INT NULL,
  `password` VARCHAR(45) NULL,
  `enabled` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id_reviewer`),
  INDEX `id_affiliation_idx` (`id_affiliation` ASC),
  CONSTRAINT `fk_id_reviewer`
    FOREIGN KEY (`id_reviewer`)
    REFERENCES `ruizhen_db`.`Reviewer_Interest` (`id_reviewer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
--  CONSTRAINT `fk_id_affiliation`
--   FOREIGN KEY (`id_affiliation`)
--    REFERENCES `ruizhen_db`.`Affiliation` (`id_affiliation`)
--    ON DELETE NO ACTION
--    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `mydb`.`Review_Decision`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruizhen_db`.`Review_Decision` ;

CREATE TABLE IF NOT EXISTS `ruizhen_db`.`Review_Decision` (
  `id_manuscript` INT NOT NULL,
  `id_reviewer` INT NOT NULL,
  `appropriateness` INT NULL,
  `clarity` INT NULL,
  `methodology` INT NULL,
  `contribution` INT NULL,
  `decision` INT NULL,
  `date_assigned` DATETIME NOT NULL,
  `date_decided` DATETIME NULL,
  PRIMARY KEY (`id_manuscript`, `id_reviewer`),
  INDEX `fk_decision_id_idx` (`decision` ASC),
  INDEX `fk_reviewer_id_idx` (`id_reviewer` ASC),
  CONSTRAINT `fk_manuscript_id`
    FOREIGN KEY (`id_manuscript`)
    REFERENCES `ruizhen_db`.`Manuscript` (`id_manuscript`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviewer_id`
    FOREIGN KEY (`id_reviewer`)
    REFERENCES `ruizhen_db`.`Reviewer` (`id_reviewer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
-- CONSTRAINT `fk_decision_id`
-- FOREIGN KEY (`decision`)
-- REFERENCES `ruizhen_db`.`Paper_Status_Definitions` (`status_id`)
-- ON DELETE NO ACTION
-- ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `ruizhen_db` ;