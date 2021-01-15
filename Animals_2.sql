/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Name]
      ,[Species]
      ,[Adopter_Email]
      ,[Adoption_Date]
      ,[Adoption_Fee]
  FROM [Animal_Shelter].[dbo].[Adoptions]

  SELECT *, 
  (select max(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions]) as Max_Fee
   FROM [Animal_Shelter].[dbo].[Adoptions];

-- Discount % = ((Y-X)*100 /Y)
  SELECT *, 
  (select max(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions]),
  (((select max(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions])
  -  Adoption_Fee) * 100 ) / (select max(Adoption_Fee) FROM [Animal_Shelter].[dbo].[Adoptions]) AS discount_percentage
   FROM [Animal_Shelter].[dbo].[Adoptions];

   ---max fee for each species instead of overall

    SELECT Species,max(Adoption_Fee) 
    FROM [Animal_Shelter].[dbo].[Adoptions]
    group by Species;

	----------------------------------------
	 SELECT *, 
	 COUNT(Species) OVER (PARTITION BY Species) AS speciesTotal,
	 max(Adoption_Fee) OVER (PARTITION BY Species)as MaxFee
    FROM [Animal_Shelter].[dbo].[Adoptions];

	---Show all attribute for people who adopted at least one animal

	SELECT count(*)  FROM [Animal_Shelter].[dbo].[Persons];

	SELECT count(*) FROM [Animal_Shelter].[dbo].[Adoptions];

	SELECT DISTINCT P.* FROM Persons AS P
	INNER JOIN Adoptions AS A
	ON A.Adopter_Email = P.Email;

	--- Another way 
	SELECT * FROM PERSONS WHERE Email IN (SELECT Adopter_Email FROM Adoptions);


	------using Exist
SELECT * FROM PERSONS as P WHERE EXISTS 
(SELECT NULL FROM Adoptions AS A WHERE A.Adopter_Email = P.Email);

---set operators
select Name , Species from Animals
except 
select Name , Species from Adoptions;

-- show which breeds were never adopted

SELECT *  FROM [Animal_Shelter].[dbo].[Persons];
SELECT * FROM [Animal_Shelter].[dbo].[Adoptions];
SELECT * FROM [Animal_Shelter].[dbo].[Animals];


SELECT	Species, Breed
FROM	Animals
EXCEPT	
SELECT	AN.Species, AN.Breed 
FROM	Animals AS AN
		INNER JOIN
		Adoptions AS AD
		ON	AN.Species = AD.Species
			AND
			AN.Name = AD.Name;
   
  
  -- show adoptors who adopted 2 animals in 1 day
 SELECT	A1.Adopter_Email,
		A1.Adoption_Date,
		A1.Name AS First_Animal_Name,
		A1.Species AS Firs_Animal_Species,
		A2.Name AS Second_Animal_Name,
		A2.Species AS Second_Animal_Species
FROM	Adoptions AS A1
		INNER JOIN
		Adoptions AS A2
			ON	A1.Adopter_Email = A2.Adopter_Email
				AND A1.Adoption_Date = A2.Adoption_Date
				AND	(	(A1.Name = A2.Name AND A1.Species > A2.Species)
						OR
						(A1.Name > A2.Name AND A1. Species = A2.Species)
						OR
						(A1.Name <> A2.Name AND A1.Species > A2.Species)
					)
ORDER BY	A1.Adopter_Email,
			A1.Adoption_Date;

-- show animals and their most recent vaccination
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		CROSS APPLY
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;


-- OUTER APPLY
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		OUTER APPLY
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;

---pure breed
SELECT A.Species,
		A.Breed, A.Name AS Male, A2.Name AS Female
FROM	Animals AS A
INNER JOIN Animals A2
		ON A.Species = A2.Species
		AND A.Breed = A2.Breed
		and A.Breed is Not Null
		AND A.Name <> A2.Name
		AND A.Gender = 'M'
		AND A2.Gender = 'F'
ORDER BY A.Species , A.Breed;


