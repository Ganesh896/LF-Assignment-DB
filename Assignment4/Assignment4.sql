CREATE TABLE employees(
	emp_id serial primary key,
    first_name varchar(100),
    last_name varchar(100),
    sex varchar(20),
    date_of_join date,
    currentDate date,
    designation varchar(50),
    age int,
    salary int,
    unit varchar(100),
    leaves_used int,
    leaves_remaining int,
    ratings int,
    past_exp int
);

--DATE FORMATE ISSUE SO using 2nd TABLE that use text for date date (yyyy-mm-dd) in csv file (mm-dd-yyyy)
CREATE TABLE employees_staging(
    first_name varchar(100),
    last_name varchar(100),
    sex varchar(20),
    date_of_join text,
    currentDate text,
    designation varchar(50),
    age int,
    salary int,
    unit varchar(100),
    leaves_used int,
    leaves_remaining int,
    ratings int,
    past_exp int
);
 
COPY employees_staging FROM 'D:\employees-data.csv' DELIMITER ',' CSV HEADER;

--copying data to employees table from employees_staging
INSERT INTO employees (
    first_name,
    last_name,
    sex,
    date_of_join,
    currentDate,
    designation,
    age,
    salary,
    unit,
    leaves_used,
    leaves_remaining,
    ratings,
    past_exp
)
SELECT 
    first_name,
    last_name,
    sex,
    TO_DATE(date_of_join, 'MM-DD-YYYY'),
    TO_DATE(currentDate, 'MM-DD-YYYY'),
    designation,
    age,
    salary,
    unit,
    leaves_used,
    leaves_remaining,
    ratings,
    past_exp
FROM 
    employees_staging;

--droping table after copying data of employees_staging table to employees table
DROP TABLE employees_staging;

--(1) Calculate the average salary by department for all Analysts? (CTE)
WITH average_salary AS (
SELECT unit AS department, AVG(salary) AS average_salary, designation
FROM employees
WHERE designation LIKE '%Analyst'
	GROUP BY unit, designation
)
SELECT *
	FROM average_salary;

--(2) List all employees who have used more than 10 leaves? (CTE)
WITH employees_with_leaves AS (
	SELECT emp_id, first_name, last_name, leaves_used
	FROM employees
	WHERE leaves_used>10
)
SELECT *
	FROM employees_with_leaves;

--(3) Create a view to show the details of all Senior Analysts. (VIEW)
CREATE VIEW senior_analysts AS (
	SELECT emp_id, first_name, last_name, designation
	FROM employees
	WHERE designation='Senior Analyst'
);

SELECT *
FROM senior_analysts;

--(4) Create a materialized view to store the count of employees by department (Materialized VIEW)
CREATE MATERIALIZED VIEW employees_in_department AS (
	SELECT unit as department, COUNT(unit) as employees_number
	FROM employees
	GROUP BY unit
);

SELECT *
FROM employees_in_department;

--(5) Create a procedure to update an employee's salary by their first name and last name. (Stored Procedures)
CREATE OR REPLACE PROCEDURE update_salary (
	e_first_name varchar,
	e_last_name varchar,
	amount int
)
LANGUAGE plpgsql
AS $$
BEGIN
     UPDATE employees
     SET salary = salary + amount
     WHERE first_name = e_first_name AND last_name = e_last_name;
	COMMIT;
END;$$;

CALL update_salary('TOMASA', 'ARMEN', 10000);

SELECT * FROM employees;

--(6) Create a procedure to calculate the total number of leaves used across all departments (Stored Procedures)
CREATE OR REPLACE PROCEDURE total_leaves()
LANGUAGE plpgsql
AS $$
BEGIN
	CREATE VIEW total_leaves AS (
		--total leaves of each departments
		SELECT unit as department, SUM(leaves_used) as total_leaves
		FROM employees
		GROUP BY unit

		-- total leaves all across departments
		/*SELECT SUM(leaves_used) as total_leaves
		FROM employees */
	);

	COMMIT;
END;$$;

CALL total_leaves();

SELECT * FROM total_leaves;