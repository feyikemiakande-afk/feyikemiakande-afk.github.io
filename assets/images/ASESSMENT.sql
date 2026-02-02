-- Creating the database
CREATE DATABASE Studentsperformance_db;

-- using database
USE Studentsperformance_db;

SHOW TABLES;

-- Exploring dataset in table
DESCRIBE studentsperformance;

-- Analysing dataset
-- What are the average math, reading, and writing scores for all students?

SELECT
    AVG(`math score`)    AS avg_math_score,
    AVG(`reading score`) AS avg_reading_score,
    AVG(`writing score`) AS avg_writing_score
FROM studentsperformance;

-- How does the average performance differ between male and female students?
SELECT 
	gender,
    AVG(`math score`)  AS averagemath_score,
    AVG (`reading score`) AS averagereading_score,
    AVG (`writing score`) AS averagewriting_score
FROM studentsperformance
GROUP by gender;

-- what is the highest and lowest math score in the dataset?
SELECT 
	MAX(`math score`) AS highestmath_score,
    MIN(`math score`) AS lowestmath_score
FROM studentsperformance;

-- how many students scored between 60 and 80 in math
SELECT 
	COUNT(*) AS mathscore_between_60and80
FROM studentsperformance
WHERE `math score` BETWEEN 60 AND 80;

-- does the parental level of education affect the students average score 
SELECT 
	`parental level of education` ,
	AVG (`math score`) + AVG(`reading score`) + AVG(`writing score`) AS average_totalscore
FROM studentsperformance
GROUP BY `parental level of education`
ORDER BY average_totalscore DESC;

-- What is the impact of completing a test preparation course on scores?
SELECT 
	`test preparation course`,
	AVG (`math score`) +AVG( `reading score`) + AVG( `writing score`) AS average_totalscore
FROM studentsperformance
GROUP BY `test preparation course`
ORDER BY average_totalscore DESC;

-- By how much does test preparation improve total test score 
SELECT
    MAX(average_totalscore) - MIN(average_totalscore) AS score_improvementgap
FROM (
    SELECT
        `test preparation course`,
        AVG(`math score`) + AVG(`reading score`) + AVG(`writing score`) AS average_totalscore
    FROM studentsperformance
    GROUP BY `test preparation course`
) t;


--  How does the type of lunch (socio-economic factor) affect student performance?
SELECT
	lunch,
    AVG (`math score`) + AVG(`reading score`) + AVG(`writing score`) AS average_totalscore
FROM studentsperformance
GROUP BY lunch
ORDER BY average_totalscore DESC;
    
-- Which race/ethnicity group has the highest average total score?
SELECT 
	`race/ethnicity`,
    AVG(`math score`) + AVG(`reading score`) + AVG( `writing score`) AS average_totalscore
FROM studentsperformance
GROUP BY `race/ethnicity`
ORDER BY average_totalscore DESC;

-- How many students scored above 90 in all three subjects?
SELECT
	COUNT(*) AS students_above_90_in_all_subjects
FROM studentsperformance
WHERE 	`math score` > 90
AND `reading score` > 90
AND `writing score` > 90;

-- how many students passed in all subjects
SELECT
	CASE
WHEN `reading score` > 50
AND `math score` > 50
AND `writing score` > 50
THEN 'passed'
ELSE 'failed'
END AS pass_status,
COUNT(*) AS students_above_passed_all_subjects
FROM studentsperformance
GROUP BY pass_status;

-- Identify which subject has the highest number of top-performing students (score > 90)
SELECT
	subject,
    COUNT(*) AS students_above_90
FROM (
	SELECT 'Math' AS subject
    FROM studentsperformance
    WHERE `math score`> 90
    
    UNION ALL
    
    SELECT 'Reading' AS subject
    FROM studentsperformance
    WHERE `reading score` > 90
    
    UNION ALL
    
    SELECT 'Writing' AS subject
    FROM studentsperformance
    WHERE `writing score` > 90
    ) sub_query
GROUP BY subject
ORDER BY students_above_90 DESC;

-- What is the distribution of students across different parental education levels?
SELECT
	`parental level of education`,
    COUNT(*) AS students_count
FROM studentsperformance
GROUP BY `parental level of education`
ORDER BY students_count DESC;

--  Who are the least 5 students based on their total combined score?
SELECT gender, `race/ethnicity`,
		(`math score`) + (`reading score`) + (`writing score`) AS total_score
FROM studentsperformance
ORDER BY total_score ASC
LIMIT 5;

-- What is the average total score for students grouped by both gender and test preparation status?
SELECT 
gender,
`test preparation course`,
AVG(`math score`) + AVG(`writing score`) + AVG(`reading score`) AS average_totalscore
FROM studentsperformance
GROUP BY gender, `test preparation course`
ORDER BY average_totalscore ASC;

SELECT
    MAX(average_total) - MIN(average_total) AS score_improvement_gap
FROM (
    SELECT
        `test preparation course`,
        AVG(`math score`) + AVG(`reading score`) + AVG(`writing score`) AS average_total
    FROM studentsperformance
    GROUP BY `test preparation course`
) t;

-- Analysing what gender did better in tests
SELECT 
	gender,
    AVG (`math score`) AS average_math,
    AVG (`reading score`) AS average_reading,
    AVG (`writing score`) AS average_writing
FROM studentsperformance
GROUP BY gender
ORDER BY average_math, average_reading, average_writing ASC;

CREATE VIEW student_totalscores AS
SELECT *,
       (`math score`) + (`reading score`) + (`writing score`) AS total_viewscore
FROM studentsperformance;

-- Distribution of students across all subjects (by total score)
SELECT
	 total_viewscore,
     `math score`,
     `writing score`,
     `reading score`,
      gender
FROM student_totalscores
ORDER BY total_viewscore DESC;

-- distrubution of student per subjects
-- assumption that every score is graded over 100
SELECT
    CASE
        WHEN total_viewscore >= 270 THEN 'High'
        WHEN total_viewscore >= 210 THEN 'Medium'
        ELSE 'Low'
    END AS performance_band,
    COUNT(*) AS student_count
FROM student_totalscores
GROUP BY performance_band;

    

