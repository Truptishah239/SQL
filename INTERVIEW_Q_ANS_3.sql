
--- All about LIKE, %,  and _


Create TABLE likeoperator(SID INT,SNAME VARCHAR(20))

INSERT INTO likeoperator
SELECT 1,'ABCDZ'
UNION
SELECT 2,'FEGH'
UNION
SELECT 3,'IJKL'
UNION
SELECT 4,'MNOOPZ'
UNION
SELECT 5,'KISTZ'

/*
%-->Multiplechar
_-->Singlechar
*/

--1.get those records which sname start with a...

SELECT * FROM likeoperator
WHERE SNAME LIKE 'a%'

--2.get those records which sname end with z...

SELECT * FROM likeoperator
WHERE SNAME LIKE '%z'

--3.get those records which sname start with a and end with z...

SELECT * FROM likeoperator
WHERE SNAME LIKE 'a%z'

--4.get those records which sname's second position is B

SELECT * FROM likeoperator
WHERE SNAME LIKE '_b%'

--5.get those records which sname contains CD any at position

SELECT * FROM likeoperator
WHERE SNAME LIKE '%cd%'

--6.get those records which sname start with a and contains atleast 3 char

SELECT * FROM likeoperator
WHERE SNAME LIKE 'a%_%_%'

--7.get those records which sname start with a or m  or f

SELECT * FROM likeoperator
WHERE SNAME LIKE '[amf]%'

--8.get those records which sname does not start with a or m  or f

SELECT * FROM likeoperator
WHERE SNAME not LIKE '[amf]%'

--9.get those records which sname start between a and m

SELECT * FROM likeoperator
WHERE SNAME LIKE '[A-M]%'

--10.Get those records which name contain % 

Insert Into likeoperator values (6,'xyx%tt')

SELECT * FROM likeoperator
WHERE SNAME LIKE '%[%]%'

--11.Get those records which name contain _

Insert Into likeoperator values (7,'xyx_tt')

SELECT * FROM likeoperator
WHERE SNAME LIKE '%[_]%'


