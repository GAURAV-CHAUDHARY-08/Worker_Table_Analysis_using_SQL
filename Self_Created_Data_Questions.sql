CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employees(emp_id) ON DELETE SET NULL
);

ALTER TABLE employees
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employees
ADD FOREIGN KEY(super_id)
REFERENCES employees(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employees VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employees
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employees VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employees VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employees
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employees VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employees VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employees VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employees VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employees
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employees VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employees VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);



-- Find all employees
SELECT *
FROM employees;

-- Find all clients
SELECT *
FROM client;

-- Find all employees ordered by salary
SELECT *
from employees
ORDER BY salary DESC;

-- Find all employees ordered by sex then name
SELECT *
from employees
ORDER BY sex,first_name asc;

-- Find the first 5 employees in the table
select * from employees
limit 5;

-- Find the first name and last name of all employee
select first_name, last_name from employees;

-- Find the forename and surnames of aal employees
select first_name as forename,
last_name as surname
from employees;

-- Find out all different genders
select distinct sex
from employees;

-- Find all male employees
select * from employees
where sex = "M";

-- Find all employees at branch 2
select * from employees
where branch_id = 2;

-- Find all employees id and names who were born after 1969
select emp_id, first_name, last_name from employees
where birth_day > "1969-12-31";

-- find all female employees at branch 2
select * from employees
where branch_id = 2 and sex = "F";

-- Find all employees who are female and born after 1969 0r who make over 80000
select * from employees
where (sex = "F" and birth_day = "1969-12-31") or salary > 80000;

-- Find all employees born between 1970 and 1975
select * from employees
where birth_day between "1970-01-01" and "1975-12-31";

-- Find all employees named jim,michael,johnny or david
select * from employees
where first_name in ("Jim","Michael","Johnny","David");

-- Find the no. of employees
select count(emp_id) from employees;

-- Find the average of all employees salaries 
select avg(salary) from employees;

-- Find out how many males and females there are
select count(sex),sex from employees
group by sex;

-- Find the total sales of each salesman
select sum(total_sales),round(emp_id,0), client_id from works_with
group by client_id;

-- Find the total amount of money spent on each client
select sum(total_sales),client_id from works_with
group by client_id;

-- Find a list of employee and branch names
select e.first_name, e.last_name, b.branch_name from employees e
join branch b
on e.branch_id = b.branch_id;

-- Find a list of all clients and branch suppliers names
select concat(employees.first_name," ",employees.last_name) as Branch_Supplier_name,employees.branch_id,client.client_name 
from employees 
join client on client.branch_id = employees.branch_id
join branch on branch.branch_id = client.branch_id ;

-- Add the extra branch
insert into branch
values (4,"Buffalo",null,null);

-- Join employee and branch table
select employees.emp_id, employees.first_name, employees.last_name, branch.branch_name 
from employees
join branch on branch.mgr_id = employees.emp_id;

-- Find names of all employees who have sold over 50,000
select * from employees
where emp_id in (select emp_id from works_with
				 where total_sales>50000);
                 
-- Find all clients who are handles by the branch that Michael Scott manages
select client_id,client_name from client
where branch_id in
(select branch_id from employees
where first_name = "Michael" and last_name = "Scott");

-- Find the names of employees who work with clients handled by the scranton branch
select first_name,last_name from employees
where branch_id in
(select branch_id from branch 
where branch_name = "Scranton");

-- Find the names of all clients who have spent more than 100,000 dollars
select client_name, client_id from client
where client_id in
(select client_id from 
(select sum(total_sales) as Total, client_id from works_with
group by client_id) a
where Total>100000) ;