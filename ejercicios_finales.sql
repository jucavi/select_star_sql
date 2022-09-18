-- SELECT STAR SQL
-- https://selectstarsql.com/questions.html

-- Ejercicio 1.
SELECT senator, count(senator) as count_mutual
FROM (
	SELECT DISTINCT s.sponsor_name as senator, s.cosponsor_name
	FROM cosponsors AS s
	JOIN cosponsors as c
	ON s.sponsor_name = c.cosponsor_name AND c.sponsor_name = s.cosponsor_name
)
GROUP BY senator
ORDER BY count_mutual DESC
LIMIT 1


-- Ejercicio 2
WITH
senator_count_mutual as (
SELECT senator, state, count(senator) as count_mutual
FROM (
	SELECT DISTINCT
  		s.sponsor_name as senator,
  		s.cosponsor_name as cosponsor,
  		s.sponsor_state as state
	FROM cosponsors AS s
	JOIN cosponsors as c
	ON
  		s.sponsor_name = c.cosponsor_name AND
  		c.sponsor_name = s.cosponsor_name
)
GROUP BY senator
),
state_max_count as (
	SELECT
  		s.state as state,
  		max(count_mutual) as max_count
	FROM senator_count_mutual as s
	GROUP BY state
)

SELECT
	sc.state as state,
	senator, sc.max_count as count_mutual
FROM senator_count_mutual as scm
JOIN state_max_count as sc
ON
	scm.state = sc.state AND
	scm.count_mutual = sc.max_count




-- Ejercicio 3
SELECT DISTINCT cosponsors.cosponsor_name as senator
FROM cosponsors
WHERE
	senator NOT IN (
	  	SELECT DISTINCT cosponsors.sponsor_name
	  	FROM cosponsors
	)

-- Mas eficiente según el tutorial
SELECT DISTINCT c1.cosponsor_name
FROM cosponsors c1
LEFT JOIN cosponsors c2
ON c1.cosponsor_name = c2.sponsor_name
-- This join identifies cosponsors
-- who have sponsored bills
WHERE c2.sponsor_name IS NULL
-- LEFT JOIN + NULL is a standard trick for excluding
-- rows. It's more efficient than WHERE ... NOT IN

