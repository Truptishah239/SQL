
---CHECK THE DATA---
select *   FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- too big table, fetch only few records
select top 10 *  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
order by EmployeeKey;

-- join firstname and lastname
select *, CONCAT(FirstName, ' ', LastName) as Full_name FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- check department and sum of base salary

select DepartmentName, sum(BaseRate)  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
group by DepartmentName
order by sum(BaseRate) desc;


--- Increase income by 5 percent
update [AdventureWorksDW2012].[dbo].[DimEmployee] 
set BaseRate = BaseRate+ ((BaseRate* 5)/100);

--- check the names starting with Z
select FirstName, LastName, DepartmentName  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where FirstName like 'M%' or LastName like 'M%';

--- who is working for production

select FirstName, LastName, DepartmentName  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where DepartmentName = 'Production'
AND (FirstName like 'M%' or LastName like 'M%');

-- What is the total -- 38

select count(*)  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where DepartmentName = 'Production'
AND (FirstName like 'M%' or LastName like 'M%');

---Name which ends with M 
select FirstName, LastName, DepartmentName  FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where DepartmentName = 'Production'
AND (FirstName like '%M' or LastName like '%M');

-- total employee -- 46
select count(*) FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where DepartmentName = 'Production'
AND (FirstName like '%M' or FirstName like 'M%'
OR LastName like '%M' or LastName like 'M%');

-- max and min range for base rate 9.925 and 138.36
select min(BaseRate) FROM [AdventureWorksDW2012].[dbo].[DimEmployee];
select max(BaseRate) FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- check the avg salary -- 20.40
select  avg(BaseRate) FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- Who has base salary between 10 and 20 -- low income workes in production
select count(*) FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where DepartmentName = 'Production'
and BaseRate between 10 and 20
AND (FirstName like '%M' or FirstName like 'M%'
OR LastName like '%M' or LastName like 'M%');

--- out of 46 workers , 41 workers get base rate between $10 and $20 ---

-- let's grab the data from EmergencyContactName
select EmergencyContactName FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- check only first name of EmergencyContactName

select substring (EmergencyContactName, 0, CHARINDEX(' ',EmergencyContactName)) 
FROM [AdventureWorksDW2012].[dbo].[DimEmployee];

-- check duplicate records
select EmergencyContactName, count(*) FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
group by EmergencyContactName
having count(*) > 1;

-- checking firstname 
select FirstName, LastName, EmergencyContactName FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where EmergencyContactName = 'sheela Word';


-- record are duplicate..deleting those
Delete FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
where EmergencyContactName IN
(select EmergencyContactName FROM [AdventureWorksDW2012].[dbo].[DimEmployee]
group by EmergencyContactName
having count(*) > 1);

-- error occured - The DELETE statement conflicted with the SAME TABLE REFERENCE constraint "FK_DimEmployee_DimEmployee". The conflict occurred in database "AdventureWorksDW2012", table "dbo.DimEmployee", column 'ParentEmployeeKey'.

-- creating empty table with same structure
SELECT * into table2 FROM [AdventureWorksDW2012].[dbo].[DimEmployee] where 1 =0;

-- fetch command records
select * FROM [AdventureWorksDW2012].[dbo].[DimEmployee] 
intersect 
select * from table2;
--- Confirmed that table is empty












