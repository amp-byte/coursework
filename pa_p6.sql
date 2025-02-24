--BEGIN PROJECT 6
-- table from project 5

CREATE TABLE EMPLOYEE (
  emp_id INTEGER,
  first_name VARCHAR(10),
  last_name VARCHAR(10),
  email VARCHAR(20),
  emp_pass VARCHAR(15),
  salary INTEGER
);

-- create a sequence for employee id starting with one
CREATE SEQUENCE e_id START WITH 1;

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

INSERT INTO EMPLOYEE VALUES(i, fname, lname, stremail, epwd, sal);
END LOOP;
END;
/

-- Use the employee table that you created and create another table so that it 
-- contains all the employee IDs 
CREATE TABLE e_perform_res(
 id INTEGER,
 perform_res INTEGER
);

--INSERT DATA INTO e_perfrom_res
--Use a block of script to populate the second table 
DECLARE
 e_id EMPLOYEE.emp_id%TYPE;
 perform e_perform_res.perform_res%TYPE;
 CURSOR e_curs IS SELECT id 
	FROM EMPLOYEE;
 
BEGIN
 OPEN e_curs;
 FETCH e_curs INTO e_id;
 
 WHILE e_curs%FOUND LOOP
 	--with performance review results randomly generated.
 	perform_res := DBMS_RANDOM.value(1,5);
	--The review result is an integer ranged from 1 to 5 	
 	INSERT INTO e_perform_res VALUES (e_id, perform_res);
 	FETCH e_curs INTO e_id;
 END LOOP;
 CLOSE e_curs;
END;
/

-- 2. Create the third table that stores the bonus information. 
CREATE TABLE e_bonus(
 id INTEGER,
 fname VARCHAR(20),
 lname VARCHAR(20),
 sal INTEGER,
 bonus INTEGER
);

-- The third table should have the 
-- employee ID, first name, last name, salary and bonus.

DECLARE
 eid e_bonus.id%TYPE; 		 			 -- inherits data type and default value
 efname e_bonus.fname%TYPE;	 			 -- inherits data type and default value
 elname e_bonus.lname%TYPE;	 			 -- inherits data type and default value
 esal e_bonus.sal%TYPE;		 			 -- inherits data type and default value
 ebonus e_bonus.bonus%TYPE;	 			 -- inherits data type and default value
 eperform e_perform_res.perform_res%TYPE;-- inherits data type and default value
 CURSOR e_curs IS SELECT EMPLOYEE.id, fname, lname, sal, perform_res
	FROM EMPLOYEE.id INNER JOIN e_perform_res
	ON EMPLOYEE.id = e_perform_res.id;

--calculated bonus  
BEGIN
 OPEN e_curs;
 FETCH e_curs INTO eid, efname, elname, esal, eperform;
 WHILE e_curs%FOUND LOOP --fetch succeeded
	--If the performance review is 5, the bonus is 10% of the salary.
	IF e_perform = 5 
		THEN ebonus := 0.10 * esal;
	--If the performance review is 4, the bonus is 8% of the salary. 
	ELSIF e_perform = 4 
		THEN ebonus := 0.08 * esal;
	--If the performance review is 3, the bonus is 5% of the salary. 
	ELSIF e_perform = 3 
		THEN ebonus := 0.05 * esal;
	--Otherwise, the bonus is 0%. 
	ELSE --fetch failed
		ebonus:= 0;
	END IF; --end if statement
	
	INSERT INTO e_bonus VALUES(eid, efname, elname, esal, ebonus);
 END LOOP;
 CLOSE e_curs;
END;
/
