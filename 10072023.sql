
--NUMBER FUNCTIONS--

--FLOOR:
select salary ,floor(salary) from hr.hr_employees he  

--CEIL: 
select salary ,ceil (salary) from hr.hr_employees he  

--DATE FUNCTIONS

select CURRENT_DATE -- returns current date

select CURRENT_TIME -- returns current time

-- To return current time and date 
--1st way
select CURRENT_TIMESTAMP 

--2nd way
select now()

--TO_DATE: returns a character array to date format

select to_date('1994-06-07 00:00:00.000','yyyy-mm-dd')


--extract:  extracts a certain unit (year, month, day, hour, minute) from a certain date or time value

select extract (year from hire_date) AS yil from hr.hr_employees he 

select extract (month  from hire_date) AS ay from hr.hr_employees he 

--DATE_PART:

select 
hire_date, date_part('year',hire_date)
from hr.hr_employees he
where date_part('year',hire_date)<1990


--COALESCE (ORACLE NVL)

select 
employee_id , 
commission_pct,
coalesce (commission_pct::varchar, '-') as commission_pct  from hr.hr_employees he 

--CASE
--you can do the same thing that you made above by using case

--Example-1
select 
employee_id , 
commission_pct,
case when commission_pct::varchar is null then '-'
else commission_pct::varchar end as commission_pct
from hr.hr_employees he 

--Example-2
select 
department_id,
case 
	when department_name ='IT' then 'Information Technology'
	when department_name ='IT Support' then 'Information Technology Support' 
	when department_name ='IT Helpdesk' then 'Information Technology Helpdesk' 
	else department_name end as department_name,
case 
	when manager_id::varchar is null then 'NODATA'
	else manager_id::varchar end as manager_id,
location_id
from hr.hr_departments hd  


--GROUP BY + AVG,SUM,MIN,MAX,COUNT

select job_id, count(*) from hr.hr_employees he 
group by job_id
order by 2 desc

select job_id, count(*) from hr.hr_employees he 
group by job_id 
having count(*)>5
order by 2 desc

select job_id , avg(salary) from hr.hr_employees he 
group by job_id
order by 2 desc

select job_id , sum(salary) from hr.hr_employees he 
group by job_id
order by 2 desc

select job_id ,max(salary) from hr.hr_employees he 
group by job_id
order by 2 desc

select job_id ,min(salary) from hr.hr_employees he 
group by job_id
order by 2 DESC

--JOIN--

--INNER

SELECT  
hd.department_id , 
hd.department_name , 
hl.city  
FROM hr.hr_departments hd , hr.hr_locations hl 
WHERE hd.location_id = hl.location_id 

--

SELECT 
he.employee_id ,
he.first_name ,
he.last_name ,
hd.department_name ,
he.manager_id 
FROM hr.hr_departments hd
INNER JOIN hr.hr_employees he ON hd.manager_id = he.manager_id --44

--Çoklama var mı kontrol edelim.
SELECT 
he.employee_id ,
he.first_name ,
he.last_name ,
hd.department_name ,
he.manager_id ,
count(*)
FROM hr.hr_departments hd
INNER JOIN hr.hr_employees he ON hd.manager_id = he.manager_id 
GROUP BY  he.employee_id ,he.first_name ,he.last_name ,hd.department_name ,he.manager_id 
HAVING count(*)>1 


SELECT  
count(*) 
FROM hr.hr_employees he 
WHERE manager_id IN 
(
SELECT  
manager_id 
FROM hr.hr_departments hd
WHERE manager_id IS NOT NULL
) --44

--LEFT

SELECT 
he.first_name , 
he.last_name ,
he.department_id ,
hd.department_name 
FROM hr.hr_employees he 
LEFT JOIN hr.hr_departments hd ON he.department_id  = hd.department_id --107

--RIGHT

SELECT 
he.first_name , 
he.last_name ,
he.department_id ,
hd.department_name 
FROM hr.hr_employees he 
RIGHT JOIN hr.hr_departments hd ON he.department_id  = hd.department_id --122

--122'yi açıklayalım.

SELECT department_id  FROM hr.hr_departments
EXCEPT 
SELECT department_id FROM hr.hr_employees he --There are 16 ids in hr_departments that are not in hr_employees.

SELECT department_id FROM hr.hr_employees he
EXCEPT
SELECT department_id  FROM hr.hr_departments -- There is 1 id in hr_employees but not in hr_departments.

SELECT 107 + 16 -1 --122
 
--FULL 

SELECT 
he.first_name , 
he.last_name ,
he.department_id ,
hd.department_name 
FROM hr.hr_employees he 
FULL JOIN hr.hr_departments hd ON he.department_id  = hd.department_id 

--KARTEZYEN ÇARPIM

-- generates a result set containing all possible combinations of two or more tables.
-- Even if there is no relationship between the two tables, the cartesian product joins all rows in both tables.

SELECT * FROM hr.hr_employees, hr.hr_job_history--1070

SELECT * FROM hr.hr_employees CROSS JOIN hr.hr_job_history --1070

--SET OPERATORS
--UNION, UNION ALL, INTERSECT, EXCEPT(Oracle: MINUS)

--UNION

SELECT * FROM hr.hr_employees he 
WHERE job_id in ('AD_PRES','IT_PROG')
UNION
SELECT * FROM hr.hr_employees he 
WHERE job_id = 'IT_PROG' --6

--UNION ALL

SELECT * FROM hr.hr_employees he 
WHERE job_id in ('AD_PRES','IT_PROG')
UNION ALL
SELECT * FROM hr.hr_employees he 
WHERE job_id = 'IT_PROG' --11 (IT_PROG taken twice.)

--INTERSECT

SELECT employee_id  FROM hr.hr_employees he 
INTERSECT 
SELECT employee_id FROM hr.hr_job_history hjh 

--or you can do this:

SELECT DISTINCT he.employee_id  FROM hr.hr_employees he 
INNER JOIN hr.hr_job_history hj ON hj.employee_id = he.employee_id 

--EXCEPT

SELECT employee_id  FROM hr.hr_employees he 
EXCEPT 
SELECT employee_id  FROM hr.hr_job_history hjh -- employeE_id's are in hr_employees but not in hr_job_history