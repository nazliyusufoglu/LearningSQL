-------------------------ALT SORGULAR------------------------
--TEK SATIRLI, ÇOK SATIRLI(IN'ILE)

SELECT
employee_id , first_name 
FROM hr.hr_employees he 
WHERE salary = (SELECT max(salary) FROM hr.hr_employees he2)

SELECT employee_id , first_name  FROM hr.hr_employees he 
WHERE salary IN (SELECT salary FROM hr.hr_employees he2 WHERE salary BETWEEN 2 AND 10)

-------------------------ANY OPERATORU-----------------------
--=ANY:IN ile eşdeğerdir.
--<ANY:En büyükten daha küçük
-->ANY:En küçükten daha büyük


--=ANY

SELECT employee_id , first_name  FROM hr.hr_employees he 
WHERE salary =ANY (SELECT salary FROM hr.hr_employees he2 WHERE salary BETWEEN 2 AND 10) 

--<ANY

SELECT employee_id , first_name,salary  FROM hr.hr_employees he 
WHERE salary <ANY (SELECT salary FROM hr.hr_employees he2 WHERE job_id = 'IT_PROG')
ORDER BY salary 

-->ANY

SELECT employee_id , first_name,salary  FROM hr.hr_employees he 
WHERE salary >ANY (SELECT salary FROM hr.hr_employees he2 WHERE job_id = 'IT_PROG')
ORDER BY salary



-----------------------------ALL-----------------------------
--<ALL: En küçükten daha küçük

-->ALL: En büyükten daha büyük

SELECT employee_id , first_name,salary  FROM hr.hr_employees he 
WHERE salary <ALL (SELECT salary FROM hr.hr_employees he2 WHERE job_id = 'IT_PROG')
ORDER BY salary

SELECT employee_id , first_name,salary  FROM hr.hr_employees he 
WHERE salary >ALL (SELECT salary FROM hr.hr_employees he2 WHERE job_id = 'IT_PROG')
ORDER BY salary

--SORU: <Any veya >ANY fonksiyonlarında en büyük değerden küçük değerleri
--sıralarken mesela biz en büyük 3 değerden daha küçükleri sıralamak
--istediğimiz bir senaryoda hızlı kısa yolu var mı yada nasıl bir yöntem izleriz

--En büyük üç salary dışında kalan salary'leri büyükten küçüğe sıraladık.

--Kerim

SELECT t.full_name, t.salary FROM (
SELECT 
employee_id ,
first_name || ' ' || last_name AS full_name,
salary ,
ROW_NUMBER() OVER (ORDER BY salary desc) AS sira 
FROM hr.hr_employees he 
ORDER BY salary DESC) t
WHERE t.sira NOT IN (1,2,3)



--Nazlı

select *
from hr.hr_employees he 
where he.department_id = 50
AND he.hire_date < ANY (ARRAY[(current_timestamp)]) --En büyükten daha küçükler için 
order by hire_date DESC --En büyük hire date istiyoruz
limit 1


--------------------------SORULAR---------------------------


--1) Country_id'si DE,IL ve IN olan çalışanları bulunuz.

--Beklenen çıktı:
--204	Hermann Baer	10.000	Public Relations	Schwanthalerstr. 7031	Munich	Germany

SELECT 
he.employee_id ,
concat(first_name,' ',last_name) full_name,
he.salary ,
hd.department_name ,
hl.street_address ,
hl.city ,
hc.country_name 
FROM hr.hr_employees he 
JOIN hr.hr_departments hd ON he.department_id = hd.department_id 
JOIN hr.hr_locations hl ON hd.location_id = hl.location_id 
JOIN hr.hr_countries hc ON hl.country_id = hc.country_id 
WHERE hc.country_id IN ('IN','DE','IL') 
--=any ('{"DE","IL","IN"}')


--2) Department_id'si 50 olup en son işe alınan çalışan kimdir?

SELECT * FROM hr.hr_employees he
WHERE hire_date IN (
SELECT max(hire_date) FROM hr.hr_employees he 
WHERE department_id = 50)

--3) Job_id'si IT_PROG ve ST_CLERK olan çalışanların aldıkları salary'i
-- içerisindeki en büyük salary'den daha büyük sonuçları yazdırınız.

--Not: > ALL operatörünün büyük küçük kullanımı sonucu etkilemez.

SELECT * FROM hr.hr_employees he 
WHERE salary > ALL (
SELECT salary FROM hr.hr_employees he 
WHERE job_id IN ('IT_PROG','ST_CLERK')) 
ORDER BY salary desc

select * from hr.hr_employees he 
where salary > all (
select salary from hr.hr_employees he 
where job_id in ('IT_PROG','ST_CLERK')) 
order by salary desc

--------------------TABLOYA KAYIT EKLEME--------------------- 

SELECT * FROM HR.TEST

DROP TABLE HR.TEST

CREATE TABLE HR.TEST
(
ID SERIAL PRIMARY KEY,
DESCRIPTION VARCHAR(55)
)

INSERT INTO HR.TEST
(DESCRIPTION)
VALUES ('BASKETBOL')

---------------BAŞKA BİR TABLODAN SATIR EKLEMEK--------------

SELECT * FROM HR.TEST

INSERT INTO HR.TEST
(DESCRIPTION)
SELECT upper(country_name) FROM hr.hr_countries hc 
WHERE country_id ='AR'

---------------TABLODAKİ VERİLERİ GÜNCELLEMEK----------------

SELECT * FROM HR.TEST
ORDER BY ID

UPDATE HR.TEST
SET DESCRIPTION='FUTBOL'
WHERE ID = 1 

-------------------TABLODAKİ VERİLERİ SİLMEK-----------------

SELECT * FROM HR.TEST

DELETE FROM HR.TEST
WHERE ID = 2

---------------------------TRUNCATE--------------------------

TRUNCATE TABLE HR.TEST

TRUNCATE TABLE HR.TEST RESTART IDENTITY

SELECT * FROM HR.TEST

--------------------COMMIT-ROLLBACK-SAVEPOINT----------------

TRUNCATE TABLE HR.TEST2 RESTART IDENTITY

DROP TABLE HR.TEST2

CREATE TABLE HR.TEST2 (
  ID SERIAL PRIMARY KEY,
  DESCRIPTION VARCHAR(55)
);

COMMIT;

START TRANSACTION;

INSERT INTO HR.TEST2 (DESCRIPTION) VALUES ('BASKETBOL');

INSERT INTO HR.TEST2 (DESCRIPTION) VALUES ('FUTBOL');

INSERT INTO HR.TEST2 (DESCRIPTION) VALUES ('VOLEYBOL');

SAVEPOINT MY_SAVEPOINT;

SELECT * FROM HR.TEST2
ORDER BY ID 

UPDATE HR.TEST2 
SET DESCRIPTION = 'HENTBOL'
WHERE id = 1;

ROLLBACK TO SAVEPOINT MY_SAVEPOINT;

-------------------------YORUM EKLEME------------------------
--TABLOYA YORUM EKLEMEK

COMMENT ON TABLE HR.TEST IS 'Bu tablo test tablosudur.';

--obj_description fonksiyonu doğrudan tablo adını kabul etmez.
--Bunun için regclass türüne dönüştürmeliyiz. Böylelikle fonksiyon doğru tablo oid değerini alır.
--Oid (object identifier), PostgreSQL veritabanında her veritabanı nesnesini (tablo, sütun, indeks, vb.) 
--benzersiz bir şekilde tanımlayan bir sayısal kimliktir.

SELECT obj_description('HR.TEST'::regclass)

--KOLONA YORUM EKLEMEK

COMMENT ON COLUMN HR.TEST.DESCRIPTION IS 'Bu sütuna karakter girilebilir.';

SELECT col_description('HR.TEST'::regclass, 2) AS DESCRIPTION

--------------------------CONSTRAINTS------------------------
--PK: Benzersizdir ve boş olmaz.
--FK: Tablolar arasındaki ilişkiyi gösterir. Başka bir tablonun PK'sıdır. 
--UNIQUE: Benzersiz değerlerin olduğu alanlar için kullanılabilir.
--CHECK: Alana girilebilicek değerleri kısıtlar.
--NOT NULL: Alana null değer girilemez kısıtlamasını getirir.

SELECT * FROM HR.HR_JOBS_TEST

CREATE TABLE HR.HR_JOBS_TEST(
JOB_ID VARCHAR(15) UNIQUE,
JOB_TITLE VARCHAR(50) NOT NULL,
MIN_SALARY DECIMAL(5,3) NOT NULL,
MAX_SALARY DECIMAL(5,3) NOT NULL);

INSERT INTO HR.HR_JOBS_TEST(
JOB_ID ,
JOB_TITLE,
MIN_SALARY ,
MAX_SALARY
)
VALUES
('AD_PRES','President',20.000,40.000),
('AD_VP','Administration Vice President',15.000,30.000),
('AD_ASST','Administration Assistant',3.000,6.000),
('FI_MGR','Finance Manager',8.200,16.000),
('FI_ACCOUNT','Accountant',4.200,9.000),
('AC_MGR','Accounting Manager',8.200,16.000),
('AC_ACCOUNT','Public Accountant',4.200,9.000),
('SA_MAN','Sales Manager',10.000,20.000),
('SA_REP','Sales Representative',6.000,12.000),
('PU_MAN','Purchasing Manager',8.000,15.000),
('PU_CLERK','Purchasing Clerk',2.500,5.500),
('ST_MAN','Stock Manager',5.500,8.500),
('ST_CLERK','Stock Clerk',2.000,5.000),
('SH_CLERK','Shipping Clerk',2.500,5.500),
('IT_PROG','Programmer',4.000,10.000),
('MK_MAN','Marketing Manager',9.000,15.000),
('MK_REP','Marketing Representative',4.000,9.000),
('HR_REP','Human Resources Representative',4.000,9.000),
('PR_REP','Public Relations Representative',4.500,10.500);

ALTER TABLE hr.hr_countries
ADD CONSTRAINT unique_country_id UNIQUE (COUNTRY_ID);

CREATE TABLE HR.HR_LOCATIONS_TEST(
LOCATION_ID DECIMAL(5,3) UNIQUE,
STREET_ADDRESS VARCHAR(100) NOT NULL,
POSTAL_CODE VARCHAR(15) NOT NULL,
CITY VARCHAR(25) NOT NULL,
STATE_PROVINCE VARCHAR(25),
COUNTRY_ID VARCHAR(5) NOT NULL,
CONSTRAINT fk_department FOREIGN KEY (COUNTRY_ID) REFERENCES hr.hr_countries (COUNTRY_ID)
);

INSERT INTO HR.HR_LOCATIONS_TEST(
LOCATION_ID,
STREET_ADDRESS,
POSTAL_CODE,
CITY,
STATE_PROVINCE,
COUNTRY_ID
)
VALUES
(1.000,'1297 Via Cola di Rie','00989','Roma','NULL','IT'),
(1.100,'93091 Calle della Testa','10934','Venice','NULL','IT'),
(1.200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo Prefecture','JP'),
(1.300,'9450 Kamiya-cho','6823','Hiroshima','NULL','JP'),
(1.400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US'),
(1.500,'2011 Interiors Blvd','99236','South San Francisco','California','US'),
(1.600,'2007 Zagora St','50090','South Brunswick','New Jersey','US'),
(1.700,'2004 Charade Rd','98199','Seattle','Washington','US'),
(1.800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA'),
(1.900,'6092 Boxwood St','YSW 9T2','Whitehorse','Yukon','CA'),
(2.000,'40-5-12 Laogianggen','190518','Beijing','NULL','CN'),
(2.100,'1298 Vileparle (E)','490231','Bombay','Maharashtra','IN'),
(2.200,'12-98 Victoria Street','2901','Sydney','New South Wales','AU'),
(2.300,'198 Clementi North','540198','Singapore','NULL','SG'),
(2.400,'8204 Arthur St','NULL','London','NULL','UK'),
(2.500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK'),
(2.600,'9702 Chester Road','09629850293','Stretford','Manchester','UK'),
(2.700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE'),
(2.800,'Rua Frei Caneca 1360 ','01307-002','Sao Paulo','Sao Paulo','BR'),
(2.900,'20 Rue des Corps-Saints','1730','Geneva','Geneve','CH'),
(3.000,'Murtenstrasse 921','3095','Bern','BE','CH'),
(3.100,'Pieter Breughelstraat 837','3029SK','Utrecht','Utrecht','NL'),
(3.200,'Mariano Escobedo 9991','11932','Mexico City','Distrito Federal,','MX');

--CHECK 

DROP TABLE hr.salary_test

CREATE TABLE hr.salary_test (
  salary_id SERIAL PRIMARY KEY,
  full_name varchar(100),
  salary float,
  CONSTRAINT check_positive CHECK (salary > 0)
);

INSERT INTO hr.salary_test(
full_name,
salary)
VALUES 
('Mehmet Okur', 2000.5),
('Hidayet Türkoğlu', 1600.7),
('Ersan İlyasova', 1200.8)

SELECT * FROM hr.salary_test

INSERT INTO hr.salary_test(
full_name,
salary)
VALUES 
('Ömer Aşık', -1000.3)



--------------------------ALTER TABLE------------------------
--Tablo üzerinde değişiklik yapmamızı sağlar.

--ADD COLUMN: Tabloya yeni bir sütun eklemek için kullanılır.
--DROP COLUMN: Tablodan bir sütunu silmek için kullanılır.
--ALTER COLUMN: Bir sütunun özelliklerini değiştirmek için kullanılır.
--RENAME COLUMN: Bir sütunun adını değiştirmek için kullanılır.
--ADD CONSTRAINT: Bir tabloya yeni bir kısıtlama (constraint) eklemek için kullanılır.
--DROP CONSTRAINT: Bir tablodan bir kısıtlamayı silmek için kullanılır.
--ALTER CONSTRAINT: Bir kısıtlamanın özelliklerini değiştirmek için kullanılır.

SELECT * FROM hr.salary_test

ALTER TABLE hr.salary_test
RENAME COLUMN salary_id TO id;

-------------------------------VIEW---------------------------
--VIEW PostgreSQL'de güncellenmemektedir. 
--Değiştirmek için drop edip tekrar istenilen şekilde yaratılabilir.

SELECT * FROM hr.employee_department_view

DROP VIEW hr.employee_department_view

CREATE VIEW hr.employee_department_view AS
SELECT he.employee_id , first_name , last_name , salary , hd.department_name  
FROM hr.hr_employees he 
LEFT JOIN hr.hr_departments hd  ON he.department_id = hd.department_id;


---------------------------SEQUENCE---------------------------
--Artan bir değer yaratmak için kullanılır.

CREATE SEQUENCE my_sequence
    START 100
    INCREMENT BY 5
    MINVALUE 0
    MAXVALUE 1000
    CYCLE;
   
SELECT * FROM information_schema.sequences WHERE sequence_name = 'my_sequence';

-----------------------------INDEX-----------------------------
--Performansı arttırır. 
--Sorgu sürelerini azaltır.

SELECT * FROM hr.hr_employees he 

CREATE INDEX idx_hr_employees_employee_id ON hr.hr_employees(employee_id);

CREATE INDEX idx_hr_employees_department_id ON hr.hr_employees(department_id);

CREATE INDEX idx_hr_departments_department_id ON hr.hr_departments(department_id);

SELECT he.employee_id , first_name , last_name , salary , hd.department_name  
FROM hr.hr_employees he 
LEFT JOIN hr.hr_departments hd  ON he.department_id = hd.department_id;

-----------------------------SYNONYM---------------------------
--Veritabanı nesnelerinin takma adlarıdır.
--PostgreSQL'de SYNONYM özelliği yoktur ama aşağıda benzeri gösterilmiştir.

--Oracle: CREATE SYNONYM personel FOR hr.hr_employees

--PostgreSLQ

CREATE VIEW personel AS
SELECT *
FROM hr.hr_employees;

SELECT * FROM personel;

-----------------------KULLANICI ERİŞİMLERİ---------------------

CREATE USER berkkepoglu WITH PASSWORD 'techbros2023'

GRANT ALL PRIVILEGES ON DATABASE postgres to berkkepoglu;

ALTER ROLE berkkepoglu SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS;

GRANT ALL ON SCHEMA hr TO berkkepoglu; --CREATE+USAGE

GRANT CREATE ON SCHEMA hr TO berkkepoglu;

--------------------------DATA DICTIONARY-----------------------

--Tablolar
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'hr';

--Kolonlar
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'hr';

--Index bilgileri
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'hr';