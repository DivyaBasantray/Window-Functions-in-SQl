drop table if exists employee;

create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;

select * 
from employee
limit 5;

-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records.

select DEPT_NAME, max(salary) as max_salary
from employee
group by DEPT_NAME
order by DEPT_NAME desc;

-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.

select e.* ,
max(salary) over(partition by DEPT_NAME) as max_salary
from employee e;

-- ROW NUMBER

select e.* ,
row_number() over(partition by DEPT_NAME) as rn
from employee e;

select e.* ,
row_number() over(partition by DEPT_NAME order by emp_ID) as rn
from employee e;

-- Fetch the first 2 employees from each department to join the company.

select * from (
	select e.* ,
	row_number() over(partition by DEPT_NAME order by emp_ID) as rn
	from employee e) x
where x.rn < 3;

-- RANK 

select e.* ,
rank() over(partition by DEPT_NAME order by salary desc) as rnk
from employee e;

-- Fetch the top 3 employees in each department earning the max salary.

select * from (
	select e.* ,
	rank() over(partition by DEPT_NAME order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;

-- DENSE RANK 

select e.* ,
dense_rank() over(partition by DEPT_NAME order by salary desc) as dense_rnk
from employee e;

-- COMBINING ROW NUMBER, RANK, DENSE RANK (TO CHECK THE DIFFERENCE BETWEEN THEM) 

select e.* ,
rank() over(partition by DEPT_NAME order by salary desc) as rnk,
dense_rank() over(partition by DEPT_NAME order by salary desc) as dense_rnk,
row_number() over(partition by DEPT_NAME order by salary desc) as rn
from employee e;

-- LEAD AND LAG

select e.* ,
lag(salary) over(partition by DEPT_NAME order by emp_ID) as prev_emp_salary
from employee e;

select e.* ,
lag(salary, 2, 0) over(partition by DEPT_NAME order by emp_ID) as prev_emp_salary
from employee e;

select e.* ,
lead(salary) over(partition by DEPT_NAME order by emp_ID) as next_emp_salary
from employee e;

-- COMBINING LEAD AND LAG (TO CHECK THE DIFFERENCE BETWEEN THEM)

select e.* ,
lag(salary) over(partition by DEPT_NAME order by emp_ID) as prev_emp_salary,
lead(salary) over(partition by DEPT_NAME order by emp_ID) as next_emp_salary
from employee e;

-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.

select e.* ,
lag(salary) over(partition by DEPT_NAME order by emp_ID) as prev_emp_salary,
case when e.salary > lag(salary) over(partition by DEPT_NAME order by emp_ID) then 'Higher than previous employee'
	 when e.salary < lag(salary) over(partition by DEPT_NAME order by emp_ID) then 'Lower than previous employee'
     when e.salary = lag(salary) over(partition by DEPT_NAME order by emp_ID) then 'Same as the previous employee'
     end sal_range
from employee e;