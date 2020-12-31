-- check the data
select * from staff;
select * from regions;

-- change gender column into numeric column
select id, last_name,email, gender, 
IIF(gender ='Female', 1,2) as 'gender_numeric'
from staff;


-- EOMONTH
SELECT id, last_name,email, start_date, 
EOMONTH(start_date) AS End_of_Month
From staff;

-- only last day
SELECT id, last_name,email, start_date, 
EOMONTH(start_date) AS Last_Day,
DATEPART(DD, EOMONTH(start_date)) as Last_day
From staff;


-- check salary sun per region
-- using CTE
with CTE_salary_total as
(select region_id, sum(salary) as total from staff group by region_id)

select R.region_name, C.total as salary
from regions R 
left join CTE_salary_total C
on R.region_id =C.region_id
order by salary

-- check employee numbers
-- using CTE
with CTE_salary_total as
(select region_id, sum(salary) as total, count(id) as employee_number
from staff group by region_id)

select R.region_name, C.total as salary, C.employee_number as employee_number
from regions R 
left join CTE_salary_total C
on R.region_id =C.region_id
order by salary

-- which months most employees joined

with CTE_MONTH_Employee AS
(select *, CHOOSE(DATEPART(MM, start_date),
'Jan', 'Feb', 'Mar', 'Apr','May','June', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
as [Month] from staff)

SELECT [Month],COUNT(*) FROM CTE_MONTH_Employee group by [Month];

-- query sum of salary by gender
select gender, sum(salary) from staff
group by gender;

-- retrieve salary by region_id along with Grand Total
select isnull(gender, 'total'), sum(salary) as total from staff
group by (gender) with rollup;

-- query sum of salary by department
select department, sum(salary) from staff
group by department;

--Using Grouping
select 
case when grouping(gender) = 1 then'all' else isnull(gender, 'unknown')end as gender,
case when grouping(department) = 1 then'all' else isnull(department, 'unknown')end as department,
sum(salary) as total
from staff group by rollup (gender,department);

-- sum of salary grouped by all combination of the 2 column as well as grand total
select region_id, gender, sum(salary) from staff
group by cube(region_id, gender);

-- query sum of salary by regoin_id
select region_id, sum(salary) from staff
group by region_id;

-- query sum of salary by job_title
select job_title, sum(salary) from staff
group by job_title;

-- grouping 
select department, gender, sum(salary) as total
from staff
group by
grouping sets((department, gender), (department),(gender), ())
order by Grouping(department), Grouping(gender), gender;

-- retrieve salary by region_id along with Grand Total
select isnull(region_id, '0'), sum(salary) as total from staff
group by rollup (region_id);


-- stuff
select email, stuff(email,2,5,'*****') as stuffed_email
from staff;

-- replicate email
select substring(email, 1,2) + replicate ('*', 5) + substring(email, charindex('@', email), len(email)- charindex('@', email)+1) as email
from staff;

-- patindex
select email, patindex('%salon.com',email ) from staff
where patindex('%salon.com',email )>0;

-- count email domain
select substring(email, (charindex('@', email)+1), len(email)-(charindex('@', email)))
, count(*) as total from staff
group by substring(email, (charindex('@', email)+1), len(email)-(charindex('@', email)))
order by count(*) desc;

Create Procedure spcountemployee
@gender nvarchar(20),
@Totalcount int output
as
begin
select @Totalcount = count(*) from staff where gender = @gender
end;

Declare @Totalcount int
execute spcountemployee 'Male', @Totalcount output
print @Totalcount;


create procedure sptotalemployee
@total int output
as 
begin 
select @total =  count(*) from staff
end;

declare @total int 
execute sptotalemployee @total output
print @total;

-- row_number
select department, gender, salary,
row_number() over(partition by gender order by salary)
from staff;

--Running Total
select department, gender, salary,
sum(salary) over (order by id)
from staff;

-- Ntile
select department, gender, salary,
ntile(3) over (order by id) as [Ntile]
from staff;


-- query sum of salary by department and gender
with cte_staff as
(select department,gender, sum(salary)as total from staff
group by department, gender)

--pivot for better view on female and male employee
select department, Female, Male from cte_staff
PIVOT(
sum(total) for gender IN (Female, Male)
) as pivotTable
order by department;

-- 






