# Financial Crime & Transaction Monitoring Analytics Project

## Project Overview

This project analyzes a synthetic financial transaction dataset using PostgreSQL to identify patterns and potential risk indicators relevant to financial crime and transaction monitoring.

The analysis focuses on transaction volume, laundering-labelled activity, transaction values, payment channels, geographic activity, currencies, and sender behaviour.

> **Note:** This is a synthetic AML transaction monitoring dataset. "Laundering" refers to the dataset's `is_laundering` label and should not be interpreted as a real-world confirmed finding.

## Tools Used

- PostgreSQL
- SQL

## Dataset Overview

- Total transactions: 9,504,852
- Laundering-labelled transactions: 9,873
- Laundering-labelled transaction rate: approximately 0.104%
- Dataset type: Synthetic AML Transaction Monitoring Dataset
- Primary analysis tool: PostgreSQL

---

# Analysis 1 — Total Transactions

### Business Question
How many transactions exist in the transaction monitoring system?

### SQL
```sql
SELECT COUNT(*)
FROM aml;
```

### Finding
9,504,852 transactions.

### Key Insight
The dataset contains over 9.5 million transactions, representing a large-scale transaction monitoring environment. The high volume demonstrates why automated monitoring and analytical techniques are useful for identifying unusual activity.

---

# Analysis 2 — Laundering-Labelled Transaction Count

### Business Question
How many transactions are identified as laundering transactions?

### SQL
```sql
SELECT COUNT(*)
FROM aml
WHERE is_laundering = TRUE;
```

### Finding
9,873 laundering-labelled transactions.

### Key Insight
Only a small fraction of the overall transaction population is labelled as laundering in the dataset.

---

# Analysis 3 — Percentage of Laundering-Labelled Transactions

### Business Question
What percentage of total transactions are classified as laundering transactions?

### SQL
```sql
SELECT
    SUM(CASE WHEN is_laundering = TRUE THEN 1 ELSE 0 END) * 100.0
    / COUNT(*) AS laundering_percentage
FROM aml;
```

### Finding
Approximately 0.104%.

### Key Insight
Laundering-labelled transactions represent roughly 1 in every 1,000 transactions, illustrating the challenge of identifying a relatively small population within a very large transaction volume.

---

# Analysis 4 — Average Transaction Amount by Laundering Status

### Business Question
Do laundering-labelled transactions have higher transaction values than non-laundering-labelled transactions?

### SQL
```sql
SELECT
    is_laundering,
    AVG(amount) AS average_amount
FROM aml
GROUP BY is_laundering;
```

### Findings

| Status | Average Amount |
|---|---:|
| Non-laundering-labelled | 8,729.88 |
| Laundering-labelled | 40,587.67 |

### Key Insight
Laundering-labelled transactions have an average value approximately 4.65 times higher than non-laundering-labelled transactions in this dataset. Transaction value can therefore be considered as one potential risk indicator, although it should not be used alone to determine suspicious activity.

---

# Analysis 5 — Maximum Transaction Amount by Laundering Status

### Business Question
What is the maximum transaction amount for laundering-labelled vs non-laundering-labelled transactions?

### SQL
```sql
SELECT
    is_laundering,
    MAX(amount) AS maximum_amount
FROM aml
GROUP BY is_laundering;
```

### Findings

| Status | Maximum Amount |
|---|---:|
| Non-laundering-labelled | 999,962.19 |
| Laundering-labelled | 12,618,498.40 |

### Key Insight
The largest laundering-labelled transaction is substantially higher than the largest non-laundering-labelled transaction. Extreme transaction values may therefore be useful as one input into transaction monitoring or investigation prioritisation.

---

# Analysis 6 — Laundering-Labelled Transactions by Payment Type

### Business Question
Which payment types have the highest number of laundering-labelled transactions?

### SQL
```sql
SELECT
    payment_type,
    COUNT(*) AS laundering_transaction_count
FROM aml
WHERE is_laundering = TRUE
GROUP BY payment_type
ORDER BY laundering_transaction_count DESC;
```

### Findings

| Payment Type | Laundering Count |
|---|---:|
| Cross-border | 2,628 |
| Cash Deposit | 1,405 |
| Cash Withdrawal | 1,334 |
| ACH | 1,159 |
| Credit Card | 1,136 |
| Cheque | 1,087 |

### Key Insight
Cross-border transactions have the highest count of laundering-labelled transactions in the dataset, followed by cash deposits and cash withdrawals.

Counts alone do not establish that a payment type is inherently higher risk because transaction volumes by payment type are not included in this comparison. The result is better viewed as a concentration indicator.

---

# Analysis 7 — Receiver Bank Locations with the Highest Number of Laundering-Labelled Transactions

**Status: To be added later.**

This analysis will be inserted here once the sender-bank-location analysis is completed.

---

# Analysis 7 (Current Sequence) — Receiver Bank Locations

### Business Question
Which receiver bank locations receive the highest number of laundering-labelled transactions?

### SQL
```sql
SELECT
    receiver_bank_location,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY receiver_bank_location
ORDER BY total_laundering_transactions DESC;
```

### Findings

| Receiver Bank Location | Laundering Transactions |
|---|---:|
| UK | 7,308 |
| Morocco | 253 |
| Nigeria | 251 |
| Albania | 235 |
| Mexico | 197 |
| UAE | 195 |

*Top results shown.*

### Key Insight
The UK has the highest number of laundering-labelled transactions in the dataset, with a substantial gap between the UK and the other listed locations. In a real-world investigation, concentration in a destination corridor could be used as a trigger for further analysis, but country volume alone does not establish higher inherent risk.

---

# Analysis 8 — Most Frequently Used Payment Currency

### Business Question
Which payment currencies are most frequently used in laundering-labelled transactions?

### SQL
```sql
SELECT
    payment_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY payment_currency
ORDER BY total_laundering_transactions DESC;
```

### Findings

| Payment Currency | Laundering Transactions |
|---|---:|
| UK Pounds | 8,830 |
| Euro | 260 |
| Moroccan Dirham | 90 |
| Dirham | 89 |
| Swiss Franc | 82 |
| Turkish Lira | 73 |

*Top results shown.*

### Key Insight
UK Pounds account for the majority of laundering-labelled transactions in the dataset. Currency concentration can be used as one dimension of transaction monitoring, particularly when combined with transaction type and geographic information.

---

# Analysis 9 — Most Frequently Received Currency

### Business Question
Which received currencies are most frequently observed in laundering-labelled transactions?

### SQL
```sql
SELECT
    received_currency,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY received_currency
ORDER BY total_laundering_transactions DESC;
```

### Findings

| Received Currency | Laundering Transactions |
|---|---:|
| UK Pounds | 6,919 |
| Euro | 716 |
| Naira | 288 |
| Moroccan Dirham | 285 |
| Albanian Lek | 262 |
| Mexican Peso | 235 |

*Top results shown.*

### Key Insight
UK Pounds are the most frequently received currency, followed by Euro and several other currencies. Comparing payment and received currency at transaction level would provide a stronger basis for identifying cross-currency movement than simple aggregate counts.

---

# Analysis 10 — Total Amount Involved in Laundering-Labelled Transactions

### Business Question
What is the total amount involved in laundering-labelled transactions?

### SQL
```sql
SELECT
    SUM(
        CASE
            WHEN is_laundering = TRUE THEN amount
            ELSE 0
        END
    ) AS total_laundering_amount
FROM aml;
```

### Result
The original project notes did not capture the SQL output for this question. The query is retained so the result can be rerun directly in PostgreSQL.

### Key Insight
The total amount provides a measure of the aggregate monetary value associated with the laundering-labelled population in the dataset.

---

# Analysis 11 — Average Amount Involved in Laundering-Labelled Transactions

### Business Question
What is the average amount involved in laundering-labelled transactions?

### SQL
```sql
SELECT
    AVG(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS average_laundering_amount
FROM aml;
```

### Finding
40,587.67.

### Key Insight
The average laundering-labelled transaction amount provides a benchmark against which unusually large laundering-labelled transactions can be compared.

---

# Analysis 12 — Highest Amount Involved in Laundering-Labelled Transactions

### Business Question
What is the highest amount involved in laundering-labelled transactions?

### SQL
```sql
SELECT
    MAX(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS highest_laundering_amount
FROM aml;
```

### Finding
12,618,498.40.

### Key Insight
The highest-value laundering-labelled transaction represents a significant outlier in transaction value and can be prioritised for further investigation in a real monitoring environment.

---

# Analysis 13 — Smallest Amount Involved in Laundering-Labelled Transactions

### Business Question
What is the smallest amount involved in laundering-labelled transactions?

### SQL
```sql
SELECT
    MIN(
        CASE
            WHEN is_laundering = TRUE THEN amount
        END
    ) AS smallest_laundering_amount
FROM aml;
```

### Result
The original project notes did not capture the SQL output for this question. The query is retained so the result can be rerun directly in PostgreSQL.

### Key Insight
Laundering-labelled activity is not necessarily limited to large transactions. Transaction size should therefore be considered alongside behavioural, geographic, payment-type, and account-level indicators.

---

# Analysis 14 — Number of Laundering-Labelled Transactions

### Business Question
How many laundering-labelled transactions are there?

### SQL
```sql
SELECT
    COUNT(
        CASE
            WHEN is_laundering = TRUE THEN 1
        END
    ) AS laundering_transaction_count
FROM aml;
```

### Finding
9,873.

### Key Insight
The number of laundering-labelled transactions provides an overall measure of suspicious activity within the dataset and can be used alongside value-based measures to understand the scale and characteristics of the flagged population.

---

# Analysis 15 — Top 10 Highest-Value Transactions by Laundering Status

### Business Question
What are the top 10 highest-value transactions for each laundering status?

### SQL
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

### Finding
The query returns the top 10 highest-value transactions for each laundering status, giving 20 transactions in total.

### Key Insight
Transaction value can be used as one risk indicator, but a high-value transaction alone does not prove money laundering.

### SQL Concepts
- ROW_NUMBER()
- OVER()
- PARTITION BY
- ORDER BY
- Subquery
- WHERE

---

# Analysis 16 — Laundering Transactions Above the Average Laundering Amount

### Business Question
Which laundering-labelled transactions have an amount greater than the average laundering-labelled transaction amount?

### SQL
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

### Finding
The average laundering-labelled transaction amount is approximately 40,587.67.

### Key Insight
Transactions above the average laundering-labelled amount can be treated as a higher-value segment for further investigation.

---

# Analysis 17 — Previous Transaction Amount by Sender

### Business Question
For each sender account, show each transaction amount along with the amount of that sender's previous transaction.

### SQL
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

### Finding
Each transaction is shown alongside the previous transaction amount for the same sender account.

### Key Insight
Comparing sequential transactions can help identify sudden changes in transaction values that may warrant further investigation.

### SQL Concepts
- LAG()
- Window functions
- PARTITION BY
- ORDER BY

---

# Analysis 18 — Sender Accounts with Above-Average Total Transaction Amount

### Business Question
Which sender accounts have a total transaction amount greater than the average total transaction amount across all sender accounts?

### SQL
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

### Finding
The query identifies sender accounts whose total transaction amount is higher than the average total transaction amount across all sender accounts.

### Key Insight
Looking at total transaction activity by sender can help identify accounts with unusually high overall activity that may warrant further investigation.

### SQL Concepts
- CTE
- GROUP BY
- SUM()
- AVG()
- Scalar subquery

---

# Analysis 19 — Transactions More Than Twice the Previous Transaction Amount

### Business Question
Which transactions are more than twice the previous transaction amount for the same sender account?

### SQL
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

### Finding
The query identifies transactions where the current transaction amount is more than twice the previous transaction amount for the same sender.

### Key Insight
A sudden increase in transaction value compared with a sender's previous activity can be treated as a potential behavioural red flag for further investigation.

---

# Overall Project Takeaways

1. The dataset contains over 9.5 million transactions.
2. Only approximately 0.104% of transactions are labelled as laundering.
3. Laundering-labelled transactions have a substantially higher average transaction amount than non-laundering-labelled transactions in this dataset.
4. The highest laundering-labelled transaction is substantially larger than the highest non-laundering-labelled transaction.
5. Cross-border transactions have the highest count of laundering-labelled transactions among the payment types shown.
6. Receiver-location and currency analysis show strong concentration in particular categories within this synthetic dataset.
7. Sender-level aggregation and sequential transaction analysis introduce behavioural indicators that can be used to prioritise transactions or accounts for further review.
8. No single indicator should be treated as proof of financial crime. In a real AML environment, transaction monitoring combines multiple indicators with customer context, historical behaviour, counterparties, geography, and investigative evidence.

---

## Project Status

**Current version:** 19 completed SQL analyses.

**Planned next update:** Add the missing sender bank location analysis and integrate it as the next question, then renumber the project if required.

**Power BI:** Not included in this version. It can be added later as a separate enhancement.
