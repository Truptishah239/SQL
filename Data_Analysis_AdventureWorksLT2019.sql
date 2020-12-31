

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ProductDescriptionID]
      ,[Description]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorksLT2019].[SalesLT].[ProductDescription]

--  Query names of all product together with productcategoryid , but you cannot use JOIN

  select P.Name, P.ProductModelID,PM.Name
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as P,
   [AdventureWorksLT2019].[SalesLT].[ProductModel] as PM
   WHERE P.ProductModelID = PM.ProductModelID
   order by P.Name, P.ProductModelID

--Query names of all product together with productcategoryid with join
  select P.Name, P.ProductModelID,PM.Name
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as P
  join  [AdventureWorksLT2019].[SalesLT].[ProductModel] as PM
   on P.ProductModelID = PM.ProductModelID
   order by P.ProductModelID

-- Query all product that have same productmodel ID as Full-Finger Gloves S
  select *
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as P
  where ProductModelID IN ( select ProductModelID from 
  [AdventureWorksLT2019].[SalesLT].[ProductModel]
  where Name = 'Full-Finger Gloves')
  and P.Name Not like 'Full-Finger Gloves, S';

-- list all customer with or with out address:
select count(*)
FROM  [AdventureWorksLT2019].[SalesLT].[Customer]  as C
left join [AdventureWorksLT2019].[SalesLT].[CustomerAddress] as CA
on C.CustomerID = CA.CustomerID
left join [AdventureWorksLT2019].[SalesLT].[Address] as A
on CA.AddressID = A.AddressID
where CA.CustomerID is Null
	


SELECT TOP (1000) [CustomerID]
      ,[AddressID]
      ,[AddressType]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorksLT2019].[SalesLT].[CustomerAddress]

  select * FROM [AdventureWorksLT2019].[SalesLT].[CustomerAddress]


   --Common customers 
   -- customers - with address -- 417
  select top (10) *
    FROM [AdventureWorksLT2019].[SalesLT].[CustomerAddress] as CA
	join [AdventureWorksLT2019].[SalesLT].[Address] as A
	on CA.AddressID = A.AddressID
	join [AdventureWorksLT2019].[SalesLT].[Customer] as C
	on C.CustomerID = CA.CustomerID

	select top (10)  *
	from [AdventureWorksLT2019].[SalesLT].[Address] as A
	join [AdventureWorksLT2019].[SalesLT].[CustomerAddress] as CA
	on CA.AddressID = A.AddressID
	join [AdventureWorksLT2019].[SalesLT].[Customer] as C
	on C.CustomerID = CA.CustomerID

select [ListPrice], max([ListPrice])
FROM [AdventureWorksLT2019].[SalesLT].[Product];

select *  FROM [AdventureWorksDW2012].[dbo].[DimCustomer];

select Gender, EnglishOccupation, count(*)
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
Group by [Gender], [EnglishOccupation]
having [EnglishOccupation] = 'Professional';

select *
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
order by CustomerKey

select count(FirstName)
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
where FirstName like 'J%'

select count(*) 
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]

select count(*) 
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
where [Title] is null

select ISNULL(Suffix, 'Customer')
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
  

select count(distinct [EnglishEducation]) 
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]

select [Gender], count(*)
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]
group by [Gender]

select coalesce([FirstName],[MiddleName],[LastName]) as full_name
FROM [AdventureWorksDW2012].[dbo].[DimCustomer]

SELECT TOP (1000) [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[Color]
      ,[StandardCost]
      ,[ListPrice]
      ,[Size]
      ,[Weight]
      ,[ProductCategoryID]
      ,[ProductModelID]
      ,[SellStartDate]
      ,[SellEndDate]
      ,[DiscontinuedDate]
      ,[ThumbNailPhoto]
      ,[ThumbnailPhotoFileName]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorksLT2019].[SalesLT].[Product]


  select *  FROM [AdventureWorksLT2019].[SalesLT].[Product]
  select max(ListPrice) 
  FROM [AdventureWorksLT2019].[SalesLT].[Product]

  select max(ListPrice) 
  FROM [AdventureWorksLT2019].[SalesLT].[Product]
  where [ListPrice] <  (select max(ListPrice) 
  FROM [AdventureWorksLT2019].[SalesLT].[Product])

  select top 1 ListPrice from
  (select  distinct top 2 ListPrice
  FROM [AdventureWorksLT2019].[SalesLT].[Product]
  order by ListPrice desc)
  result
  order by ListPrice

  select ListPrice, DENSE_RANK() over(order by ListPrice desc)
  FROM [AdventureWorksLT2019].[SalesLT].[Product]

  With CTE AS
  (select ListPrice, DENSE_RANK() over(order by ListPrice desc) as denserank
  FROM [AdventureWorksLT2019].[SalesLT].[Product])
  select top 1 ListPrice
  from CTE
  where denserank = 2


  -- Query product with price smaller than 1000
  Select L1.ListPrice 
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as L1
  EXCEPT
  Select L2.ListPrice 
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as L2
  WHERE l2.ListPrice < 1000

   Select L2.ListPrice 
  FROM [AdventureWorksLT2019].[SalesLT].[Product] as L2
  WHERE l2.ListPrice < 1000

  select * FROM [AdventureWorksLT2019].[SalesLT].[Product]
  where [ProductModelID] is not null

  select * FROM [AdventureWorksLT2019].[SalesLT].[Product]
  where [StandardCost] > 100 and Name Like '%m%' 

  select distinct color, count(color)
  FROM [AdventureWorksLT2019].[SalesLT].[Product]
  group by color
  having count(color)>0


  select count (*)
  FROM [AdventureWorksLT2019].[SalesLT].[Product]



