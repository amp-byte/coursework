--CSCI-N311
--Project 4
--Due: 20 FEB 2022

--1. Write a query to show the distinct occurrences of ACTION in LEDGER
SELECT DISTINCT ACTION FROM LEDGER;

--2. Create a view over the LEDGER table called LEDGER_SALES. 
--The query for this view will provide a summary of data from the LEDGER that is only ACTION = ‘BOUGHT’ rows, 
--grouped by PERSON and ACTIONDATE, and show the sum of AMOUNT in a new column called TOT_AMT. 
--This view will have 3 columns: PERSON, ACTIONDATE, TOT_AMT
DROP VIEW LEDGER_SALES; CREATE VIEW LEDGER_SALES AS SELECT PERSON, ACTIONDATE, SUM(AMOUNT)TOT_AMT
FROM LEDGER
WHERE ACTION = 'BOUGHT'
GROUP BY PERSON, ACTIONDATE
;

--3. Write a query to show the minimum, maximum, and average total amount of a sale (LEDGER_SALES.TOT_AMT)
SELECT MIN(TOT_AMT), MAX(TOT_AMT), ROUND(AVG(TOT_AMT)) FROM LEDGER_SALES;

--4. Write a query to show which customers (PERSON) had “repeat business”—more than one row appearing in the LEDGER_SALES view. 
SELECT PERSON, COUNT(*) AS COUNT
FROM LEDGER
WHERE ACTION = 'BOUGHT'
GROUP BY PERSON
HAVING COUNT(*) > 1
ORDER BY COUNT(*)
;

--Show the workers (in the WORKER table) who are also customers
--they have ‘BOUGHT’ an item as recorded in the LEDGER table. 
--Show the worker names, the total amount of all items they bought 
--order the query results by name. Write this query 3 different ways: 
    --5.1. Use a regular join in the WHERE clause. (5’)
    --5.2. Use a subquery and the IN keyword. (5’)
    --5.3. Use a subquery and the EXISTS operator. (5’)

--5.1
SELECT WORKER.NAME, TO_CHAR(SUM(LEDGER.QUANTITY))TOT_AMT
FROM WORKER, LEDGER
WHERE WORKER.NAME = LEDGER.PERSON AND ACTION = 'BOUGHT' 
group by WORKER.NAME
;

--5.2
SELECT PERSON, SUM(QUANTITY)TOT_AMT
FROM LEDGER
WHERE PERSON 
    IN (SELECT NAME 
        FROM WORKER 
        WHERE WORKER.NAME = LEDGER.PERSON AND ACTION = 'BOUGHT')
        GROUP BY PERSON, ACTION
;

--5.3
SELECT PERSON, SUM(QUANTITY)TOT_AMT
FROM LEDGER
WHERE EXISTS
(SELECT NAME FROM WORKER WHERE WORKER.NAME = LEDGER.PERSON AND ACTION = 'BOUGHT') 
GROUP BY PERSON
;

--6. Show all workers (use an outer join) and 
-- for those workers who never bought anything, print ‘never bought’ in place of the total amount column 
-- (use the DECODE function and test for NULL).  

SELECT PERSON, DECODE(QUANTITY, NULL, 'NEVER BOUGHT', QUANTITY) TOT_AMT
FROM LEDGER
RIGHT JOIN WORKER ON WORKER.NAME = LEDGER.PERSON
GROUP BY PERSON, DECODE(QUANTITY, NULL, 'NEVER BOUGHT', QUANTITY)
;

--7. Show all worker’s name, lodging, and age of those who do not have ‘good’, ‘excellent’, or ‘average’ skills in the WORKERSKILL table. 
-- Order the query results by name. Write this query 2 different ways:
    -- 7.1. Use a NOT IN operator. (5’)
    -- 7.2. Use an outer join. (5’)
    
SELECT WORKERSKILL.NAME, WORKER.AGE, WORKER.LODGING
FROM WORKERSKILL, WORKER
WHERE WORKERSKILL.ABILITY NOT IN ('AVERAGE', 'GOOD', 'EXCELLENT')
ORDER BY WORKERSKILL.NAME
;

SELECT *
FROM WORKERSKILL, WORKER
LEFT JOIN WORKER ON WORKERSKILL.NAME = WORKER.NAME
GROUP BY NAME, LODGING, AGE
;

--8. Using only the ACTION=‘SOLD’ rows in LEDGER 
-- write a query that shows PERSON, MONTH (ACTIONDATE’s month)and TOT_AMT (SUM(QUANTITY*RATE))
--Show subtotals for PERSON, MONTH using ROLLUP 
-- On the subtotal lines use the GROUPING  and DECODE to show “All persons”, “All months” for their respective subtotal lines

SELECT DECODE(GROUPING(PERSON), 1, 'ALL PERSONS', PERSON) PERSONS, DECODE(GROUPING(TO_CHAR(ACTIONDATE, 'MONTH')), 1, 'ALL MONTHS', TO_CHAR(ACTIONDATE, 'MONTH')) MONTHS, SUM(QUANTITY*RATE)TOT_AMT
FROM LEDGER
WHERE ACTION = 'SOLD'
GROUP BY ROLLUP(TO_CHAR(ACTIONDATE, 'MONTH')), PERSON
;


