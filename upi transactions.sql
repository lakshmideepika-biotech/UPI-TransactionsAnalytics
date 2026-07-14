USE UPITransactions;
GO

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'transactions';


USE UPITransactions;
GO

SELECT COUNT(*) AS total_rows FROM transactions;

SELECT Transaction_ID, COUNT(*) AS cnt
FROM transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

SELECT 
    SUM(CASE WHEN Amount_INR IS NULL THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN User_ID IS NULL THEN 1 ELSE 0 END) AS missing_user,
    SUM(CASE WHEN Payment_App IS NULL THEN 1 ELSE 0 END) AS missing_app
FROM transactions;

SELECT 
    Payment_Status,
    COUNT(*) AS txn_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM transactions
GROUP BY Payment_Status
ORDER BY txn_count DESC;

SELECT 
    DATEPART(HOUR, Time) AS hour_of_day,
    COUNT(*) AS total_txns,
    SUM(CASE WHEN Payment_Status = 'Failed' THEN 1 ELSE 0 END) AS failed_txns,
    ROUND(SUM(CASE WHEN Payment_Status = 'Failed' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 1) AS failure_rate_pct
FROM transactions
GROUP BY DATEPART(HOUR, Time)
ORDER BY hour_of_day;

SELECT 
    SUM(Amount_INR) AS total_amount,
    AVG(Amount_INR) AS avg_amount,
    COUNT(*) AS total_transactions
FROM transactions
WHERE Payment_Status = 'Success';

SELECT TOP 10
    Sender_Bank,
    COUNT(*) AS txn_count,
    SUM(Amount_INR) AS total_amount
FROM transactions
WHERE Payment_Status = 'Success'
GROUP BY Sender_Bank
ORDER BY txn_count DESC;

SELECT 
    Payment_App,
    COUNT(*) AS txn_count,
    SUM(Amount_INR) AS total_amount
FROM transactions
WHERE Payment_Status = 'Success'
GROUP BY Payment_App
ORDER BY txn_count DESC;

SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    COUNT(*) AS txn_count,
    SUM(Amount_INR) AS total_amount
FROM transactions
WHERE Payment_Status = 'Success'
GROUP BY FORMAT(Date, 'yyyy-MM')
ORDER BY month;

SELECT TOP 10
    Merchant_Category,
    COUNT(*) AS txn_count,
    SUM(Amount_INR) AS total_amount
FROM transactions
WHERE Payment_Status = 'Success' AND Transaction_Type = 'P2M'
GROUP BY Merchant_Category
ORDER BY txn_count DESC;