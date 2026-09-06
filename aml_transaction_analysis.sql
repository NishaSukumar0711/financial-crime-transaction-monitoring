-- Financial Crime & Transaction Monitoring Analytics
-- PostgreSQL
-- Current version: 19 completed analyses
-- Dataset table: aml

-- ============================================================
-- ANALYSIS 1: TOTAL TRANSACTIONS
-- ============================================================
SELECT COUNT(*)
FROM aml;


-- ============================================================
-- ANALYSIS 2: LAUNDERING-LABELLED TRANSACTION COUNT
-- ============================================================
SELECT COUNT(*)
FROM aml
WHERE is_laundering = TRUE;


-- ============================================================
-- ANALYSIS 3: PERCENTAGE OF LAUNDERING-LABELLED TRANSACTIONS
-- ============================================================
SELECT
    SUM(CASE WHEN is_laundering = TRUE THEN 1 ELSE 0 END) * 100.0
    / COUNT(*) AS laundering_percentage
FROM aml;


-- ============================================================
-- ANALYSIS 4: AVERAGE TRANSACTION AMOUNT BY STATUS
-- ============================================================
SELECT
    is_laundering,
    AVG(amount) AS average_amount
FROM aml
GROUP BY is_laundering;


-- ============================================================
-- ANALYSIS 5: MAXIMUM TRANSACTION AMOUNT BY STATUS
-- ============================================================
SELECT
    is_laundering,
    MAX(amount) AS maximum_amount
FROM aml
GROUP BY is_laundering;


-- ============================================================
-- ANALYSIS 6: LAUNDERING TRANSACTIONS BY PAYMENT TYPE
-- ============================================================
SELECT
    payment_type,
    COUNT(*) AS laundering_transaction_count
FROM aml
WHERE is_laundering = TRUE
GROUP BY payment_type
ORDER BY laundering_transaction_count DESC;


-- ============================================================
-- ANALYSIS 7: RECEIVER BANK LOCATIONS
-- ============================================================
SELECT
    receiver_bank_location,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY receiver_bank_location
ORDER BY total_laundering_transactions DESC;


-- ============================================================
-- ANALYSIS 8: PAYMENT CURRENCY
-- ============================================================
SELECT
    payment_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY payment_currency
ORDER BY total_laundering_transactions DESC;


-- ============================================================
-- ANALYSIS 9: RECEIVED CURRENCY
-- ============================================================
SELECT
    received_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY received_currency
ORDER BY total_laundering_transactions DESC;


-- ============================================================
-- ANALYSIS 10: TOTAL LAUNDERING-LABELLED AMOUNT
-- ============================================================
SELECT
    SUM(
        CASE
            WHEN is_laundering = TRUE THEN amount
            ELSE 0
        END
    ) AS total_laundering_amount
FROM aml;


-- ============================================================
-- ANALYSIS 11: AVERAGE LAUNDERING-LABELLED AMOUNT
-- ============================================================
SELECT
    AVG(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS average_laundering_amount
FROM aml;


-- ============================================================
-- ANALYSIS 12: HIGHEST LAUNDERING-LABELLED AMOUNT
-- ============================================================
SELECT
    MAX(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS highest_laundering_amount
FROM aml;


-- ============================================================
-- ANALYSIS 13: SMALLEST LAUNDERING-LABELLED AMOUNT
-- ============================================================
SELECT
    MIN(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS smallest_laundering_amount
FROM aml;


-- ============================================================
-- ANALYSIS 14: NUMBER OF LAUNDERING-LABELLED TRANSACTIONS
-- ============================================================
SELECT
    COUNT(
        CASE
            WHEN is_laundering = TRUE THEN 1
        END
    ) AS laundering_transaction_count
FROM aml;


-- ============================================================
-- ANALYSIS 15: TOP 10 HIGHEST-VALUE TRANSACTIONS BY STATUS
-- ============================================================
SELECT *
FROM (
    SELECT
        amount,
        is_laundering,
        ROW_NUMBER() OVER (
            PARTITION BY is_laundering
            ORDER BY amount DESC
        ) AS rn
    FROM aml
) x
WHERE rn <= 10;


-- ============================================================
-- ANALYSIS 16: ABOVE-AVERAGE LAUNDERING TRANSACTIONS
-- ============================================================
SELECT
    is_laundering,
    amount
FROM aml
WHERE amount > (
    SELECT AVG(amount)
    FROM aml
    WHERE is_laundering = TRUE
)
AND is_laundering = TRUE;


-- ============================================================
-- ANALYSIS 17: PREVIOUS TRANSACTION AMOUNT BY SENDER
-- ============================================================
SELECT
    sender_account,
    time,
    amount,
    LAG(amount) OVER (
        PARTITION BY sender_account
        ORDER BY time
    ) AS previous_amount
FROM aml;


-- ============================================================
-- ANALYSIS 18: ABOVE-AVERAGE SENDER TOTALS
-- ============================================================
WITH sender_totals AS (
    SELECT
        sender_account,
        SUM(amount) AS total_transaction
    FROM aml
    GROUP BY sender_account
)
SELECT *
FROM sender_totals
WHERE total_transaction > (
    SELECT AVG(total_transaction)
    FROM sender_totals
);


-- ============================================================
-- ANALYSIS 19: CURRENT TRANSACTION > 2X PREVIOUS TRANSACTION
-- ============================================================
WITH previous_amount AS (
    SELECT
        sender_account,
        amount,
        LAG(amount) OVER (
            PARTITION BY sender_account
            ORDER BY time
        ) AS lag_amount
    FROM aml
)
SELECT *
FROM previous_amount
WHERE amount > 2 * lag_amount;
