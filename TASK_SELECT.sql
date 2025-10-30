
SELECT Dnum,Dname,SSN, Fname +' '+ Lname AS full_name FROM Departments,Employee;

SELECT Dname,Pname FROM Departments,Project;

SELECT d.ESSN,d.Dependent_name,d.Sex,d.Bdate,Fname +' '+ Lname AS full_name FROM Dependent d JOIN Employee e ON ESSN=SSN;

SELECT Pnumber,Pname,Plocation From Project WHERE  City='Cairo' Or City= 'Alex';

SELECT * FROM Project WHERE Pname LIKE 'A%';

SELECT SSN, Fname +' '+ Lname AS full_name From Employee WHERE Dno=30 AND Salary between 1000 AND 2000;

SELECT Fname +' '+ Lname AS full_name FROM Employee, Works_for, Project WHERE Pno=Pnumber AND Dno=10 AND Hours >= 10 AND Pname = 'AL Rabwah';

SELECT e.Fname +' '+ e.Lname AS full_name FROM Employee e JOIN Employee ee ON e.Superssn = ee.SSN WHERE ee.Fname = 'Kamel' AND ee.Lname= 'Mohamed';
SELECT e.Fname +' '+ e.Lname AS full_name FROM Employee e, Employee ee  WHERE e.Superssn=ee.SSN AND ee.Fname = 'Kamel' AND ee.Lname= 'Mohamed';


SELECT e.Fname +' '+ e.Lname AS full_name, Pname FROM Employee e, Project p WHERE p.Dnum= e.Dno ORDER BY Pname;


 SELECT Pname, Dname , Lname , Address, Bdate FROM Departments d, Employee e, Project p WHERE p.City = 'Cairo' AND p.Dnum= d.Dnum AND d.MGRSSN=e.SSN;

 SELECT * FROM Employee, Departments WHERE MGRSSN=SSN;

 SELECT * FROM Employee LEFT JOIN Dependent ON SSN=ESSN;