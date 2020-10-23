-- Q1
SELECT COUNT(*) FROM employee WHERE sex = 'F';
-- Q2
SELECT AVG(salary) FROM employee WHERE sex = 'M' and address LIKE '%TX';
-- Q3
SELECT superssn AS super_ssn, COUNT(*) AS qtd_supervisionados FROM employee GROUP BY superssn ORDER BY COUNT(*);
-- Q4
SELECT s.fname AS nome_supervisor, COUNT(e) AS qtd_supervisionados FROM employee s JOIN employee e
ON e.superssn = s.ssn GROUP BY s.fname ORDER BY COUNT(e);
-- Q5
SELECT s.fname AS nome_supervisor, COUNT(e) AS qtd_supervisionados FROM employee s RIGHT OUTER JOIN employee e
ON e.superssn = s.ssn GROUP BY s.fname ORDER BY COUNT(e);
-- Q6
SELECT MIN (w.qtd) AS qtd FROM (SELECT COUNT(*) AS qtd FROM employee e, works_on w WHERE e.ssn = w.essn GROUP BY w.pno) AS w;
-- Q7 falta arrumar
SELECT w2.pno AS num_projeto, MIN(w1.qtd) AS qtd_func
FROM (SELECT w.pno, COUNT(e) AS qtd
	FROM employee e, works_on w
	WHERE e.ssn = w.essn
	GROUP BY w.pno) AS w1,
	(SELECT w.pno, COUNT(e) AS qtd
	FROM employee e, works_on w
	WHERE e.ssn = w.essn
	GROUP BY w.pno) AS w2
GROUP BY w2.pno, w2.qtd
HAVING w2.qtd = MIN(w1.qtd);
-- Q8
SELECT w.pno AS num_projeto, AVG(e.salary) AS media_sal FROM employee e, works_on w WHERE e.ssn = w.essn GROUP BY num_projeto;
-- Q9
SELECT w.pno AS num_projeto, p.pname AS proj_nome, AVG(e.salary) AS media_sal FROM employee e, works_on w, project p WHERE e.ssn = w.essn and p.pnumber = w.pno 
GROUP BY num_projeto, proj_nome;
-- Q10
SELECT fname, salary FROM employee e, works_on w WHERE NOT(w.pno = 92) AND e.salary >
(SELECT MAX(sals.sal) FROM (SELECT e2.salary AS sal FROM employee e2, works_on w2 WHERE e2.ssn = w2.essn AND w2.pno = 92) AS sals) GROUP BY fname, salary;
-- Q11
SELECT e.ssn AS ssn, 
    CASE 
        WHEN COUNT(w) IS NULL THEN 0
        ELSE COUNT(w)
        END AS qtd_proj
FROM employee e LEFT JOIN works_on w ON w.essn = e.ssn GROUP BY ssn ORDER BY COUNT(w);
-- Q12
SELECT w.pno AS num_proj, w.qtd AS qtd_func FROM 
(SELECT w.pno as pno, COUNT(e) AS qtd FROM employee e LEFT OUTER JOIN works_on w ON e.ssn = w.essn GROUP BY w.pno) AS w
WHERE w.qtd < 5 ORDER BY w.qtd;
-- Q13
SELECT fname FROM employee e, works_on w, project p WHERE w.pno = p.pnumber AND e.ssn = w.essn AND p.plocation = 'Sugarland'
AND e.ssn in (SELECT essn FROM dependent)
GROUP BY fname;
-- Q14
SELECT dname FROM department d WHERE NOT EXISTS(SELECT p.dnum FROM project p WHERE p.dnum = d.dnumber);
-- Q15
SELECT fname, lname FROM employee e WHERE NOT EXISTS
((SELECT w.pno FROM works_on w WHERE w.essn = '123456789')
EXCEPT (SELECT w2.pno FROM works_on w2 WHERE w2.essn = e.ssn AND NOT(e.ssn = '123456789')));