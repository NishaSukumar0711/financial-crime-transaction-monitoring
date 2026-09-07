# Financial Crime & Transaction Monitoring Analytics Project

## Tools Used

- PostgreSQL

## Project Objective

To analyze financial transactions and identify potential money laundering patterns using transaction monitoring techniques. The project focuses on transaction behaviour, laundering prevalence, transaction values, geographic activity, payment channels, currencies, sender-level activity and behavioural indicators through SQL-based analysis.

## Dataset Overview

- **Total Transactions:** 9,504,852
- **Laundering-Labelled Transactions:** 9,873
- **Dataset Type:** Synthetic AML Transaction Monitoring Dataset
- **Primary Analysis Tool:** PostgreSQL

> **Important:** The dataset is synthetic. The findings describe patterns within the dataset and do not establish that any real person, account, country or transaction is involved in financial crime.

## Analysis

---

## Analysis 1: Total Transactions

### Objective

Establish the total transaction population available for monitoring.

### SQL Query

```sql
SELECT COUNT(*)
FROM aml;
```

### SQL Concepts Used

- COUNT

### Findings

9,504,852 transactions.

### Analysis

The dataset contains over 9.5 million transactions, representing a large-scale transaction monitoring environment. Due to the high transaction volume, automated monitoring and analytical techniques are required to identify suspicious activity efficiently.

### Key Takeaway

The transaction population is large enough that efficient, risk-based monitoring is essential.

---

## Analysis 2: Laundering-Labelled Transaction Count

### Objective

Measure the number of transactions labelled as laundering in the dataset.

### SQL Query

```sql
SELECT COUNT(*)
FROM aml
WHERE is_laundering = 'true';
```

### SQL Concepts Used

- COUNT
- WHERE

### Findings

9,873 laundering-labelled transactions.

### Analysis

Only a small fraction of the overall transaction population is labelled as laundering. This indicates that suspicious-labelled transactions are relatively rare compared with legitimate activity.

### Key Takeaway

Laundering-labelled activity represents a small subset of the overall monitoring population.

---

## Analysis 3: Percentage of Laundering-Labelled Transactions

### Objective

Measure the proportion of the total transaction population labelled as laundering.

### SQL Query

```sql
SELECT
    SUM(CASE WHEN is_laundering = 'true' THEN 1 END) * 100.0 / COUNT(*)
FROM aml;
```

### SQL Concepts Used

- SUM
- CASE
- Conditional Aggregation
- COUNT

### Findings

0.104%.

### Analysis

Laundering-labelled transactions account for approximately 0.104% of all transactions, equivalent to roughly 1 laundering-labelled transaction per 1,000 transactions. This highlights the challenge of identifying suspicious activity within a very large volume of normal transactions.

### Key Takeaway

The rarity of suspicious-labelled activity reinforces the need for targeted monitoring rather than reviewing every transaction manually.

---

## Analysis 4: Average Transaction Amount by Laundering Status

### Objective

Compare the average transaction value between laundering-labelled and non-laundering-labelled transactions.

### SQL Query

```sql
SELECT
    is_laundering,
    AVG(amount)
FROM aml
GROUP BY is_laundering;
```

### SQL Concepts Used

- AVG
- GROUP BY

### Findings

Non-laundering average amount: 8,729.88.  Laundering-labelled average amount: 40,587.67.

### Analysis

Laundering-labelled transactions have an average value approximately 4.65 times greater than non-laundering-labelled transactions. This suggests that transaction value can be a useful risk indicator when combined with other factors.

### Key Takeaway

Average transaction value is a potentially useful indicator for prioritising unusually large or otherwise unusual transactions.

---

## Analysis 5: Maximum Transaction Amount by Laundering Status

### Objective

Compare the maximum transaction value for laundering-labelled and non-laundering-labelled transactions.

### SQL Query

```sql
SELECT
    is_laundering,
    MAX(amount)
FROM aml
GROUP BY is_laundering;
```

### SQL Concepts Used

- MAX
- GROUP BY

### Findings

Non-laundering maximum amount: 999,962.19.  Laundering-labelled maximum amount: 12,618,498.40.

### Analysis

The largest laundering-labelled transaction is significantly higher than the largest non-laundering transaction. The maximum laundering-labelled transaction exceeds 12.6 million, making it more than 12 times larger than the maximum non-laundering transaction.

### Key Takeaway

Extreme transaction values can be useful investigation indicators, although a high-value transaction alone does not prove financial crime.

---

## Analysis 6: Laundering-Labelled Transactions by Payment Type

### Objective

Identify the payment channels with the highest number of laundering-labelled transactions.

### SQL Query

```sql
SELECT
    payment_type,
    COUNT(*)
FROM aml
WHERE is_laundering = 'true'
GROUP BY payment_type
ORDER BY COUNT(*) DESC;
```

### SQL Concepts Used

- WHERE
- GROUP BY
- COUNT
- ORDER BY

### Findings

Cross-border: 2,628; Cash Deposit: 1,405; Cash Withdrawal: 1,334; ACH: 1,159; Credit Card: 1,136; Cheque: 1,087.

### Analysis

Cross-border transactions have the highest number of laundering-labelled transactions in the dataset, followed by Cash Deposit and Cash Withdrawal. This indicates concentration across certain transaction channels.

### Key Takeaway

Payment type can provide useful behavioural context and may help monitoring teams prioritise higher-volume or higher-risk channels for further review.

---

## Analysis 7: Sender Bank Locations with the Highest Number of Laundering-Labelled Transactions

### Objective

Identify sender bank locations associated with the highest number of laundering-labelled transactions and assess geographic concentration.

### SQL Query

```sql
SELECT
    sender_bank_location,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY sender_bank_location
ORDER BY total_laundering_transactions DESC;
```

### SQL Concepts Used

- WHERE
- GROUP BY
- COUNT
- ORDER BY

### Findings

UK: 9,253; Morocco: 55; Italy: 45; Mexico: 44; Germany: 43; India: 42; Netherlands: 41; Switzerland: 41; Austria: 38. Total laundering-labelled transactions: 9,873.

### Analysis

The UK is the dominant sender bank location, accounting for 9,253 of 9,873 laundering-labelled transactions, or approximately 93.7% of the total. The remaining 620 transactions are distributed across other sender bank locations.

### Key Takeaway

This strong concentration is an observation within the synthetic dataset and could warrant further investigation into the related transaction corridors, customer profiles, payment types and counterparties. The result counts transactions; it does not measure the monetary amount of funds sent from the UK.

---

## Analysis 8: Receiver Bank Locations with the Highest Number of Laundering-Labelled Transactions

### Objective

Identify the receiver bank locations with the highest number of laundering-labelled transactions.

### SQL Query

```sql
SELECT
    receiver_bank_location,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY receiver_bank_location
ORDER BY total_laundering_transactions DESC;
```

### SQL Concepts Used

- WHERE
- GROUP BY
- COUNT
- ORDER BY

### Findings

UK: 7,308; Morocco: 253; Nigeria: 251; Albania: 235; Mexico: 197; UAE: 195.

### Analysis

The UK is the most frequent receiver bank location among laundering-labelled transactions, with 7,308 observations. Other locations have substantially lower counts.

### Key Takeaway

Receiver-location concentration can help identify transaction corridors for further review, but geography should be assessed alongside customer, transaction and other risk factors.

---

## Analysis 9: Most Frequently Used Payment Currency in Laundering-Labelled Transactions

### Objective

Identify the payment currencies most frequently associated with laundering-labelled transactions.

### SQL Query

```sql
SELECT
    payment_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY payment_currency
ORDER BY total_laundering_transactions DESC;
```

### SQL Concepts Used

- WHERE
- GROUP BY
- COUNT
- ORDER BY

### Findings

UK Pounds: 8,830; Euro: 260; Moroccan Dirham: 90; Dirham: 89; Swiss Franc: 82; Turkish Lira: 73.

### Analysis

UK Pounds account for the largest number of laundering-labelled transactions by payment currency in the dataset, with 8,830 observations.

### Key Takeaway

Currency concentration provides additional context for transaction flows and can be combined with geography, payment type and customer information during investigation.

---

## Analysis 10: Most Frequently Received Currency in Laundering-Labelled Transactions

### Objective

Identify the received currencies most frequently associated with laundering-labelled transactions.

### SQL Query

```sql
SELECT
    received_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY received_currency
ORDER BY total_laundering_transactions DESC;
```

### SQL Concepts Used

- WHERE
- GROUP BY
- COUNT
- ORDER BY

### Findings

UK Pounds: 6,919, followed by other currencies in substantially lower volumes.

### Analysis

The received-currency analysis complements the payment-currency analysis by showing the currency received in laundering-labelled transactions.

### Key Takeaway

Payment and received currencies together provide a more complete view of the currency patterns and flows within the synthetic dataset.

---

## Analysis 11: Total Amount Involved in Laundering-Labelled Transactions

### Objective

Calculate the total monetary value of transactions labelled as laundering.

### SQL Query

```sql
SELECT
    SUM(
        CASE
            WHEN is_laundering = 'True' THEN amount
            ELSE 0
        END
    ) AS total_laundered_amount
FROM aml;
```

### SQL Concepts Used

- SUM
- CASE
- Conditional Aggregation

### Findings

SQL output was not recorded in the current project draft.

### Analysis

The query calculates the total monetary value associated with laundering-labelled transactions. This metric can help quantify the financial scale represented by the labelled activity.

### Key Takeaway

The total labelled transaction value can provide a useful measure of financial exposure when assessed alongside transaction count and other indicators.

---

## Analysis 12: Average Amount Involved in Laundering-Labelled Transactions

### Objective

Calculate the average transaction amount among laundering-labelled transactions.

### SQL Query

```sql
SELECT
    AVG(
        CASE
            WHEN is_laundering = 'True' THEN amount
        END
    ) AS average_laundering_amount
FROM aml;
```

### SQL Concepts Used

- AVG
- CASE
- Conditional Aggregation

### Findings

40,587.670882586053 (approximately 40,587.67).

### Analysis

The query calculates the average value of transactions flagged as laundering. Transactions significantly above this benchmark may represent a higher-value segment for further investigation.

### Key Takeaway

The average laundering-labelled transaction amount provides a useful benchmark for identifying unusually high-value transactions.

---

## Analysis 13: Highest Amount Involved in Laundering-Labelled Transactions

### Objective

Identify the largest transaction amount among transactions labelled as laundering.

### SQL Query

```sql
SELECT
    MAX(
        CASE
            WHEN is_laundering = 'True' THEN amount
        END
    ) AS highest_laundering_amount
FROM aml;
```

### SQL Concepts Used

- MAX
- CASE
- Conditional Aggregation

### Findings

12,618,498.40.

### Analysis

The query identifies the maximum transaction amount among laundering-labelled transactions. This represents the largest financial exposure observed at the individual-transaction level in the dataset.

### Key Takeaway

Extreme high-value transactions can be prioritised for further review, while recognising that transaction size alone does not establish suspicious activity.

---

## Analysis 14: Smallest Amount Involved in Laundering-Labelled Transactions

### Objective

Identify the smallest transaction amount among transactions labelled as laundering.

### SQL Query

```sql
SELECT
    MIN(
        CASE
            WHEN is_laundering = 'True' THEN amount
        END
    ) AS smallest_laundering_amount
FROM aml;
```

### SQL Concepts Used

- MIN
- CASE
- Conditional Aggregation

### Findings

SQL output was not recorded in the current project draft.

### Analysis

The query identifies the minimum transaction amount among laundering-labelled transactions. This helps demonstrate that suspicious-labelled activity should not be assessed only through large-value transactions.

### Key Takeaway

Lower-value suspicious transactions may also warrant attention when combined with behavioural patterns or other risk indicators.

---

## Analysis 15: Total Number of Laundering-Labelled Transactions

### Objective

Count the total number of transactions labelled as laundering.

### SQL Query

```sql
SELECT
    COUNT(
        CASE
            WHEN is_laundering = 'True' THEN 1
        END
    ) AS laundering_transaction_count
FROM aml;
```

### SQL Concepts Used

- COUNT
- CASE
- Conditional Aggregation

### Findings

9,873.

### Analysis

The query counts the total number of transactions flagged as laundering. When considered alongside the total transaction population, this provides a measure of the prevalence of suspicious-labelled activity.

### Key Takeaway

The count of laundering-labelled transactions provides an overall baseline for analysing the volume and characteristics of suspicious-labelled activity.

---

## Analysis 16: Top 10 Highest-Value Transactions by Laundering Status

### Objective

Identify the ten highest-value transactions within each laundering status.

### SQL Query

```sql
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
```

### SQL Concepts Used

- ROW_NUMBER()
- OVER()
- PARTITION BY
- ORDER BY
- Subquery
- WHERE

### Findings

The query returns 20 transactions in total: the top 10 highest-value transactions for each laundering status.

### Analysis

The analysis compares the highest-value transactions across laundering and non-laundering populations. These transactions can be prioritised for further investigation based on value and other contextual indicators.

### Key Takeaway

Transaction value can be used as one risk indicator, but a high-value transaction alone does not prove money laundering.

---

## Analysis 17: Laundering-Labelled Transactions Above the Average Laundering Amount

### Objective

Identify laundering-labelled transactions with an amount greater than the average laundering-labelled transaction amount.

### SQL Query

```sql
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
```

### SQL Concepts Used

- Scalar Subquery
- AVG
- WHERE

### Findings

The average laundering-labelled transaction amount is approximately 40,587.67.

### Analysis

Transactions above the average laundering-labelled amount represent a higher-value segment within the laundering-labelled population and can be prioritised for additional contextual review.

### Key Takeaway

Above-average transaction value is a useful prioritisation signal when combined with customer, counterparty, geography and behavioural information.

---

## Analysis 18: Previous Transaction Amount by Sender

### Objective

Show each transaction alongside the previous transaction amount for the same sender account.

### SQL Query

```sql
SELECT
    sender_account,
    time,
    amount,
    LAG(amount) OVER (
        PARTITION BY sender_account
        ORDER BY time
    ) AS previous_amount
FROM aml;
```

### SQL Concepts Used

- LAG()
- Window Function
- PARTITION BY
- ORDER BY

### Findings

The query shows each transaction alongside the previous transaction amount for the same sender account.

### Analysis

Comparing a transaction with the sender's previous activity provides context for identifying sudden changes in transaction value.

### Key Takeaway

Sequential transaction analysis can reveal behavioural changes that may warrant further investigation.

---

## Analysis 19: Sender Accounts Above the Average Total Transaction Amount

### Objective

Identify sender accounts whose total transaction amount exceeds the average total transaction amount across all sender accounts.

### SQL Query

```sql
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
```

### SQL Concepts Used

- CTE
- SUM
- GROUP BY
- Scalar Subquery
- AVG

### Findings

The query identifies sender accounts whose aggregate transaction amount is above the average sender total.

### Analysis

Analysing aggregate transaction activity by sender helps identify accounts with unusually high overall transaction values that may warrant further review.

### Key Takeaway

Sender-level aggregation adds an account-level perspective that cannot be obtained by looking at individual transactions alone.

---

## Analysis 20: Transactions More Than Twice the Previous Transaction Amount

### Objective

Identify transactions where the current amount is more than twice the previous transaction amount for the same sender account.

### SQL Query

```sql
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
```

### SQL Concepts Used

- CTE
- LAG()
- Window Function
- PARTITION BY
- ORDER BY
- WHERE

### Findings

The query identifies transactions where the current amount is more than twice the previous transaction amount for the same sender.

### Analysis

A sharp increase in transaction value compared with a sender's previous activity can represent a behavioural red flag for further investigation. The query returned a large number of observations in the synthetic dataset, so the indicator should be combined with additional risk factors rather than treated as proof of suspicious activity.

### Key Takeaway

A sudden increase in transaction value is best treated as a contextual behavioural indicator and not as a standalone conclusion of financial crime.

---

# Project Summary & Key Takeaways

## Project Summary

This project used PostgreSQL to analyze 9,504,852 synthetic financial transactions and identify transaction patterns that may warrant further financial-crime investigation. The analysis covered transaction volumes, laundering-labelled activity, transaction values, payment types, geographic and currency patterns, sender-level behaviour, and changes in transaction amounts over time.

The project demonstrates how SQL-based transaction monitoring can move from a large transaction population to specific risk indicators that can support investigation prioritisation and risk-based monitoring.

## Key Takeaways

- **Laundering-labelled activity was rare:** 9,873 transactions were labelled as laundering, representing approximately **0.104%** of all transactions.
- **Transaction value was a notable differentiator:** the average amount of laundering-labelled transactions was approximately **4.65 times** the average amount of non-laundering-labelled transactions.
- **Extreme transaction values were present:** the maximum laundering-labelled transaction amount was approximately **12.62 million**, compared with approximately **1.00 million** for non-laundering-labelled transactions.
- **Payment-channel concentration was observed:** **Cross-border** transactions had the highest number of laundering-labelled transactions among the payment types analysed.
- **Geographic concentration was observed:** the **UK** was the dominant sender bank location, accounting for **9,253 of 9,873 laundering-labelled transactions (approximately 93.7%)** in the dataset. The UK was also the dominant receiver bank location in the analysis.
- **Currency concentration was observed:** **UK Pounds** accounted for the largest number of laundering-labelled transactions by payment currency.
- **Sender-level activity provides another investigation signal:** analysing total transaction values by sender helps identify accounts with unusually high aggregate activity.
- **Sequential behaviour provides additional context:** transactions that increase sharply compared with the previous transaction for the same sender may represent a behavioural red flag requiring further review.

## Investigator-Oriented Takeaway

The analysis shows that transaction monitoring should not rely on a single indicator. Transaction value, payment type, geography, currency, sender-level activity, and changes in transaction behaviour can be considered together to identify transactions or accounts that may warrant further investigation.

These indicators **do not by themselves prove money laundering or other financial crime**. They are analytical signals that can support a risk-based investigation alongside customer information, transaction context, counterparties, source-of-funds information and other available evidence.
