-- project 7
-- csci n311
-- Row level trigger
-- You are to create a log table that will record all changes 
-- that occur to the EMPLOYEE table that you created in Project 5

CREATE TABLE EMPLOYEE (
  emp_id INTEGER,
  first_name VARCHAR(10),
  last_name VARCHAR(10),
  email VARCHAR(20),
  emp_pass VARCHAR(15),
  salary INTEGER
);

-- create a sequence for employee id starting with one
CREATE SEQUENCE emp_id START WITH 1;

DECLARE
 id INTEGER;
 fname VARCHAR(10);
 lname VARCHAR(10);
 stremail VARCHAR(20);
 epwd VARCHAR(15);
 sal INTEGER;

-- randomized email no longer than 20 chars
BEGIN
id := emp_id.NEXTVAL; --emp_id from employee = id
FOR i IN 1 ..500 LOOP
 fname := DBMS_RANDOM.string('u', ROUND(DBMS_RANDOM.value(1,10)));
 lname := DBMS_RANDOM.string('u', ROUND(DBMS_RANDOM.value(1,10)));
 stremail := DBMS_RANDOM.string('1',10)||'@'||DBMS_RANDOM.string('1',6)||'.'||DBMS_RANDOM.string('2',3);
 epwd := DBMS_RANDOM.string('x', ROUND(DBMS_RANDOM.value(8,15)));
 sal := ROUND(DBMS_RANDOM.value(low => 1, high => 100000));

INSERT INTO EMPLOYEE VALUES(id, fname, lname, stremail, epwd, sal);
END LOOP;
END;
/

-- Create an EMPLOYEE_LOG table with all columns from the EMPLOYEE table plus the 
-- MOD_USER [VARCHAR2(10)] and MOD_TIMESTAMP [DATE]. 
CREATE TABLE EMPLOYEE_LOG AS (SELECT * FROM EMPLOYEE WHERE 1=2);

ALTER TABLE EMPLOYEE_LOG ADD MOD_USER VARCHAR2(10), MOD_TIMESTAMP DATE;
--Next, create two triggers on the EMPLOYEE table to keep track of inserts or updates. 
-- a. For any inserts, the trigger should put the new EMPLOYEE_ID value, 
	-- and the system user (whoever runs the insert statement) in MOD_USER, 
	-- and the system date in MOD_TIMESTAMP into EMPLOYEE_LOG  table to record the creation of the data. 
	-- Leave the rest of the columns with null values. (20’)

CREATE OR REPLACE TRIGGER EMPLOYEE_TRIGGER
AFTER INSERT ON EMPLOYEE
FOR EACH ROW

DECLARE
MOD_TIMESTAMP := SYSDATE

BEGIN
INSERT INTO EMPLOYEE_LOG(id, MOD_USER, MOD_TIMESTAMP)
VALUES (id, MOD_USER, MOD_TIMESTAMP);
END;
/

--b. For updates, this trigger should put the previous EMPLOYEE values into the 
-- corresponding EMPLOYEE_LOG column as well as the MOD_USER and MOD_TIMESTAMP. (20’)

CREATE OR REPLACE TRIGGER EMPLOYEE_TRIGGER_UPDATE
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW

DECLARE
MOD_TIMESTAMP := SYSDATE

BEGIN
INSERT INTO EMPLOYEE_LOG(id, fname, lname, stremail, epwd, MOD_USER, MOD_TIMESTAMP)
VALUES(id, fname, lname, stremail, epwd, MOD_USER, MOD_TIMESTAMP);
END;
/


-- 2. Statement Level Trigger
-- Find a table in the sample database, and design a task that would 
-- use a statement level trigger to keep track of changes. 
-- Your trigger and table used should be different from what’s used in the demo file. (20’)
-- Use comments to explain the purpose of creating this trigger and how the trigger works. (10’)

CREATE TABLE TEST_BOOK_ORDER (bid INTEGER, title VARCHAR2(10));

CREATE TABLE TEST_BOOK_AUDIT (bid INTEGER, title VARCHAR(10), update_by VARCHAR2, updated_on DATE);


CREATE TRIGGER testaudittrigger on TEST_BOOK_ORDER
AFTER UPDATE OR INSERT OR DELETE

BEGIN
INSERT INTO TEST_BOOK_AUDIT
(bid, title, update_by, update_on )
VALUES (NEW.bid, NEW.title, SYSDATE);
FROM BOOK_ORDER
UNION ALL
SELECT
OLD.title
FROM BOOK_ORDER
END;
/

-- I created this statement trigger to keep track of book order updates and track when books
-- are ordered by title, i would like the title and date to display off all books bought


-- 3.Schema level trigger (30’)
-- If no objects are created on a day, there will be no entry for that day. 
-- Your table will look like this:
	--2 04-06-2018
	--5 04-08-2018

CREATE TABLE OBJ_COUNT(object_count NUMBER(10), object_date DATE);

-- Create a trigger to keep track of how many objects were created on a particular day.
CREATE OR REPLACE TRIGGER THINGS_MADE
AFTER CREATE ON THINGS_MADE

BEGIN
	IF EXISTS(SELECT object_count FROM OBJ_COUNT WHERE object_date = SYSDATE);
		UPDATE OBJ_COUNT
		SET object_count = object_count + 1
		WHERE object_date = SYSDATE
	ELSE
		INSERT INTO OBJ_COUNT(1, SYSDATE);
	END IF;
END;
/