-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	);
	
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Send elegible personel to table retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;




-- Create new table for current employees retiring
DROP TABLE out_retirement_info;


SELECT
	em.emp_no, 
	em.first_name, 
	em.last_name,
	em.gender,
	em.birth_date,
	em.hire_date,
	d.dept_name
INTO 
	out_retirement_info
FROM 
	employees as em
INNER JOIN
	dept_emp as d_e
		ON d_e.emp_no = em.emp_no
INNER JOIN
	departments as d
		ON d.dept_no = d_e.dept_no
WHERE 
	d_e.to_date = ('9999-01-01')
	AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT * FROM out_retirement_info;



-- Joining departments and dept_manager tables
SELECT 
	d.dept_name,
    dm.emp_no,
    dm.from_date,
    dm.to_date
FROM
	departments as d
INNER JOIN 
	dept_manager as dm	ON d.dept_no = dm.dept_no;


-- Joining retirement_info and dept_emp tables
SELECT 
	ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM
	retirement_info as ri
LEFT JOIN
	dept_emp as de
ON
	ri.emp_no = de.emp_no;

-- Current employees by department
DROP TABLE out_current_emp;

SELECT 
	em.emp_no,
    em.first_name,
    em.last_name,
	de.dept_no,
	d.dept_name,
	de.to_date
INTO
	out_current_emp
FROM
	employees as em
LEFT JOIN
	dept_emp as de
		ON de.emp_no = em.emp_no
LEFT JOIN
	departments as d
		ON d.dept_no = de.dept_no
WHERE 
	de.to_date = ('9999-01-01');

SELECT * FROM out_current_emp;


-- Current Employees Count by department
DROP TABLE out_current_emp_count_by_dept;

SELECT
	dept_name,
	count(emp_no) as active_employees
INTO
	out_current_emp_count_by_dept
FROM
	out_current_emp as oce
GROUP BY
	dept_name
ORDER BY
	count(emp_no) DESC;
	
SELECT * FROM out_current_emp_count_by_dept;


-- Retiring Employees Count by department
DROP TABLE out_retiring_emp_count_by_dept;


SELECT
	dept_name,
	count(emp_no) as retiring_employees
INTO
	out_retiring_emp_count_by_dept
FROM
	out_retirement_info
GROUP BY
	dept_name
ORDER BY
	count(emp_no) DESC;
	
	
SELECT * FROM out_retiring_emp_count_by_dept;


-- Join active and retiring

SELECT
	cu.dept_name,
	cu.active_employees,
	re.retiring_employees,
	CAST(re.retiring_employees as DECIMAL(12,0)) / CAST(cu.active_employees as DECIMAL(12,0)) as department_perc
FROM
	out_retiring_emp_count_by_dept as re
LEFT JOIN
	out_current_emp_count_by_dept as cu
		ON cu.dept_name = re.dept_name
	
	

-- current employees to retire
SELECT 
	ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO
	current_emp
FROM
	retirement_info as ri
LEFT JOIN
	dept_emp as de
	ON ri.emp_no = de.emp_no
WHERE 
	de.to_date = ('9999-01-01');
	

-- Employee count by department number
SELECT 
	COUNT(ce.emp_no), 
	de.dept_no
INTO
	Out_employees_to_retire_by_department
FROM 
	current_emp as ce
LEFT JOIN 
	dept_emp as de
		ON ce.emp_no = de.emp_no
GROUP BY
	de.dept_no
ORDER BY 
	de.dept_no;


-- Employee count by department number
SELECT 
	COUNT(oce.emp_no), 
	de.dept_no
-- INTO
	-- Out_employees_to_retire_by_department
FROM 
	out_current_emp as oce
LEFT JOIN 
	dept_emp as de
		ON oce.emp_no = de.emp_no
LEFT JOIN
	departments as d
		ON d.dept_no = oce.dept_no
GROUP BY
	de.dept_no
	
ORDER BY 
	de.dept_no;


-- 1.- List of Employees
DROP TABLE out_emp_info;

SELECT 
	e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
	e.birth_date,
	e.hire_date,
    s.salary,
    de.to_date
INTO
	out_emp_info
FROM
	employees as e
INNER JOIN 
	salaries as s
		ON (e.emp_no = s.emp_no)
INNER JOIN 
	dept_emp as de
		ON (e.emp_no = de.emp_no)
WHERE 
	(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND 
	(e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND 
	(de.to_date = '9999-01-01');
	
Select * From out_emp_info;
	
-- 2. List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		

-- 3. Department Retirees
SELECT
	ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
--INTO dept_info
FROM
	out_current_emp as ce
INNER JOIN 
	dept_emp AS de
		ON (ce.emp_no = de.emp_no)
INNER JOIN
	departments AS d
		ON (de.dept_no = d.dept_no);
		
SELECT * FROM current_emp

-----------------------------------------------------------------

SELECT * FROM out_retirement_titles

-- Last Title per Employee
DROP TABLE out_last_title;


SELECT DISTINCT ON (emp_no)
	emp_no,
	title,
	to_date
INTO
	out_last_title
FROM
	titles
ORDER BY
	emp_no ASC,
	to_Date DESC;
	
	
SELECT * FROM out_last_title;
