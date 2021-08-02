
-- retirement_titles.csv
SELECT
	em.emp_no,
	em.first_name,
	em.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO out_retirement_titles
FROM
	employees AS em
	LEFT JOIN
		titles AS ti
		ON ti.emp_no = em.emp_no

WHERE 
	(em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
		
ORDER BY em.emp_no, ti.title;



-- Use Dictinct with Orderby to remove duplicate rows
-- unique_titles.csv
SELECT DISTINCT ON (em.emp_no)
	em.emp_no,
	em.first_name,
	em.last_name,
	ti.title

INTO out_unique_titles
FROM
	employees AS em
	LEFT JOIN
		titles AS ti
		ON ti.emp_no = em.emp_no
WHERE 
	(em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY
	em.emp_no ASC, ti.to_date DESC;
	

-- Count by title
--retiring_titles.csv
SELECT
	count(ut.emp_no),
	ut.title
INTO out_retiring_titles
FROM
	out_unique_titles as ut
GROUP BY
	ut.title
ORDER BY
	count(ut.emp_no) DESC;
	

-- Write a query to create a Mentorship Eligibility table 
-- that holds the employees who are eligible to participate in a mentorship program.

-- mentorship_eligibilty.csv
SELECT DISTINCT ON(em.emp_no)
	em.emp_no,
	em.first_name,
	em.last_name,
	em.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO out_mentorship_eligibilty
FROM
	employees as em
	INNER JOIN dept_emp as de
		ON de.emp_no = em.emp_no
	INNER JOIN titles as ti
		ON ti.emp_no = em.emp_no 
WHERE 
	(em.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND
	(ti.to_date = '9999-01-01')
ORDER BY
	em.emp_no ASC;
	



