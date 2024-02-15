--it is possible to perform vertical and horizontal selections

select * from hr.hr_employees he 

--selecting the desired columns

select first_name, last_name  from hr.hr_employees he

--selecting a desired line

select * from hr.hr_employees he
where employee_id = 144

--selecting an interval

select * from hr.hr_employees he
where employee_id > 100 and employee_id < 110

-----------------------------------------ALIAS----------------------------------------------------

select job_id as id, job_title as ünvan, min_salary as en_düşük_maaş, max_salary as en_yüksek_maaş from hr.hr_jobs j 
--If an alias is formed with multiple words, it is mandatory to put a character, '_' in general, between them.

----------------------------------ARİTMETİK OPERATÖRLER-------------------------------------------

--Addition operation (+):
 
SELECT 5 + 3; -- Sonuç: 8

--Subtraction operation (-):

SELECT 10 - 4; -- Sonuç: 6

--Multiplication operation (*): 

SELECT 6 * 2; -- Sonuç: 12

--Division operation (/): 

SELECT 15 / 4; -- Sonuç: 3.75

--Mod (%): It returns remainder

SELECT mod(15, 4); -- Sonuç: 3

SELECT 15 % 4; -- Sonuç: 3

--Power (^): It takes the power of a number

SELECT 2 ^ 3; -- Sonuç: 8

--Negative(-):

SELECT -7; -- Sonuç: -7

--Square root(sqrt): 

SELECT sqrt(25); -- Sonuç: 5

--Cube root (cbrt):

SELECT cbrt(27); -- Sonuç: 3

-------------------------------------------CONCAT----------------------------------------------------

select first_name ||' '|| last_name as full_name from hr.hr_employees he 

-- pipeline (|) is used to combine fields

-------------------------------------------DISTINCT----------------------------------------------------

--distinct is used to combine datas in a column without repetitions. There are alternative methods.

--Example 1-
select distinct job_id  from hr.hr_employees he --19

--Example 2-
select t.job_id from (
select 
employee_id, 
job_id,
row_number() over (partition by job_id order by employee_id desc) as sira
from hr.hr_employees he ) t
where t.sira=1 --19 

--Row_number dönen satırlara sıra numarası atamak için kullanılmaktadır. 
--Job_id kolonuna göre gruplayıp employee_id'ye göre sıralar ve numara ataması yapar. 
--İç içe select metodu ile sıştaki select'in koşuluna yalnızca sıra numarası 1 olanlarlı al 
--dediğimizde unique bir şekilde datalar gelmiş olacaktır.

-------------------------------------------DESCRIBE----------------------------------------------------

--'describe hr.hr_job_history' Oracle DB için kullanılan bir metoddur. 
--PostgreSQL DB'de bir tablonun detaylarına bakmak için aşağıdaki sorgu yazılabilir.

select * from hr.hr_job_history

SELECT *
--column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'hr' AND table_name = 'hr_job_history';

-------------------------------------------WHERE----------------------------------------------------

--Çalıştıracağımız sorguyu sınırlamak, koşullandırmak ... istiyorsak where kullanılabilir. 
--Bu konu hakkında çok çeşitli örnekler yapılabilir.

select * from hr.hr_employees
where first_name ='Steven' -- İlk ismi 'Steven' olan satırı/satırları getir.

select 
first_name||' '||last_name as full_name, 
department_id 
from hr.hr_employees
where salary > 15

select department_name from hr.hr_departments
where department_id = 90 --Executive (Yönetici)


--------------------------------COMPARISON FUNCTIONS AND OPERATORS---------------------------------

-- =, >, >=, <, <=, <>, between ... and ..., in, like, is null 

select * from hr.hr_employees
where salary = 4.2 

select * from hr.hr_employees
where salary > 20

select * from hr.hr_employees
where salary >= 16

select * from hr.hr_employees
where salary < 2.5

select * from hr.hr_employees
where salary <= 2.5

select * from hr.hr_employees
where salary <> 3

select * from hr.hr_employees
where salary between 15 and 20 --2

select * from hr.hr_employees
where salary not between 15 and 20 --105

select * from hr.hr_employees
where job_id in ('AD_PRES','AD_VP' ) --3

select * from hr.hr_employees
where job_id not in ('AD_PRES','AD_VP' ) --104

select * from hr.hr_employees
where commission_pct is null --72

select * from hr.hr_employees
where commission_pct is not null --35

--LIKE, ILIKE
--LIKE ile ILIKE farkını kısaca şöyle anlatabiliriz. LIKE büyük küçük karakter ayrımı yapar. ILIKE'da büyük küçük ayrımı yoktur.

select * from hr.hr_employees 
where first_name  like 'St%' --first_name St ile başlayanları getir.

select * from hr.hr_employees 
where first_name  like '%en' --first_name en ile bitenleri getir.

select * from hr.hr_employees 
where cast(hire_date as varchar) like '%2000%' --İşe alım tarihinde bir yerlerde 2000 geçen bütün dataları getir.
--LIKE operatörü karakter dizileri üzerinde kullanılır. 

select * from hr.hr_employees 
where first_name  ilike 'st%' --first_name St ile başlayanları getir. --3

select * from hr.hr_employees 
where first_name  like 'st%' --first_name St ile başlayanları getir. --0

--ORDER BY--
--It is used to order selection. ASC as ascending, DESC as descending. 

select * from hr.hr_employees he 
order by salary --if it's not specified, the default ordering method is ascending

select * from hr.hr_employees he 
order by salary desc

--ASSIGNING VARIABLES--
--In PostgreSQL we use ':', In Oracle DB we use '&'.

SELECT * FROM hr.hr_employees WHERE manager_id = :man_id;
--CASE-MANIPULATIVE FUNCTIONS--
--Lower, upper and initcap are some of mostly used character functions. 
--Lower makes lowercase the selected query, upper makes them uppercse and initcap capitalizes the first letter.

select lower(first_name)  from hr.hr_employees he 

select upper(first_name)  from hr.hr_employees he 

select initcap(lower(first_name))  from hr.hr_employees he 

select initcap('berk') 

select upper('ışıl') --this function may corrupt Turkish letters

--CHARACTER-MANIPULATIVE FUNCTIONS--
--Some of the mostly used functions; length, position(oracle:instr), lpad, rpad and replace

select 
first_name,
last_name,
(first_name || ' '|| last_name) as full_name,
length(first_name || ' '|| last_name), --returns character length
position('a' in first_name), --finds the location of a letter, it returns 0 if there isn't any
(lpad(first_name,15,'*') || ' ' || rpad(last_name ,15,'*')) as deneme, --inserts a character from left
--p.s: it doesn't add 15 characters however it adds till it becomes 15 characters length
replace(phone_number ,'.','') as telefon_numarası-- removes characters
from hr.hr_employees he 


--If we want to use full_name alias in lenght function we should use nested selection.
select full_name, length(full_name)  from (
select 
first_name,
last_name,
(first_name || ' '|| last_name) as full_name
from hr.hr_employees) t

--p.s: Substring and trim functions are used often. 

--TRIM
select trim('  berk') --we removed the space. it can perform an important role in join operations. 

select ltrim('  berk') 

select ltrim('berk', 'b') --also it removes the leftmost character

select rtrim('berk  ') 

select rtrim('berk', 'k')

select btrim(' berk ') 

--SUBSTRING

select phone_number ,
(SUBSTRING(phone_number , 1, position ('.' in phone_number) -1)) as ilk_noktaya_kadar,
(SUBSTRING(phone_number , 5, position ('.' in phone_number) -1)) as ikinci_noktaya_kadar
from hr.hr_employees he