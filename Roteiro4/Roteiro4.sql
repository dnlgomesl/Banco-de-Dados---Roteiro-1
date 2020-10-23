-- Q1
SELECT * FROM department;
-- Q2
SELECT * FROM dependent;
-- Q3
SELECT * FROM dept_locations;
-- Q4
SELECT * FROM employee;
-- Q5
SELECT * FROM project;
-- Q6
SELECT * FROM works_on;
-- Q7
SELECT fname, lname FROM employee WHERE sex = 'M';
-- Q8
SELECT fname FROM employee WHERE superssn IS NULL AND sex = 'M';
-- Q9
SELECT e.fname AS employee_name, s.fname AS super_name FROM employee e, employee s WHERE e.superssn IS NOT NULL AND e.superssn = s.ssn;
-- Q10
SELECT fname FROM employee e WHERE e.superssn = (SELECT ssn FROM employee s WHERE s.fname = 'Franklin');
-- Q11
SELECT d.dname, l.dlocation FROM department d, dept_locations l WHERE d.dnumber = l.dnumber; 
-- Q12 
SELECT d.dname FROM department d, dept_locations l WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';
-- Q13
SELECT e.fname, e.lname, d.dependent_name FROM employee e, dependent d WHERE e.ssn = d.essn;
-- Q14
SELECT e.fname || ' '  || e.lname AS full_name, e.salary FROM employee e WHERE e.salary > 50000;
-- Q15
SELECT p.pname, d.dname FROM project p, department d WHERE p.dnum = d.dnumber;
-- Q16
SELECT p.pname, e.fname FROM project p, employee e, department d WHERE p.pnumber > 30 AND d.mgrssn = e.ssn AND d.dnumber = p.dnum;
-- Q17
SELECT p.pname, e.fname FROM project p, employee e, works_on w WHERE w.pno = p.pnumber AND w.essn = e.ssn;
-- Q18
SELECT e.fname, d.dependent_name, d.relationship FROM employee e, dependent d, works_on w WHERE w.pno = 91 AND w.essn = e.ssn AND d.essn = e.ssn;

