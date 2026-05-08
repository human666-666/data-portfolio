-- Evanston, Illinois data

-- Compute monthly counts of requests created 

WITH created AS (
    SELECT 
        date_trunc('month', date_created) AS month,
        COUNT(*) AS created_count
        FROM evanston311
        WHERE category = 'Rodents-Rats'
        GROUP BY month
),

-- Compute monthly counts of requests closed

    completed AS (
        SELECT
            date_trunc('month', date_completed) AS month,
            COUNT(*) AS completed_count
            FROM evanston311 
            WHERE category = 'Rodents-Rats' AND date_completed IS NOT NULL 
            GROUP BY month
    )

-- Combine created & completed counts

SELECT
    created.month,
    created.created_count,
    completed.completed_count
FROM created 
INNER JOIN completed
    ON created.month = completed.month
ORDER BY created.month; 



-- Select the first 50 characters when length of description is > 50

SELECT
    CASE 
        WHEN length(description) > 50 
        THEN left(description, 50) || '...'
        ELSE description 
        END AS shortened_description
FROM evanston311
WHERE description LIKE '%rats%'
ORDER BY description
LIMIT 10;


-- Count rows where the description contains 'rats' and the request is still open (date_completed IS NULL)

SELECT
    COUNT(*) AS open_rat_requests
FROM evanston311
WHERE description ILIKE '%rats%' AND date_completed IS NULL;


-- Compute the average time to complete requests related to rats, grouped by month

SELECT
    AVG(date_completed - date_created) AS avg_completion_time
FROM evanston311
WHERE description ILIKE '%rats%' AND date_completed IS NOT NULL
GROUP BY date_trunc('month', date_created)
ORDER BY date_trunc('month', date_created);


-- Compute average daily requests related to rats for each month
-- Casting both date_trunc to date for a cleaner output

SELECT
    date_trunc('month', day)::date AS month,
    AVG(count) AS avg_daily_requests
FROM (
    SELECT
        date_trunc('day', date_created)::date AS day,
        COUNT(*) AS count
    FROM evanston311
    WHERE description ILIKE '%rats%'
    GROUP BY day) AS daily_counts
GROUP BY month
ORDER BY month;


-- Generating bins for speed of request completion by category 
-- Date columns are of type timestamp, so we can use interval arithmetic 
    -- to compute the time difference between date_completed & date_created

SELECT
    category,
    CASE
        WHEN date_completed IS NULL THEN 'Open'
        WHEN date_completed - date_created <= INTERVAL '7 days' THEN '0-7 days'
        WHEN date_completed - date_created <= INTERVAL '14 days' THEN '8-14 days'
        ELSE '15+ days'
    END AS completion_time_bin,
    COUNT(*) AS request_count
FROM evanston311
GROUP BY category, completion_time_bin
ORDER BY completion_time_bin;

