-- check the data
select * from Adoptions;

--adoption fee per date
SELECT Adoption_Date, SUM (Adoption_Fee) as Total_Fee
FROM Adoptions
GROUP BY Adoption_Date
HAVING COUNT(*) > 1;

-- Add Animals name and species
SELECT Adoption_Date, SUM (Adoption_Fee) as Total_Fee,
STRING_AGG(CONCAT(Name, ' the ', Species), ',')  
WITHIN GROUP (ORDER BY Species, Name) AS Adopted_Animals
FROM Adoptions
GROUP BY Adoption_Date
HAVING COUNT(*) > 1;

-- Add breed to animal's string description 
SELECT	Adoption_Date,
		SUM(Adoption_Fee) AS Total_Fee,
		STRING_AGG(CONCAT(AN.Name, ' the ',  AN.Breed, ' ', AN.Species), ', ')
		WITHIN GROUP (ORDER BY AN.Species, AN.Breed, AN.Name) AS Using_CONCAT,
		STRING_AGG(AN.Name + ' the ' +  AN.Breed + ' ' + AN.Species, ', ')
		WITHIN GROUP (ORDER BY AN.Species, AN.Breed, AN.Name) AS Using_Plus
FROM	Adoptions AS AD
		INNER JOIN
		Animals AS AN
			ON 	AN.Name = AD.Name 
				AND 
				AN.Species = AD.Species
GROUP BY Adoption_Date
HAVING	COUNT(*) > 1;

---Number of annual, monthly and overall adoption
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			(YEAR(Adoption_Date), MONTH(Adoption_Date)),
			YEAR(Adoption_Date),
			()
		)
ORDER BY Year, Month;

---Number of Species and breed
SELECT	COALESCE(Species, 'All') AS Species,
		CASE 
			WHEN GROUPING(Breed) = 1
			THEN 'All'
			ELSE Breed
		END AS Breed,
		GROUPING(Breed) AS Is_This_All_Breeds,
		COUNT(*) AS Number_Of_Animals
FROM	Animals
GROUP BY GROUPING SETS 
		(
			Species,
			Breed,
			()
		)
ORDER BY Species, Breed;

--- Count the number of vaccination per YEAR / SPECIES/ SPECIES PER YEAR
select * from Vaccinations;

SELECT	YEAR(Vaccination_Time) AS Year,
		COALESCE(Species, 'All') AS Species,
		COUNT(*) AS Yearly_vaccination
FROM	Vaccinations
GROUP BY GROUPING SETS	
		(
			(YEAR(Vaccination_Time)),
			(Species),
			()
		)
ORDER BY Year;

----- Count the number of vaccination per YEAR / SPECIES/ SPECIES PER YEAR/ STAFF MEMBER/ STAFF MEMBER AND SPECIES
-- Must use the GROUPING function to distinguish "All staff" from individuals
SELECT	COALESCE(CAST(YEAR(V.Vaccination_Time) AS VARCHAR(10)), 'All Years') AS Year,
		COALESCE(V.Species, 'All Species') AS Species,
		COALESCE(V.Email, 'All Staff') AS Email,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.First_Name) -- Dummy aggregate
			ELSE ''
			END AS First_Name,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.Last_Name) -- Dummy aggregate
			ELSE ''
			END AS Last_Name,
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							YEAR(V.Vaccination_Time),
							V.Species,
							(YEAR(V.Vaccination_Time), V.Species),
							(V.Email),
							(V.Email, V.Species)
						)
ORDER BY Year, Species, First_Name, Last_Name;