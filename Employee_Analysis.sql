--Look at the data
select * from employees;

-- 

select distinct(manager_id) from employees;

-- Query to find how many employee hired per year
select datepart(year, hire_date),count(*) from employees
group by datepart(year, hire_date)
order by datepart(year, hire_date);

-- select all even number of records
select * from employees
where employee_id%2 = 0;

--filter before 150
select * from employees
where employee_id%2 = 0 
and employee_id < 150;

-- another way
select top 50 * from employees
where employee_id%2 = 0 
order by employee_id;


-- CHECKING SALARU RANGE
SELECT MAX(SALARY) FROM employees;
SELECT MIN(SALARY) FROM employees;

-- with no max and min function
select top 1 salary from employees order by salary desc;

-- add new column on salary, Excellent, medium and low_income
select *, 
case when salary > 15000 then 'Excellent'
when salary > 10000  and salary < 15000 then 'Medium'
when salary < 10000 then 'low'
end as "new_salary"
from employees;

-- Query to find average salary under each manager
select e.manager_id, m.first_name, (avg(e.salary))
FROM employees e
join employees m
on e.manager_id= m.employee_id
where m.manager_id IS NOT NULL
group by e.manager_id,m.first_name;

-- one more method

select b.employee_id as "Manager_Id",
          b.first_name as "Manager", 
          avg(a.salary) as "Average_Salary_Under_Manager"
from employees a, 
     employees b
where a.manager_id = b.employee_id
group by b.employee_id, b.first_name
order by b.employee_id;


-- Query to find number of manager

select count(distinct(manager_id)) from employees;

--split the salary column into 2 parts
select salary, floor(salary)as 'dollars'
from employees

-- Any employee taking advance salary if yes, what is the sum // sum of positive value and negative value for salary
select 
sum(case when salary > 0 then (salary) else 0 end) as sum_pos,
sum(case when salary < 0 then (salary) else 0 end )as sum_neg
from employees;

-- print all full name name 
select (concat(first_name+space(2)+last_name, ',')) from employees;

-- check phone numbers, if NULL write 'no number'
select phone_number from employees;

select count (phone_number) from employees
where phone_number is NOT NULL;

select isnull(phone_number, 'No Number') as new_number from employees;

--another way
select coalesce(phone_number, '000.000.000') as new_number from employees;


--- query employee, manager and level
with 
Employeecte (employee_id, name, manager_id, [level])
as
(
select employee_id, first_name+space(3) +last_name as name, manager_id, 1
from employees where manager_id IS NULL
UNION all
select emp.employee_id, emp.first_name+space(3) +emp.last_name as name, emp.manager_id, Employeecte.[level]+1
from employees as emp
join Employeecte 
on emp.manager_id = Employeecte.employee_id
)
select emp.name as Employee, ISNULL(mgr.name, 'super boss') as manager,
emp.[level]
from Employeecte emp
left join Employeecte mgr
on emp.manager_id = mgr.employee_id


-- max salary
select max(salary) from employees;

-- second highest salary
select max(salary) from employees 
where salary <> (select max(salary) from employees);


--5th highest salary
select top 5 salary from (
select salary, DENSE_RANK() over(order by salary desc) as rnk from employees) a
where rnk = 5
order by salary desc;

-- another way for 5 th salary
SELECT salary from employees order by salary desc
OFFSET 5 ROWS
FETCH NEXT 1 ROW ONLY;

--CTE WAY
declare @N int
set @N = 5;
with cte as 
(select salary, 
DENSE_RANK() over(order by salary desc) as rnk
from employees)
select salary from cte where rnk = @N;

-- one more way 
select top 1 salary from 
(select distinct top (10) (salary) from employees order by salary desc ) as E
order by salary;


