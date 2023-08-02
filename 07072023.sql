----------------------------------------SELECT----------------------------------------------------
--Dikey ve yatay olarak seçim gerçekleştirmek mümkündür. 

select * from hr.hr_employees he 

--İstenilen kolonları seçmek istersek;

select first_name, last_name  from hr.hr_employees he

--Yalnızca belirli bir satırı seçmek istersek;

select * from hr.hr_employees he
where employee_id = 100

--Yalnızca belirli bir aralıktaki satırları seçmek istersek;

select * from hr.hr_employees he
where employee_id > 100 and employee_id < 110

-----------------------------------------ALIAS----------------------------------------------------

select job_id as id, job_title as ünvan, min_salary as en_düşük_maaş, max_salary as en_yüksek_maaş from hr.hr_jobs j 
--Eğer vereceğimiz alias birden fazla kelimeden oluşuyorsa mutlaka birleştirmek için arasına bir karakter koymak gerekmektedir. 
--Genellikle '_' koyulur.

----------------------------------ARİTMETİK OPERATÖRLER-------------------------------------------

--Toplama (+): İki değeri toplar.
 
SELECT 5 + 3; -- Sonuç: 8

--Çıkarma (-): İki değeri birbirinden çıkarır. 

SELECT 10 - 4; -- Sonuç: 6

--Çarpma (*): İki değeri çarpar. 

SELECT 6 * 2; -- Sonuç: 12

--Bölme (/): Bir değeri diğerine böler. Bölme işlemi, tam sayı bölmelerinde sonucu ondalıklı sayı olarak döndürür. 

SELECT 15 / 4; -- Sonuç: 3.75

--Mod (%): Bir değerin diğerine bölümünden kalanı döndürür. 

SELECT mod(15, 4); -- Sonuç: 3

SELECT 15 % 4; -- Sonuç: 3

--Üs Alma (^): Bir değerin diğer değerin üssünü alır. 

SELECT 2 ^ 3; -- Sonuç: 8

--Negatif (-): Bir değerin negatifini döndürür. 

SELECT -7; -- Sonuç: -7

--Karekök (sqrt): Bir değerin karekökünü döndürür. 

SELECT sqrt(25); -- Sonuç: 5

--Küpkök (cbrt): Bir değerin küpkökünü döndürür. 

SELECT cbrt(27); -- Sonuç: 3

-------------------------------------------CONCAT----------------------------------------------------

select first_name ||' '|| last_name as full_name from hr.hr_employees he 

-- pipeline (|) kullanarak rahatlıkla istenilen alanlar birleştirilebilir.

-------------------------------------------DISTINCT----------------------------------------------------

--Bir kolondaki dataları tekrarlamayacak şekilde seçmek için distinct kullanılmaktadır. Farklı metodlar da mevcuttur. 

--Örnek 1-
select distinct job_id  from hr.hr_employees he --19

--Örnek 2-
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
--Seçimi sıralamaya yarayan operatördür. ASC artan, DESC azalan yönde sıralama yapar. 

select * from hr.hr_employees he 
order by salary --eğer asc veya desc belirtmezsek default olarak asc yapar. 

select * from hr.hr_employees he 
order by salary desc

--DEĞİŞKEN ATAMA--
--PostgreSQL'de : ile yapabiliyoruz, oracle db'de & ile yapabiliyoruz.

SELECT * FROM hr.hr_employees WHERE manager_id = :man_id; --PostgreSQL'de : ile yapabiliyoruz, oracle db'de & ile yapabiliyoruz.

--KARAKTER SORGULARI--
--Lower, upper ve initcap sıklıkla kullanılan karakter fonksiyonlarıdır. 
--Lower belirtilen karakterlerin tamamını küçültür, upper hepsini büyük yapar ve initcap yalnızca baş harfini büyük yapar.

select lower(first_name)  from hr.hr_employees he 

select upper(first_name)  from hr.hr_employees he 

select initcap(lower(first_name))  from hr.hr_employees he 

select initcap('berk') 

select upper('ışıl') --Bu fonksiyonu kullanırken dikkat edilmesi gereken nokta türkçe tutulmuş verileri bozabilir. 

--KARAKTER İŞLEME FONKSİYONLARI
--Sıklıkla kullanılan fonksiyonlar; length, position(oracle:instr), lpad, rpad ve replace

select 
first_name,
last_name,
(first_name || ' '|| last_name) as full_name,
length(first_name || ' '|| last_name), --karakter uzunluğunun söyler.
position('a' in first_name), --isim içerisinden a kaçıncı harftir bunu belirtir hiç yoksa 0 yazar. 
(lpad(first_name,15,'*') || ' ' || rpad(last_name ,15,'*')) as deneme, --lpad alanın solunu belirtilen karakter ile doldurur. 
--Burada 15 birim * ile doldurmaz karakter uzunluğunu 15'e tamamlar. rpad için de tam tersi geçerlidir.
replace(phone_number ,'.','') as telefon_numarası-- .'yı kaybet der.
from hr.hr_employees he 


--Eğer length fonksiyonun içerisinde full_name alias'ını kullanmak istiyorsak iç içe select kullanmalıyız.
select full_name, length(full_name)  from (
select 
first_name,
last_name,
(first_name || ' '|| last_name) as full_name
from hr.hr_employees) t

--EK: Substring ve trim fonksiyonları da sık kullanılmaktadır. 

--TRIM
select trim('  berk') --Boşluğu kaldırmış bulunduk. join işlemlerinde dataların eşleşmesi için bazen çok önemli rol oynayabilir. 

select ltrim('  berk') 

select ltrim('berk', 'b') --Ayrıca sol tarafta belirtilen karakteri de siler. 

select rtrim('berk  ') 

select rtrim('berk', 'k')

select btrim(' berk ') 

--SUBSTRING

select phone_number ,
(SUBSTRING(phone_number , 1, position ('.' in phone_number) -1)) as ilk_noktaya_kadar,
(SUBSTRING(phone_number , 5, position ('.' in phone_number) -1)) as ikinci_noktaya_kadar
from hr.hr_employees he