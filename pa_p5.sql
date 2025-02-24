-- 1. Create a table that will store a customized report that shows how many 
-- tables, views, indexes and users are in the database at a particular time. 

CREATE TABLE REPORT_TABLE(
  user_id NUMBER, 
  total_tables NUMBER, 
  total_views NUMBER, 
  total_indexes NUMBER, 
  log_date DATE
);

-- Use a PL/SQL block to retrieve and insert data. 
-- When the block runs, it will retrieve a count on 
-- those objects and insert the result into your report table, 
-- along with the time that row of report is inserted. 

DECLARE
  user_id NUMBER;
  total_tables NUMBER;
  total_views NUMBER;
  total_indexes NUMBER;

BEGIN
SELECT COUNT(*) into user_id 
FROM SYS.ALL_OBJECTS
WHERE OBJECT_TYPE = 'U';

SELECT COUNT(*) into total_tables 
FROM SYS.ALL_OBJECTS
WHERE OBJECT_TYPE= 'TABLE';

SELECT COUNT(*) into total_views 
FROM SYS.ALL_OBJECTS
WHERE OBJECT_TYPE= 'VIEW'; 

SELECT  COUNT(*) into total_indexes 
FROM SYS.ALL_OBJECTS
WHERE OBJECT_TYPE = 'INDEX'; 

insert into REPORT_TABLE values (user_id, total_tables, total_views, total_indexes, sysdate);
END;

CREATE TABLE EMPLOYEE (
  emp_id INTEGER(10),
  first_name VARCHAR(10),
  last_name VARCHAR(10),
  email VARCHAR(20),
  emp_pass VARCHAR(15),
  salary INTEGER
);

CREATE SEQUENCE emp_id INCREMENT BY 1 START WITH 1;

DECLARE
 id INTEGER(10);
 fname VARCHAR(10);
 lname VARCHAR(10);
 stremail VARCHAR(20);
 epwd VARCHAR(15);
 sal INTEGER;

BEGIN
id := emp_id.NEXTVAL;
FOR i IN 1 ..500 LOOP
 fname := DBMS_RANDOM.string('u', ROUND(DBMS_RANDOM.value(1,10)));
 lname := DBMS_RANDOM.string('u', ROUND(DBMS_RANDOM.value(1,10)));
 stremail := DBMS_RANDOM.string('1',10)||'@'||DBMS_RANDOM.string('1',5)||'.'||DBMS_RANDOM.string('2',3);
 epwd := DBMS_RANDOM.string('x', ROUND(DBMS_RANDOM.value(8,15)));
 sal := ROUND(DBMS_RANDOM.value(low => 1, high => 100000));

INSERT INTO EMPLOYEE VALUES(i, fname, lname, stremail, epwd, sal);
END LOOP;
END;
/

