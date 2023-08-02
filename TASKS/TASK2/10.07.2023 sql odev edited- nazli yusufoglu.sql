select hl.location_id, hl.city, hl.state_province, hc.country_name, hr.region_name 
from hr.hr_locations hl 
left join hr.hr_countries hc 
on hc.country_id = hl.country_id 
left join hr.hr_regions hr 
on hr.region_id = hc.region_id 
---------------------------------------------------------------------------------------------------------
select he.employee_id  ,
	   (first_name || ' '|| last_name) as full_name, 
	   hl2.street_address , 
	   hl2.city  
from hr.hr_locations hl2 
join hr.hr_departments hd 
on hl2.location_id = hd.location_id 
join  hr.hr_employees he 
on hd.department_id = he.department_id 
where he.department_id is not null --burda he.department_id ve hd.department_id aynı sonucu veriyor

-----------------------------------------------------------------------

select hd.department_id 
from hr.hr_departments hd 
where hd.manager_id is not null
union
select he.department_id 
from hr.hr_employees he 
where he.department_id is not null

------------------------------------------------------------------------------------
select round(avg(salary),3)  
from hr.hr_departments hd 
inner join hr.hr_employees he 
on he.department_id= hd.department_id 
WHERE hd.department_id IN ('100', '20')





