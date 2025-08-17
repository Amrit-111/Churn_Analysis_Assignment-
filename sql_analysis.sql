show tables;
DROP TABLE cloudsync.`project analyst assignment`;
DROP TABLE cloudsync.telco_churn;
show tables;
SELECT * 
FROM cloudsync.project_analyst_assignment
LIMIT 10;

SELECT COUNT(*) AS total_rows FROM cloudsync.project_analyst_assignment;    -- here i'm checking how many row no in there

-- Here I'm trying to make simplifier by assigning the database name as "Assignment" and the table name is "project"
CREATE DATABASE Assignment;
RENAME TABLE cloudsync.project_analyst_assignment TO Assignment.project;

USE Assignment;
SELECT * FROM project LIMIT 10;

/* Here I'm trying to cross check did i import all data correctly or not . 
So here I'm going to create a temporary table (temp_import) to cross check ,
whaether all columns and rows is matching is with main table (project). Later on i will drop that temporary table
*/

CREATE TABLE temp_import LIKE project;

ALTER TABLE temp_import CHANGE COLUMN `ï»¿customerID` customerID VARCHAR(50);

SELECT COUNT(*) FROM temp_import;   -- here the ans is 7032 rows 
SELECT COUNT(*) FROM project;       -- here also 7032 rows. i got the same no.of rows in both
DROP TABLE temp_import;             -- i have delete the complete temporary table 

SELECT * 
FROM assignment.project
LIMIT 10;

ALTER TABLE project CHANGE COLUMN `ï»¿customerID` customerID VARCHAR(50);

/* -----------------------------------------------------------
   Task 1: Data Quality Assessment & Exploration
   Part 1_Objective: Here I will try to identify missing (Null or Blank' ') values
   ----------------------------------------------------------- */



SELECT 
    'Missing Values' AS check_type,  -- it is the Label for the type of check
    col.column_name,                 
    COUNT(*) AS total_records,        -- here I'm trying to find the total number of records in the table
    SUM(CASE WHEN TRIM(col_value) = '' OR col_value IS NULL THEN 1 ELSE 0 END) AS missing_count,        -- here I'm looking how many values are missing
    ROUND(SUM(CASE WHEN TRIM(col_value) = '' OR col_value IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS missing_percentage   -- what is the Percentage of missing values

-- here we will  check every column for missing values.
FROM (
    SELECT 'customerID' AS column_name, customerID AS col_value FROM assignment.project
    UNION ALL
    SELECT 'gender', gender FROM assignment.project
    UNION ALL
    SELECT 'SeniorCitizen', SeniorCitizen FROM assignment.project
    UNION ALL
    SELECT 'Partner', Partner FROM assignment.project
    UNION ALL
    SELECT 'Dependents', Dependents FROM assignment.project
    UNION ALL
    SELECT 'tenure', tenure FROM assignment.project
    UNION ALL
    SELECT 'PhoneService', PhoneService FROM assignment.project
    UNION ALL
    SELECT 'MultipleLines', MultipleLines FROM assignment.project
    UNION ALL
    SELECT 'InternetService', InternetService FROM assignment.project
    UNION ALL
    SELECT 'OnlineSecurity', OnlineSecurity FROM assignment.project
    UNION ALL
    SELECT 'OnlineBackup', OnlineBackup FROM assignment.project
    UNION ALL
    SELECT 'DeviceProtection', DeviceProtection FROM assignment.project
    UNION ALL
    SELECT 'TechSupport', TechSupport FROM assignment.project
    UNION ALL
    SELECT 'StreamingTV', StreamingTV FROM assignment.project
    UNION ALL
    SELECT 'StreamingMovies', StreamingMovies FROM assignment.project
    UNION ALL
    SELECT 'Contract', Contract FROM assignment.project
    UNION ALL
    SELECT 'PaperlessBilling', PaperlessBilling FROM assignment.project
    UNION ALL
    SELECT 'PaymentMethod', PaymentMethod FROM assignment.project
    UNION ALL
    SELECT 'MonthlyCharges', MonthlyCharges FROM assignment.project
    UNION ALL
    SELECT 'TotalCharges', TotalCharges FROM assignment.project
    UNION ALL
    SELECT 'Churn', Churn FROM assignment.project
) AS col
GROUP BY col.column_name;    -- Group results per column


/* -----------------------------------------------------------
   Task 1: Data Quality Assessment & Exploration
   Part 2_Objective: Here I will try to identify missing (Null or Blank' ') values
   ----------------------------------------------------------- */

-- It is about DataBase metadata 
SELECT 
    column_name, 
    data_type, 
    character_maximum_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'project' AND table_schema = 'assignment';




/**********************************************
 No.1: DATA TYPE INCONSISTENCIES
 here we will Check if values in each column fall outside
 the expected domain (categorical or numeric)
**********************************************/


-- Here I'm first checking all Numeric Columns i.e: SeniorCitizen,tenure,MonthlyCharges,TotalCharges
-- I'm adding this by Union All 

SELECT DISTINCT 'SeniorCitizen' AS column_name, SeniorCitizen AS invalid_value
FROM assignment.project
WHERE SeniorCitizen IS NULL OR SeniorCitizen NOT IN (0,1)
UNION ALL
SELECT DISTINCT 'tenure', tenure
FROM assignment.project
WHERE tenure IS NULL OR tenure < 0
UNION ALL
SELECT DISTINCT 'MonthlyCharges', MonthlyCharges
FROM assignment.project
WHERE MonthlyCharges IS NULL OR MonthlyCharges < 0
UNION ALL
SELECT DISTINCT 'TotalCharges', TotalCharges
FROM assignment.project
WHERE TotalCharges IS NULL OR TotalCharges < 0;

--  Here I'm first checking all Categorical Columns i.e: gender, partner,Dependents,PaperlessBilling,phoneservice ,etc 

SELECT DISTINCT 'gender' AS column_name, gender AS invalid_value
FROM assignment.project
WHERE gender NOT IN ('Male','Female')
UNION ALL
SELECT DISTINCT 'Partner', Partner
FROM assignment.project
WHERE Partner NOT IN ('Yes','No')
UNION ALL
SELECT DISTINCT 'Dependents', Dependents
FROM assignment.project
WHERE Dependents NOT IN ('Yes','No')
UNION ALL
SELECT DISTINCT 'PhoneService', PhoneService
FROM assignment.project
WHERE PhoneService NOT IN ('Yes','No')
UNION ALL
SELECT DISTINCT 'PaperlessBilling', PaperlessBilling
FROM assignment.project
WHERE PaperlessBilling NOT IN ('Yes','No')
UNION ALL
SELECT DISTINCT 'Churn', Churn
FROM assignment.project
WHERE Churn NOT IN ('Yes','No')
UNION ALL
SELECT DISTINCT 'MultipleLines', MultipleLines
FROM assignment.project
WHERE MultipleLines NOT IN ('Yes','No','No phone service')
UNION ALL
SELECT DISTINCT 'InternetService', InternetService
FROM assignment.project
WHERE InternetService NOT IN ('DSL','Fiber optic','No')
UNION ALL
SELECT DISTINCT 'OnlineSecurity', OnlineSecurity
FROM assignment.project
WHERE OnlineSecurity NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'OnlineBackup', OnlineBackup
FROM assignment.project
WHERE OnlineBackup NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'DeviceProtection', DeviceProtection
FROM assignment.project
WHERE DeviceProtection NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'TechSupport', TechSupport
FROM assignment.project
WHERE TechSupport NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'StreamingTV', StreamingTV
FROM assignment.project
WHERE StreamingTV NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'StreamingMovies', StreamingMovies
FROM assignment.project
WHERE StreamingMovies NOT IN ('Yes','No','No internet service')
UNION ALL
SELECT DISTINCT 'Contract', Contract
FROM assignment.project
WHERE Contract NOT IN ('Month-to-month','One year','Two year')
UNION ALL
SELECT DISTINCT 'PaymentMethod', PaymentMethod
FROM assignment.project
WHERE PaymentMethod NOT IN ('Bank transfer (automatic)',
                            'Credit card (automatic)',
                            'Mailed check',
                            'Electronic check');


/**********************************************
 No.2: LOGICAL INCONSISTENCIES
 -- Here the logic is basically If thhe PhoneService = no , then the MultipleLines should be = No phone service
 -- same with Internate service , If the InternetService = No, the all internet-related features should be = No internet service
**********************************************/

SELECT customerID, PhoneService, MultipleLines
FROM assignment.project
WHERE PhoneService = 'No' AND MultipleLines <> 'No phone service';


SELECT customerID, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies
FROM assignment.project
WHERE InternetService = 'No'
  AND (
        OnlineSecurity <> 'No internet service' OR
        OnlineBackup <> 'No internet service' OR
        DeviceProtection <> 'No internet service' OR
        TechSupport <> 'No internet service' OR
        StreamingTV <> 'No internet service' OR
        StreamingMovies <> 'No internet service'
      );


/**********************************************
 No.3: Finding DUPLICATE RECORDS
 -- Here the goal is to find duplicates. As only customer IDs is unique, so we will fetch under CustomerId
**********************************************/

SELECT customerID, COUNT(*) AS duplicate_count
FROM assignment.project
GROUP BY customerID
HAVING COUNT(*) > 1;


/**********************************************
 No.4: Finding the Outlier
 -- Here the goal is the TotalCharges cannot be less than MonthlyCharges.
**********************************************/

SELECT 
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges
FROM assignment.project
WHERE TotalCharges < MonthlyCharges;

/*-----------------------------------------------------------
   Task 2: SQL Analysis & Business Insights
   No.1 : Here the goal is to do Cohort Analysis: Retention by tenure buckets
   ----------------------------------------------------------- */

SELECT 
    CASE                                                     -- Here I'm creating the tenure bucket 
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 36 THEN '25-36 months'
        WHEN tenure BETWEEN 37 AND 48 THEN '37-48 months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
        ELSE '61-72 months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,    -- Count of customers who have churned (Churn = 'Yes')

    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent  -- Churn rate in % = (churned/total) * 100,
FROM assignment.project
GROUP BY tenure_group
ORDER BY tenure_group;

/* Here the tenure_group of 0-12 months showing highest % of churn rate (47.68%), 
followed by 13-24 months 28.71%, 
25-36 months 21.63%
*/

-- No.2 : Here the goal is to find Feature Usage Analysis

SELECT 'InternetService' AS FeatureName,
       InternetService AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY InternetService

UNION ALL

SELECT 'OnlineSecurity' AS FeatureName,
       OnlineSecurity AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY OnlineSecurity

UNION ALL

SELECT 'TechSupport' AS FeatureName,
       TechSupport AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY TechSupport

UNION ALL

SELECT 'StreamingTV' AS FeatureName,
       StreamingTV AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY StreamingTV

UNION ALL

SELECT 'StreamingMovies' AS FeatureName,
       StreamingMovies AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY StreamingMovies

UNION ALL

SELECT 'Contract' AS FeatureName,
       Contract AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY Contract

UNION ALL

SELECT 'PaymentMethod' AS FeatureName,
       PaymentMethod AS FeatureValue,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY PaymentMethod
ORDER BY FeatureName, churn_rate_percent DESC;




-- No.3: Here the Goal is to detect the Churn Analysis by Contract, Payment Method & Senior Citizen
(
SELECT 
    'Contract' AS FeatureName,
    Contract AS FeatureValue,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY Contract
)
UNION ALL
(
SELECT 
    'PaymentMethod' AS FeatureName,
    PaymentMethod AS FeatureValue,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY PaymentMethod
)
UNION ALL
(
SELECT 
    'SeniorCitizen' AS FeatureName,
    CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END AS FeatureValue,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM assignment.project
GROUP BY SeniorCitizen
)
ORDER BY FeatureName, churn_rate_percent DESC;

