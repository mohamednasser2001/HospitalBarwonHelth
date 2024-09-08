CREATE DATABASE BarwonHelth;
CREATE SCHEMA Hospital
USE BarwonHelth
CREATE TABLE Hospital.patients(
  UK_NUM int primary key, 
  f_name varchar,
  l_name varchar,
  Age int,
  medicare varchar,
  phone varchar,
  email varchar,
  addres varchar
)
CREATE TABLE Hospital.Doctors(
  ID int primary key,
  f_name varchar(100) not null,
  l_name varchar(100) not null,
  email varchar(100),
  phone varchar(100) not null,
  specialization varchar(100),
  years_of_experienc float,
  UK_NUM int,
    constraint patients_doctor_fk foreign key(UK_NUM)
  references Hospital.patients(UK_NUM)
)

CREATE TABLE Hospital.medication_drags(
  ID int primary key,
  f_name varchar not null, 
  l_name varchar,
  drug_strength float,
  UK_NUM_patients int,

  constraint patients_drags_fk foreign key(UK_NUM_patients)
  references Hospital.patients(UK_NUM)

)


CREATE TABLE Hospital.pharmaceuticu_company(
   f_name varchar(100) not null,
   l_name varchar(100) not null,
   addres varchar(100),
   phone varchar (100)not null,
   ID_Drug int,
   constraint company_drags_fk foreign key(ID_Drug)
  references Hospital.medication_drags(ID)

)
--•	SELECT: Retrieve all columns from the Doctor table.
select *
from Hospital.Doctors
--•	ORDER BY: List patients in the Patient table in ascending order of their ages.
select *
from Hospital.patients
order by Age
--•	OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
select f_name,l_name,phone,email
from Hospital.patients
order by UK_NUM
OFFSET 4 rows
fetch next 10 rows only
--•	SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
select top 10 *
from Hospital.Doctors
--•	SELECT DISTINCT: Get a list of unique address from the Patient table.
select  DISTINCT  addres
from Hospital.patients
--•	WHERE: Retrieve patients from the Patient table who are aged 25.
select *
from Hospital.patients
where Age=25
--•	NULL: Retrieve patients from the Patient table whose email is not provided.
select f_name,l_name,phone,email
from Hospital.patients
where email is null
--•	AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
select f_name,l_name,specialization,years_of_experienc
from Hospital.Doctors
where years_of_experienc>5 AND specialization='Cardiology'
--•	IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
select *
from Hospital.Doctors
where specialization in('Dermatology','Oncology')
--•	BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
select *
from Hospital.patients
where Age between 18 AND 30
--•	LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
select f_name,email,phone
from Hospital.Doctors
where f_name like'Dr%'
--•	Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
select f_name+' '+l_name DoctorName,email AS 'DoctorEmail'
from Hospital.Doctors
--•	Joins: Retrieve all prescriptions with corresponding patient names.
select p.f_name,p.l_name,p.Age,m.f_name,m.l_name,m.ID,m.drug_strength
from Hospital.patients p join Hospital.medication_drags m
on m.UK_NUM_patients=p.UK_NUM


--•	GROUP BY: Retrieve the count of patients grouped by their cities.
select addres,count(*)as 'add',f_name
from Hospital.patients
group by addres
--•	HAVING: Retrieve cities with more than 3 patients.
select addres,count(*)as'patients_count'
from Hospital.patients
group by addres
having count(*)>3
--•	UNION: Retrieve a combined list of doctors and patients. (Search)
select f_name,l_name  from Hospital.Doctors
union
select f_name,l_name from Hospital.patients
--•	Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
with cte_doctor_patients AS(
select p.UK_NUM,p.email,d.f_name,d.l_name,d.ID
from Hospital.patients p join Hospital.Doctors d
on d.UK_NUM=p.UK_NUM

)
select * from cte_doctor_patients
--•	INSERT: Insert a new doctor into the Doctor table.
INSERT INTO Hospital.Doctors(id,f_name,l_name,email,phone,specialization,years_of_experienc)
values(1,'mfff','nasser','mmmm','01123','jjhfd',1.2)
--•	INSERT Multiple Rows: Insert multiple patients into the Patient table.
insert into Hospital.patients(UK_NUM,addres,email,phone,f_name,l_name,Age,medicare)
values(1,'q','a','1','m','n',12,'o'),(3,'r','b','3','n','m',122,'p')
--•	UPDATE: Update the phone number of a doctor.
	update Hospital.Doctors
	set phone ='01120874222'
	where ID=1
--•	UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
update Hospital.patients
set addres ='z'
from Hospital.patients p join Hospital.Doctors d
on d.UK_NUM=p.UK_NUM
where d.ID=1
-- •	DELETE: Delete a patient from the Patient table.
delete Hospital.patients
select * from Hospital.patients
--•	Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
BEGIN TRANSACTION;
insert into Hospital.Doctors(ID,email,f_name,l_name,specialization,years_of_experienc,phone)
values(12,'mmm.zzz155','mohamed','nasser','kjkj',34,'01120874')

insert into Hospital.patients(UK_NUM,f_name,l_name,email,addres,Age,phone,medicare)
values(13,'m','p','n','l',11,'o','g')
COMMIT;
--	View: Create a view that combines patient and doctor information for easy access.
create view Hospital.view_doctor_patients with ENCRYPTION AS(
select pa.f_name+' '+pa.l_name fullNamePatients,pa.UK_NUM,pa.Age,pa.phone AS phonePatients,do.f_name+' '+do.l_name FullNameDoctors,do.ID,do.phone AS PhoneDoctor,do.email 
from Hospital.patients pa join Hospital.Doctors do
on do.UK_NUM=pa.UK_NUM
)
select* from Hospital.view_doctor_patients
DROP VIEW  IF EXISTS Hospital.view_doctor_patients 
--•	Index: Create an index on the 'phone' column of the Patient table to improve search performance.
create index phone_patients
on Hospital.patients(phone)

select *
from Hospital.patients
where phone='o'
--•	Backup: Perform a backup of the entire database to ensure data safety.

                  --GUI--





