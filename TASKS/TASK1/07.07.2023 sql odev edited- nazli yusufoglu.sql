select job_id , count(job_id)
from hr.hr_job_history hjh 
where job_id not ilike '%A%'
group by job_id 
having count(job_id) > 1;
------------------------------------------------------------------------------
select job_id, count(job_id) 
from hr.hr_employees he 
where salary < 5
group by job_id 
------------------------------------------------------------------------------
select employee_id , 
concat (hr.hr_employees.first_name, ' ', hr.hr_employees.last_name), 
job_id 
from hr.hr_employees 
where salary > 10 and salary <20
-------------------------------------------------------------------------------
select country_name -- en kisa
from hr.hr_countries hc 
order by Length(country_name) asc , country_name 
limit  1


select country_name  -- en uzun
from hr.hr_countries hc 
order by Length(country_name) desc , country_name 
limit  1
------------------------------------------------------------------------------------

select country_name
from hr.hr_countries hc 
where(country_name like '%a' or 
	  country_name like '%e' or
	  country_name like '%i' or
	  country_name like '%o' or
	  country_name like '%u' )
	  and 
	( country_name ilike 'a%' or 
	  country_name ilike 'e%' or
	  country_name ilike 'i%' or
	  country_name ilike 'o%' or
	  country_name ilike 'u%' )
	  