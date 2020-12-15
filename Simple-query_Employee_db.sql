
--Write SQL query to get the second highest salary among all Employees?
 SELECT MAX(salary)
 FROM [master].[dbo].[staff] 
 where salary NOT IN  (SELECT MAX(salary)
 FROM [master].[dbo].[staff]) 

 SELECT MAX(salary)
 FROM [master].[dbo].[staff] 
 where salary <  (SELECT MAX(salary)
 FROM [master].[dbo].[staff]) 

-- How can we retrieve alternate records from a table
select * FROM [master].[dbo].[staff]
where id%2  =0

select TOP 10 * FROM [master].[dbo].[staff]
where id%2  =0

--Write a SQL Query to find Max salary and Department name from each department.
select department, max(salary) from staff
group by department
order by department

--Write a SQL Query to find Max salary and region name from each department.
SELECT c.company_regions, MAX(s.Salary)
FROM [master].[dbo].[staff] s JOIN [master].[dbo].[company_regions] as c
ON c.[region_id] =s.[region_id]
GROUP BY company_regions

--SQL query to find records in Table staff that are not in Table B which contains even number id without using NOT IN operator.
select * FROM [master].[dbo].[staff]
EXCEPT
(select * FROM [master].[dbo].[staff]
where id%2  =0);

--Write SQL Query to find employees that have same name

select last_name, count(*) from [master].[dbo].[staff]
group by last_name
having count(*) >1
order by last_name;

--Write a SQL Query to get the names of employees whose start date is between  2002-01-01' AND '2016-01-01';
SELECT last_name, start_date from [master].[dbo].[staff]
where start_date between '2002-01-01' AND '2016-01-01';

--Query to find employees with duplicate email.
select email, count(*) from [master].[dbo].[staff]
group by email
having count(*) >1
order by email;

--find all Employee whose name contains the word "car", regardless of case
select * from [master].[dbo].[staff]
where (last_name) like '%car%';

select distinct region_id FROM [master].[dbo].[company_regions] 
where region_id  NOT IN (select distinct region_id from [master].[dbo].[staff]);

SELECT last_name, start_date from [master].[dbo].[staff]
where YEAR(start_date) >= '2005';

SELECT * from [master].[dbo].[staff]
where department IS NULL
OR department <> 'Sports'
order by department;

UPDATE [master].[dbo].[staff] SET region_id =
CASE region_id 
WHEN '1' THEN '3'
WHEN '2' THEN '3'
ELSE region_id 
END




