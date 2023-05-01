#Write an SQL query to fetch "FIRST_NAME" from Worker table using the alias name as <WORKER_NAMES.
SELECT FIRST_NAME FROM worker as WORKER_NAME;


#Write an SQL query to fetch "FIRST_NAME" from Worker table in upper case.
select upper(FIRST_NAME) FROM worker ;


#Write an SQL query to fetch unique values of DEPARTMENT from Worker table.
select distinct DEPARTMENT FROM worker;


#Write an SQL query to print the first three character of FIRST_NAME from worker table.
select LEFT(FIRST_NAME,3) FROM worker;
select substring(FIRST_NAME,1,3) FROM worker;


#Write an SQL query that fetch the unique values of DEPARTMENT from Worker table and print its length.
select distinct DEPARTMENT, length(DEPARTMENT) AS DEP_NAME_LENGTH FROM worker;


#Write an SQL query to print the FIRST_NAME & LAST_NAME from Worker table into a single column COMPLETE_NAME. A space char should seperate them.
select concat(FIRST_NAME ," ", LAST_NAME)  AS COMPLETE_NAME FROM worker;


#Write an SQL query to print details for Workers with the first name as "Vipul" and "Satish" from Worker table and vice versa.
select * FROM worker
where FIRST_NAME IN ("Vipul","Satish");


#Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME asc and DEPARTMENT desc.
select * from worker
order by FIRST_NAME asc, DEPARTMENT desc;


#Write an SQL query to print details of the Workers whose FIRST_NAME contains "a" and ends with "a".
select * FROM worker
where FIRST_NAME like "%a%a";



#Write an SQL query to print details of the worker whose FIRST_NAME ends with "h" and contains six alphabets.
select * FROM worker
where FIRST_NAME like "_____h";


#Write an SQL query to print details of the workers whose salary lies between 100000 and 500000.
select * from worker
where SALARY between 100000 and 500000;


#Write an SQL query to print details of the workers who have joined in feb'2014. 
select * from worker
where JOINING_DATE like "2014-02%";


#Write an SQL query to fetch the no. of workers for each department in the desc order.
select DEPARTMENT , count(*) AS NUM_OF_EMPLOYEE FROM WORKER
group by DEPARTMENT order by NUM_OF_EMPLOYEE desc;


#Write an SQL query to fetch duplicate records having matching data in some fields of the table.
select DEPARTMENT, COUNT(*) FROM WORKER
group by DEPARTMENT HAVING COUNT(*)>1;


#Write an SQL query to print details of the worker who are also managers.
select WORKER_ID,FIRST_NAME,LAST_NAME,SALARY,JOINING_DATE,AFFECTED_FROM,DEPARTMENT,WORKER_TITLE FROM worker
inner JOIN title
ON worker.WORKER_ID = title.WORKER_REF_ID
where WORKER_TITLE = "Manager";
 

#Write an SQL query to show the top 10 records of a table on the basis of salary. 
select * from worker
order by SALARY desc limit 10;
 

#Write an SQL query to fetch the list of employees with the same salary. 
select * from worker where SALARY in 
( select SALARY from worker group by SALARY having  count(*)>1 )
order by SALARY;
select a.* from worker AS a, worker AS b where a.SALARY = b.SALARY AND a.WORKER_ID != b.WORKER_ID order by SALARY;


#Write an SQL query to fetch the departments that have less than five people in it. 
select DEPARTMENT, count(DEPARTMENT) as num_less_than_5 from worker
group by DEPARTMENT HAVING count(*)<5;
 

#Write an SQL query to fetch departments along with the total salaries paid for each of them 
select DEPARTMENT, SUM(SALARY) as TOTAL_SALARY from worker
group by DEPARTMENT;
 

#Write an SQL query to fetch all the data of worker along with the worker_title. 
SELECT WORKER_ID,FIRST_NAME,LAST_NAME,SALARY,JOINING_DATE,DEPARTMENT,WORKER_TITLE FROM WORKER
FULL JOIN TITLE
ON WORKER_ID = WORKER_REF_ID
ORDER BY WORKER_ID;


#Write a SQL query to display 2nd to 5th character as Middle_Name from First_Name column along with all other columns from Worker table and also have Department columnvalues more than 2 characters.
select WORKER_ID, mid(First_name, 2,5) AS Middle_Name , LAST_NAME, SALARY, JOINING_DATE, 
DEPARTMENT 
from worker where length(department)>2 ;


#Write a SQL query to display No. Of Employment Years for each Worker till today along with all other columns from Worker table.
select *,date_format(from_days(datediff(now(),joining_date)),'%Y')+0 as emp_years from worker;


#Write a SQL query to display maximum and minimum salary of Workers for each Worker_title along with all other columns from Worker table.
select *, max(salary) over (partition by DEPARTMENT ) as max_salary , min(salary) over (partition by 
DEPARTMENT ) as min_sal from 
(select a.*,b.worker_title from worker as a left join title as b on a.worker_id = b.worker_ref_id) as c;


#Write a SQL query to display all the data about worker promoted in shortest time to it’s current worker title and also for longest time take for promotion worker.
select *, dense_rank() over (order by Promoted_Worker desc) as slow_prom , dense_rank() over 
(order by promoted_worker) as fast_prom from
(select *, datediff(joining_date, affected_from) as Promoted_Worker from
(select a.*,b.WORKER_TITLE, AFFECTED_FROM from worker as a left join title as b on a.WORKER_ID 
= b.WORKER_REF_ID) as c) as d;


#Write a SQL query to display all the data about worker got bonus recently and also for worker got bonus lately.
select *, dense_rank() over (order by BONUS_DATE desc) as recen_got_bon , dense_rank() over 
(order by BONUS_DATE ) as latel_got_bon from
(select a.*,b.BONUS_DATE,BONUS_AMOUNT from worker as a inner join bonus as b on 
a.WORKER_ID = b.WORKER_REF_ID) as c;


#Write a SQL query to display all records of Workers who received Bonus after the promotion and arrange them according to the bonus amount received from heighest to lowest.
select a.*,b.BONUS_DATE,BONUS_AMOUNT from worker as a inner join bonus as b on 
a.WORKER_ID = b.WORKER_REF_ID order by BONUS_AMOUNT desc;


#Write a SQL query to display all records of Worker having 2nd Highest salary in their respective departments after adding their bonus amount into their respective salary and also display all records of worker having 2ndlowest salary in their respective departments after adding their bonus amount into their respective salary.
select * from
(select * , dense_rank() over(partition by department order by added_salary ) as Highest_earner,
dense_rank() over(partition by department order by added_salary DESC ) as Lowest_earner from
(select a.*,b.BONUS_AMOUNT,SALARY+ifnull(BONUS_AMOUNT,0) as added_salary from worker a 
LEFT JOIN bonus b on a.WORKER_ID=b.WORKER_REF_ID ) as c) as d
where (Highest_earner = 2 or Lowest_earner = 2 );


#Write a SQL query to display all records of Worker fetched in above question where the 2nd highest and 2ndlowest salary in their respective departments are different Workers.
select * from
(select * , dense_rank() over(partition by department order by added_salary ) as Highest_earner,
dense_rank() over(partition by department order by added_salary DESC ) as Lowest_earner from
(select a.*,b.BONUS_AMOUNT,SALARY+ifnull(BONUS_AMOUNT,0) as added_salary from worker a 
LEFT JOIN bonus b on a.WORKER_ID=b.WORKER_REF_ID ) as c) as d
where (Highest_earner = 2 or Lowest_earner = 2 ) and Highest_earner <> Lowest_earner
