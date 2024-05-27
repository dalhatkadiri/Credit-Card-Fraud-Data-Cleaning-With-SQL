--Cleaning the data using SQL

SELECT *
FROM FraudDetection.dbo.fraudTest2;

--1. Standardizing the transaction date

ALTER TABLE FraudDetection.dbo.fraudTest2
ADD trans_date2 DATE;

ALTER TABLE FraudDetection.dbo.fraudTest2
ADD dob2 DATE;

UPDATE FraudDetection.dbo.fraudTest2
SET trans_date2 = CONVERT(DATE, trans_date),
    dob2 = CONVERT(DATE, dob);

SELECT *
FROM FraudDetection.dbo.fraudTest2;

--2. Checking the number of rows for is NULL or empty strings

SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN trans_date IS NULL OR trans_date = '' THEN 1 END) AS trans_date_nulls_or_empty,
    COUNT(CASE WHEN merchant IS NULL OR merchant = '' THEN 1 END) AS merchant_nulls_or_empty,
    COUNT(CASE WHEN category IS NULL OR category = '' THEN 1 END) AS category_nulls_or_empty,
    COUNT(CASE WHEN amt IS NULL OR amt = 0 THEN 1 END) AS amt_nulls_or_empty,
    COUNT(CASE WHEN first_name IS NULL OR first_name = '' THEN 1 END) AS first_name_nulls_or_empty,
    COUNT(CASE WHEN last_name IS NULL OR last_name = '' THEN 1 END) AS last_name_nulls_or_empty,
    COUNT(CASE WHEN gender IS NULL OR gender = '' THEN 1 END) AS gender_nulls_or_empty,
    COUNT(CASE WHEN street IS NULL OR street = '' THEN 1 END) AS street_nulls_or_empty,
    COUNT(CASE WHEN city IS NULL OR city = '' THEN 1 END) AS city_nulls_or_empty,
    COUNT(CASE WHEN state IS NULL OR state = '' THEN 1 END) AS state_nulls_or_empty,
    COUNT(CASE WHEN zip IS NULL OR zip = '' THEN 1 END) AS zip_nulls_or_empty,
    COUNT(CASE WHEN job IS NULL OR job = '' THEN 1 END) AS job_nulls_or_empty,
    COUNT(CASE WHEN dob IS NULL OR dob = '' THEN 1 END) AS dob_nulls_or_empty,
    COUNT(CASE WHEN is_fraud IS NULL THEN 1 END) AS is_fraud_nulls_or_empty
FROM FraudDetection.dbo.fraudTest2;

--3. Checking for duplicate

SELECT 
    trans_date,
    merchant,
    category,
    amt,
    first_name,
    last_name,
    gender,
    street,
    city,
    state,
    zip,
    job,
    dob,
    is_fraud,
    COUNT(*) AS duplicate_count
FROM FraudDetection.dbo.fraudTest2
GROUP BY 
    trans_date,
    merchant,
    category,
    amt,
    first_name,
    last_name,
    gender,
    street,
    city,
    state,
    zip,
    job,
    dob,
    is_fraud
HAVING COUNT(*) > 1;

--4. Removing duplicate

WITH DuplicateRows AS (
    SELECT 
        trans_date,
        merchant,
        category,
        amt,
        first_name,
        last_name,
        gender,
        street,
        city,
        state,
        zip,
        job,
        dob,
        is_fraud,
        ROW_NUMBER() OVER (
            PARTITION BY 
                trans_date,
                merchant,
                category,
                amt,
                first_name,
                last_name,
                gender,
                street,
                city,
                state,
                zip,
                job,
                dob,
                is_fraud
            ORDER BY (SELECT NULL) 
        ) AS RowNum
    FROM FraudDetection.dbo.fraudTest2
)
DELETE FROM DuplicateRows WHERE RowNum > 1;

--5. Checking for inconsistent data 

SELECT DISTINCT gender
FROM FraudDetection.dbo.fraudTest2;

--6. Deleting unused column 

ALTER TABLE FraudDetection.dbo.fraudTest2
DROP COLUMN trans_date, dob;

SELECT *
FROM FraudDetection.dbo.fraudTest2;

