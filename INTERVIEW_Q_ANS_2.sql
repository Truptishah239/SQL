/****** Script for SelectTopNRows command from SSMS  ******/

-- COLLECT TRANSACTION ONLY FOR LATEST DATE

CREATE TABLE ACCOUNT
(NUMBER INT,
ACCOUNT INT,
ENTRYDATE DATE,
AMOUNT NUMERIC(14,2)
)

INSERT INTO ACCOUNT
SELECT 1,1,'2020-07-29',150
UNION 
SELECT 1,1,'2020-07-30',160
UNION 
SELECT 2,1,'2020-07-29',170
UNION 
SELECT 2,1,'2020-07-31',180
UNION 
SELECT 2,2,'2020-07-28',190
UNION 
SELECT 3,3,'2020-07-25',200

SELECT * FROM (
SELECT NUMBER, ACCOUNT, ENTRYDATE, AMOUNT,
DENSE_RANK() OVER(PARTITION BY NUMBER, ACCOUNT ORDER BY ENTRYDATE DESC) AS DENSE_RNK
FROM ACCOUNT) A
WHERE DENSE_RNK = 1;
--------------------------------------------------------------------------------------------------------------
--- GET THE COMMA SEPARATED VALUE
Create Table SUBJECT
(
   TrainingId Int ,
   Training     varchar(100),
   Classroom    varchar(100),
   StartTime    Time,
   duration     numeric(14,2),
   wk           varchar(10)
)

Insert SUBJECT
Select 1,'SQL Server','Silver Room','10:00',2.00,'M'
Union
Select 2,'SQL Server','Silver Room','10:00',2.00,'W'
UNION
Select 3,'SQL Server','Silver Room','10:00',2.00,'T'
Union
Select 4,'SQL Server','Silver Room','10:00',2.00,'F'
UNION
Select 5,'MSBI','GOLD Room','11:00',1.45,'F'
Union
Select 6,'MSBI','GOLD Room','11:00',1.45,'M'
Union
Select 7,'MSBI','GOLD Room','11:00',1.45,'TH'


SELECT STUFF((SELECT ','+ WK FROM SUBJECT FOR XML PATH ('')), 1,1,'') AS A;

SELECT distinct Training, Classroom, StartTime, duration,
STUFF((SELECT ','+ WK FROM SUBJECT where Training =  A.Training FOR XML PATH ('')), 1,1,'') 
FROM SUBJECT as A;


------------------------------------------------------------------------------------------------------------------
--SELECT AVG DIFF OF SALARY ON REGION

SELECT TOP (1000) [id]
      ,[last_name]
      ,[email]
      ,[gender]
      ,[department]
      ,[start_date]
      ,[salary]
      ,[job_title]
      ,[region_id]
  FROM [AdventureWorksDW2012].[dbo].[staff]



 SELECT *, lag(salary, 1) over(partition by region_id ORDER BY salary), 
 salary - lag(salary, 1) over(partition by region_id ORDER BY salary)as diff FROM [AdventureWorksDW2012].[dbo].[staff];

 -------------------------------------------------------------------------------------------------------------------------------------------------

 SELECT region_id, avg(diff) as avg_diff_salary from 
 (
 SELECT region_id, salary - lag(salary, 1) over(partition by region_id ORDER BY salary)as diff FROM [AdventureWorksDW2012].[dbo].[staff]) a
 group by region_id;

 -------------------------------------------------------------------------------------------------------------------------------------------------------

 Create Table Son_Father_Tbl
(
Name varchar(100),
Fname varchar(100)
)

Insert Son_Father_Tbl 
Select 'Susheel Singh', 'I.B. Singh'
Union All
Select 'I.B. Singh' ,'R.B. Singh'
Union All
Select 'Rudra Singh' ,'Anil Singh'
Union All
Select 'Anil Singh' ,'R.J. Singh'
Union All
Select 'R.J. Singh' ,'R.L. Singh'
Union All
Select 'R.B. Singh' ,'R.L. Singh'

SELECT * FROM Son_Father_Tbl;

SELECT A.Name, ISNULL(B.Fname, 'No names')
FROM Son_Father_Tbl A
LEFT JOIN Son_Father_Tbl B
on B.Name = A.Fname;

--------------------------------------------------------------------------------------------
-- Max Marks and subject

Create Table CaseStatement
(
Student_id			Int,
English				Int,
Maths				Int,
Science				Int
)
INSERT INTO CaseStatement
Select 1,50,90,80
Union 
Select 2,70,65,65
Union
Select 3,60,75,90
Union
Select 4,80,55,65

Select * From CaseStatement;


Select Student_id,Case When English>Maths then
				  Case when english>Science then English else Science End 
				  Else
				  Case when Maths>Science    then  Maths Else Science End 
				  End as Max_Marks
Into #temp
From   CaseStatement
Select * from #temp
Select * From CaseStatement
Select a.Student_id,a.Max_Marks,
                         Case When a.Max_Marks = b.English Then 'English'
						 When a.Max_Marks = b.Maths   Then 'Maths'
					Else 'Science' End
					as Subject	 
From       #temp as a
Inner join CaseStatement as b 
On  a.Student_id = b.Student_id

--------------------------------------------------------------------------------------------------------------------
--Compare 3 subject and decide pass, fail.
Create Table Adm_Sports
(
Student_id   Int ,
Sport_Marks  Int
)
Create Table Adm_Education
(
Student_id   Int ,
Education_Marks  Int
)
Create Table Adm_behaviour
(
Student_id   Int ,
behaviour_Marks  Int
)

Insert Adm_Sports Values (1,60),(2,75),(3,85),(4,85)
Insert Adm_Education Values (1,70),(2,80),(3,90),(4,70)
Insert Adm_behaviour Values (1,80),(2,60),(3,50),(4,70)

Select * From Adm_Education;
Select * From Adm_Sports;
Select * From Adm_behaviour;

---Step-1:

Select * From   
adm_education as a
Inner JOIN adm_sports as b
On  a.student_id  = b.student_id
Inner JOIN adm_behaviour as c
On  a.student_id  = c.student_id;

-----Step-2:

Select a.student_id,case when a.education_marks>80 then 'Metrit'
						 when a.education_marks between 71 and 80 then 'Pass'
						 When a.education_marks <=70 then 'Fail' End  as E_marks,

						 case when b.sport_marks >80 then 'Metrit'
						 when b.sport_marks  between 71 and 80 then 'Pass'
						 When b.sport_marks  <=70 then 'Fail' End  as S_Marks,
						 
						 case when c.behaviour_Marks >80 then 'Metrit'
						 when c.behaviour_Marks  between 71 and 80 then 'Pass'
						 When c.behaviour_Marks  <=70 then 'Fail' End  B_Marks
Into #temp2
From   adm_education as a
Inner JOIN adm_sports as b
On  a.student_id  = b.student_id
Inner JOIN adm_behaviour as c
On  a.student_id  = c.student_id

-----Step-3:

Select Student_id,Case when E_Marks = S_Marks Then E_marks
					   when E_Marks = B_Marks Then E_marks
					   When B_Marks = S_Marks Then B_Marks
					   Else 'Fail'
					   End  as Grade
from #temp2



