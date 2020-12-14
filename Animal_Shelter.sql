Use Animal_Shelter;

select * from Staff;

-- Granular detail rows
SELECT	* FROM	Adoptions;

-- How many were adopted?
SELECT	COUNT(*)	AS Number_Of_Adoptions FROM	Adoptions;

-- Granular detail rows
SELECT	* FROM	Vaccinations;

SELECT Species, COUNT(*)AS Number_Of_Vaccinations FROM Vaccinations GROUP BY Species;

-- Number of vaccinations per animal
SELECT Name, Species, COUNT(*)	AS Number_Of_Vaccinations FROM Vaccinations
GROUP BY Name, Species;

-- Dealing with NULLs
SELECT Species, Breed, COUNT(*) AS Number_Of_Animals FROM	Animals
GROUP BY Species, Breed;

SELECT	YEAR(Birth_Date) AS Year_Born, COUNT(*) AS Number_Of_Persons
FROM	Persons GROUP BY YEAR(Birth_Date);

SELECT	YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date) AS Age, 
COUNT(*) AS Number_Of_Persons FROM	Persons GROUP BY YEAR(Birth_Date);

SELECT	City,
		MIN(YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date)) AS Oldest_Person,
		MAX(YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date)) AS Youngest_Person,
		COUNT(*) AS Number_Of_Persons
FROM	Persons
GROUP BY City;

SELECT distinct Species,  COUNT(*) AS Number_Of_Vaccines
FROM Vaccinations GROUP BY Species, Name ORDER BY Species, Number_Of_Vaccines;

SELECT	Adopter_Email, COUNT(*) AS Number_Of_Adoptions
FROM Adoptions GROUP BY Adopter_Email HAVING COUNT(*) > 1
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,COUNT(*) AS Number_Of_Adoptions FROM	Adoptions
WHERE	Adopter_Email NOT LIKE '%gmail.com' GROUP BY Adopter_Email
HAVING	COUNT(*) > 1 ORDER BY Number_Of_Adoptions DESC;

SELECT	* FROM	Animals WHERE	Species = 'Dog'	AND Breed <> 'Bullmastiff';

SELECT	* FROM	Persons WHERE	Birth_Date <> '20000101';

SELECT	* FROM	Animals WHERE	Breed = 'Bullmastiff' OR Breed != 'Bullmastiff';

SELECT	* FROM	Animals WHERE	Breed != 'Bullmastiff' OR Breed IS NULL;

SELECT 	* FROM 	Animals WHERE 	ISNULL(Breed, 'Some value') != 'Bullmastiff';

-- CROSS JOIN
select * from Staff CROSS JOIN Staff_Roles;

SELECT	* FROM	Animals AS A CROSS JOIN Adoptions AS AD;

--Inner Join
select AD.*, A.Breed, A.Implant_chip_ID from Animals as A 
Inner JOIN Adoptions as AD on AD.Name = A.name AND AD.Species = A.Species;

--Left outer join
select AD.*, A.Breed, A.Implant_chip_ID from Animals as A 
LEFT OUTER JOIN Adoptions as AD on AD.Name = A.name AND AD.Species = A.Species;

-- INNER JOIN 
SELECT	* FROM Animals AS AN INNER JOIN Adoptions AS AD
			ON AD.Name = AN.Name AND AD.Species = AN.Species
		INNER JOIN Persons AS P ON	AD.Adopter_Email = P.Email;

-- left outer join
SELECT * FROM	Animals AS AN
		LEFT OUTER JOIN Adoptions AS AD ON AD.Name = AN.Name AND AD.Species = AN.Species
		INNER JOIN 	Persons AS P ON P.Email = AD.Adopter_Email;

-- subquery with join
SELECT	* FROM	Animals AS AN
		LEFT OUTER JOIN 
			(
				Adoptions AS AD
				INNER JOIN 
				Persons AS P 
					ON	AD.Adopter_Email = P.Email
			)
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species;

-- 
SELECT	* FROM	Animals AS AN LEFT OUTER JOIN Adoptions AS AD
			INNER JOIN Persons AS P ON	AD.Adopter_Email = P.Email
			ON 	AD.Name = AN.Name AND AD.Species = AN.Species;


/*
Animal vaccinations report.
---------------------------
Write a query to report all animals and their vaccinations.
Animals that have not been vaccinated should be included.
The report should include the following attributes:
Animal's name, species, breed, and primary color,
vaccination time and the vaccine name,
the staff member's first name, last name, and role.*/

SELECT	A.Name,	A.Species,A.Breed,A.Primary_Color,V.Vaccination_Time,V.Vaccine,
		P.First_Name, P.Last_Name, SA.Role FROM	Animals AS A LEFT OUTER JOIN
		(	Vaccinations AS V
			INNER JOIN
			Staff_Assignments AS SA
				ON SA.Email = V.Email
			INNER JOIN
			Persons AS P
				ON P.Email = V.Email
		)
		ON	A.Name = V.Name AND A.Species = V.Species
ORDER BY A.Species, A.Name, A.Breed, V.Vaccination_Time DESC;

/*
Animal vaccination report
--------------------------

Write a query to report the number of vaccinations each animal has received.
Include animals that were never adopted.
Exclude all rabbits.
Exclude all Rabies vaccinations.
Exclude all animals that were last vaccinated on or after October first, 2019.

The report should return the following attributes:
Animals Name, Species, Primary Color, Breed,
and the number of vaccinations this animal has received,

*/

SELECT	AN.Name,
		AN.Species,
		MAX(AN.Primary_Color) AS Primary_Color, -- Dummy aggregate, functionally dependent.
		MAX(AN.Breed) AS Breed, -- Dummy aggregate, functionally dependent.
		COUNT(V.Vaccine) AS Number_Of_Vaccines
FROM	Animals AS AN
		LEFT OUTER JOIN 
		Vaccinations AS V
			ON	V.Name = AN.Name 
				AND 
				V.Species = AN.Species
WHERE	AN.Species <> 'Rabbit'
		AND
		(V.Vaccine <> 'Rabies' OR V.Vaccine IS NULL)
GROUP BY	AN.Species,
			AN.Name
HAVING	MAX(V.Vaccination_Time) < '20191001' 
		OR
		MAX(V.Vaccination_Time) IS NULL
ORDER BY	AN.Species,
			AN.Name;

-- Paging
SELECT TOP(3) *
FROM Animals;

SELECT	TOP(3) *
FROM	Animals
ORDER BY Primary_Color;

SELECT	*
FROM	Animals
ORDER BY Admission_Date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- Order by
SELECT	Adoption_Date, Species, Name
FROM	Adoptions ORDER BY Adoption_Date DESC;

SELECT	* FROM	Animals ORDER BY Species, Name;