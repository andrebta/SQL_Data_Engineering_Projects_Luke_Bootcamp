SELECT CHAR_LENGTH('SQL');

SELECT LOWER('SQL');

SELECT UPPER('Sql');

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL', 2, 1);

SELECT CONCAT('SQL', '-', 'Functions');

SELECT 'SQL' || '-' || 'Functions';

SELECT ' SQL ';

SELECT TRIM(' SQL ');

SELECT REPLACE ('SQL', 'Q', '_');

SELECT REGEXP_REPLACE('data.nerd@gmail.com', '^.*(@)', '\1');

-- Final Example - Cleanup this using Text Functions

SELECT
    job_title,
    CASE
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%analyst%' THEN 'Data Analyst'
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%scientist%' THEN 'Data Scientist'
        WHEN LOWER(job_title) LIKE '%data%' AND LOWER(job_title) LIKE '%enginner%' THEN 'Data Engineer' 
        ELSE 'Other'
    END AS job_title_category
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 30;

WITH title_lower AS(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;

SELECT NULLIF(10,10);

SELECT NULLIF(10,20);

SELECT NULLIF(5+5,20);

SELECT
    salary_year_avg,
    salary_hour_avg
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL or salary_year_avg IS NOT NULL
LIMIT 20;

SELECT
    NULLIF(salary_year_avg, 0),
    NULLIF(salary_hour_avg, 0)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL or salary_year_avg IS NOT NULL
LIMIT 20;

SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL or salary_year_avg IS NOT NULL
LIMIT 20;

SELECT COALESCE (0, 1, 2);

SELECT COALESCE (NULL, 1, 2);

SELECT COALESCE (NULL, NULL, 2);

SELECT
    salary_year_avg::INTEGER,
    salary_hour_avg::INTEGER,
    COALESCE(salary_year_avg, salary_hour_avg*2080)::INTEGER AS salary_year_avg_clean
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 50;

-- Final Example - Simplify with Coalesce

WITH salaries AS (
    SELECT
        job_title_short,
        salary_year_avg,
        salary_hour_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
            ELSE NULL
        END AS standardized_salary
    FROM job_postings_fact
)
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    standardized_salary,
    CASE
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary <75000 THEN 'Low'
        WHEN standardized_salary <150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY standardized_salary DESC;

SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) <75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) <150000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;
