#Write a SQL statement to create a simple table Countries including columns country_id, country_name, region_id.
create table countries(
country_id int,
country_name varchar(200),
region_id int
);



#Put some values into the table Countries
insert into countries
(country_id,country_name,region_id)
values
(20,INDIA,77),
(30,NEPAL,88),
(35,SRILANKA,87),
(40,BANGLADESH,99);



#Write a SQL statement to create a table "Asian_countries" including columns country_id, country_name, region_id from above created table "Countries" where country_name should be in "INDIA", "BANGLADESH", "NEPAL".
create table asian_countries as
select country_id,country_name,region_id
from COUNTRIES
where country_name IN ('INDIA', 'BANGLADESH', 'NEPAL');

#OR

create table asian_countries (select * from countries
where Country_Name in ('India' , 'Bangladesh' , 'Nepal') );



#Write a SQL statement to create a table named jobs including columns job_id, job_title, min_salary, max_salary, and check whether the max_salary amount exceeding the upper limit 25000 and also job_title like "Data_Analyst, "Data_Engineer", "Data_Scientist".
CREATE TABLE JOBS(
JOB_ID INT PRIMARY KEY,
JOB_TITLE VARCHAR(255),
MIN_SALARY FLOAT,
MAX_SALARY FLOAT,
CONSTRAINT CHK_JOBS CHECK (MAX_SALARY<=25000 AND JOB_TITLE = "DATA_ANALYST" OR "DATA_ENGINEER" OR "DATA_SCIENTIST"));



#Write a SQL statement to create a table named job_history including columns employee_id, start_date, end_date, job_id and department_id and make sure that the value against column end_date will be entered at the time of insertion to the format like '--/--/----'.
create table job_history(
employee_id int primary key,
start_date date not null,
end_date date default(now()),
job_id int not null,
department_id int not null,
constraint End_date_check check ( END_DATE LIKE '--/--/----') );



#Write a SQL statement to create a table “job_history” including columns employee_id, start_date, end_date, job_id and department_id and make sure that, the employee_id and job_id columns does not contain any duplicate value and also can’t be empty at the time of insertion. And also records in table should should be of year2022.
create table job_history(
employee_id int not null,
start_date date not null check (start_date between "2022-01-01" and "2022-12-31"),
end_date date default(now()) check (end_date between "2022-01-01" and "2022-12-31"),
job_id int not null,
department_id int not null,
constraint unique_id unique(employee_id,job_id) );

insert into job_history
values (1,"2022-01-01","2022-12-30",1,1),
(2,"2022-01-01","2022-12-30",2,2);



#Write a SQL statement to create a table ‘employees’ from above created table ‘job_history’ and then delete all the values in the table ‘employees’. Then Insert 2-3 records andthen delete the table.
create table employees as
select employee_id,start_date,end_date,job_id,department_id
from job_history;

truncate table employees;
insert into employees (employee_id,start_date,end_date,job_id,department_id)
values
(1,'2022-01-12','2022-11-22',54,13),
(2,'2022-01-18','2022-10-22',55,16);
drop table employees