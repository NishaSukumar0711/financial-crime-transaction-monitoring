Financial Crime & Transaction Monitoring Analytics Project

Tools Used

-   PostgreSQL

**Project Objective**

To analyze financial transactions and identify potential money
laundering patterns using transaction monitoring techniques. The project
focuses on understanding transaction behavior, laundering prevalence,
transaction values, geographic activity, and risk indicators through
SQL-based analysis.

**Dataset Overview**

Total Transactions: 9,504,852

Laundering Transactions: 9,873

Dataset Type: Synthetic AML Transaction Monitoring Dataset

Primary Analysis Tool: PostgreSQL

------------------------------------------------------------------------

**ANALYSIS 1: TOTAL TRANSACTIONS**

Business Question

How many transactions exist in the transaction monitoring system?

SQL Query

select count(\*)

from aml;

Finding

9,504,852 transactions

Interpretation

The dataset contains over 9.5 million transactions, representing a
large-scale transaction monitoring environment. Due to the high
transaction volume, automated monitoring and analytical techniques are
required to identify suspicious activity efficiently.

------------------------------------------------------------------------

**ANALYSIS 2: LAUNDERING TRANSACTION COUNT**

Business Question

How many transactions are identified as laundering transactions?

SQL Query

select count(\*)

from aml

where is_laundering = 'true';

Finding

9,873 laundering transactions

Interpretation

Only a small fraction of the overall transaction population has been
identified as laundering activity. This indicates that suspicious
transactions are relatively rare compared to legitimate activity.

------------------------------------------------------------------------

**ANALYSIS 3: PERCENTAGE OF LAUNDERING TRANSACTIONS**

Business Question

What percentage of total transactions are classified as laundering
transactions?

SQL Query

select

sum(case when is_laundering = 'true' then 1 end) *100.0* * /count(*)
from aml;

Finding

0.104%

Interpretation

Laundering transactions account for approximately 0.104% of all
transactions, equivalent to roughly 1 laundering transaction per 1,000
transactions. This highlights the challenge faced by AML monitoring
teams in identifying suspicious activity within a large volume of normal
transactions.

------------------------------------------------------------------------

**ANALYSIS 4: AVERAGE TRANSACTION AMOUNT BY LAUNDERING STATUS**

Business Question

Do laundering transactions have higher transaction values than
non-laundering transactions?

SQL Query

Select is_laundering,avg(amount)

from aml

group by is_laundering;

Finding'

Non-Laundering Average Amount: 8,729.88

Laundering Average Amount: 40,587.67

Interpretation

Laundering transactions have an average value approximately 4.65 times
greater than non-laundering transactions. This suggests that laundering
activity is concentrated in higher-value transactions and may warrant
enhanced monitoring of unusually large payments.

------------------------------------------------------------------------

KEY INSIGHTS SO FAR

1.  The monitoring environment contains over 9.5 million transactions.
2.  Only 0.104% of transactions are laundering-related.
3.  Laundering transactions average 40,587.67 compared to 8,729.88 for
    normal transactions.
4.  Laundering transactions are approximately 4.65 times larger than
    normal transactions on average.
5.  Transaction amount appears to be a potentially useful risk indicator
    for monitoring suspicious activity.

------------------------------------------------------------------------

ANALYSIS 5: MAXIMUM TRANSACTION AMOUNT BY LAUNDERING STATUS

Business Question

What is the maximum transaction amount for laundering vs non-laundering
transactions?

SQL Query

select

is_laundering,

max(amount)

from aml

group by is_laundering;

Finding

Non-Laundering Maximum Amount: 999,962.19

Laundering Maximum Amount: 12,618,498.40

Interpretation

The largest laundering transaction is significantly higher than the
largest non-laundering transaction.

While the maximum legitimate transaction is approximately 1 million, the
maximum laundering transaction exceeds 12.6 million, making it more than
12 times larger.

This indicates that laundering activity in the dataset is associated not
only with higher average transaction values but also with extreme
high-value transactions.

Key Insight

Transaction amount appears to be a strong risk indicator within the
dataset. Laundering transactions are characterized by both higher
average values and substantially larger maximum transaction amounts
compared to normal transactions.

------------------------------------------------------------------------

PROJECT INSIGHTS AFTER ANALYSIS 5

1.  The dataset contains 9.5 million transactions, representing a
    large-scale transaction monitoring environment.
2.  Laundering transactions account for only 0.104% of all transactions,
    making suspicious activity relatively rare.
3.  The average laundering transaction amount (40,588) is approximately
    4.65 times greater than the average non-laundering transaction
    amount (8,730).
4.  The maximum laundering transaction amount (12.6 million) is more
    than 12 times greater than the maximum non-laundering transaction
    amount (1 million).
5.  Transaction amount appears to be a meaningful indicator of
    laundering risk and should be considered when designing monitoring
    rules.

------------------------------------------------------------------------

ANALYSIS 6: LAUNDERING TRANSACTIONS BY PAYMENT TYPE

Business Question

Which payment types have the highest number of laundering transactions?

SQL Query

select

payment_type,

count(\*)

from aml

where is_laundering = 'true'

group by payment_type;

Finding

  **Payment Type** **Laundering Count**   
  --------------------------------------- ------
  Cross-border                            2628
  Cash Deposit                            1405
  Cash Withdrawal                         1334
  ACH                                     1159
  Credit Card                             1136
  Cheque                                  1087

Interpretation

Cross-border transactions have the highest number of laundering cases in
the dataset, with 2,628 identified laundering transactions. Cash
Deposits and Cash Withdrawals also contribute significantly to
laundering activity.

This suggests that certain transaction channels may be more vulnerable
to misuse and could warrant enhanced monitoring and investigation
procedures.

Highlights

• Cross-border transactions account for the highest number of laundering
cases.

• Cash-based transactions (Cash Deposits and Cash Withdrawals) also show
a significant concentration of laundering activity.

• Payment type appears to be a useful behavioral indicator when
designing AML monitoring rules.

• Transaction monitoring programs may benefit from applying enhanced
scrutiny to higher-risk payment channels.

  ------------------------------------------------------------------------------
  **Analysis**                                          
  **Business                                            
  Question**                                            
  **Finding** **Key                                     
  Insight**                                             
  ------------------- ------------------ -------------- ------------------------
  1                   How many           9,504,852      Large-scale transaction
                      transactions       transactions   monitoring environment
                      exist?                            requiring automated
                                                        monitoring.

  2                   How many           9,873          Laundering activity is
                      laundering         transactions   relatively rare compared
                      transactions                      to overall transaction
                      exist?                            volume.

  3                   What percentage of 0.104%         Approximately 1 out of
                      transactions are                  every 1,000 transactions
                      laundering?                       is laundering-related.

  4                   Do laundering      40,588 vs      Laundering transactions
                      transactions have  8,730          are approximately 4.65x
                      higher average                    larger on average.
                      amounts?                          

  5                   What is the        12.6M vs 1.0M  Largest laundering
                      maximum                           transaction is over 12x
                      transaction amount                larger than largest
                      by laundering                     normal transaction.
                      status?                           

  6                   Which payment      Cross-border   Certain payment channels
                      types have the     (2,628)        appear more vulnerable
                      highest laundering highest        to laundering activity.
                      counts?                           

  7                   Which sender bank  UK (9,253)     Laundering-labelled
                      locations have the highest        transaction activity is
                      highest laundering                strongly concentrated in
                      counts?                           UK sender bank
                                                        locations.
  ------------------------------------------------------------------------------

## Analysis 7 -- Sender Bank Locations with the Highest Number of Laundering Transactions

### Business Question

Which sender bank locations have the highest number of laundering
transactions?

------------------------------------------------------------------------

### Objective

Identify the sender bank locations associated with the highest number of
laundering-labelled transactions and assess whether the dataset shows
geographic concentration in transaction activity.

------------------------------------------------------------------------

### SQL Query

``` sql
SELECT
    sender_bank_location,
    COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY sender_bank_location
ORDER BY COUNT(*) DESC;
```

------------------------------------------------------------------------

### SQL Concepts Used

-   SELECT
-   WHERE
-   GROUP BY
-   COUNT()
-   ORDER BY

------------------------------------------------------------------------

### Findings

  Sender Bank Location   Laundering Transactions
  ---------------------- -------------------------
  UK                     9,253
  Morocco                55
  Italy                  45
  Mexico                 44
  Germany                43
  India                  42
  Netherlands            41
  Switzerland            41
  Austria                38

*(Top results shown.)*

------------------------------------------------------------------------

### Analysis

-   The UK was the dominant sender bank location, with **9,253**
    laundering-labelled transactions.
-   The dataset contains **9,873** laundering-labelled transactions in
    total, meaning approximately **93.7%** were associated with a UK
    sender bank location.
-   The remaining laundering-labelled transactions were distributed
    across other sender bank locations, with Morocco, Italy, Mexico,
    Germany and India among the next highest locations.
-   This indicates a strong geographic concentration of
    laundering-labelled transaction activity associated with UK sender
    bank locations within the synthetic dataset.

------------------------------------------------------------------------

### Business Insights

-   Geographic concentration can be used as one factor when prioritizing
    transaction monitoring and investigation.
-   Sender-location analysis can be combined with receiver location,
    payment type, transaction amount and sender-account activity to
    identify potentially significant transaction patterns.
-   A geographic concentration alone does not prove money laundering and
    should be assessed alongside other risk indicators and supporting
    evidence.
-   Further investigation could examine the transaction corridors,
    accounts, payment types and values associated with UK sender bank
    locations.

------------------------------------------------------------------------

### Key Takeaway

Sender bank location analysis shows a strong concentration of
laundering-labelled transaction activity associated with UK sender bank
locations in this synthetic dataset. Combining sender and receiver
location analysis can provide a more complete view of transaction flows
and help identify patterns that may warrant further investigation.

------------------------------------------------------------------------

## Analysis 8 -- Receiver Bank Locations with the Highest Number of Laundering Transactions

### Business Question

Which receiver bank locations receive the highest number of laundering
transactions?

------------------------------------------------------------------------

### Objective

Identify the destination countries that receive the highest number of
suspicious (money laundering) transactions. This helps determine whether
laundering activity is concentrated in specific receiver locations.

------------------------------------------------------------------------

### SQL Query

``` sql
SELECT receiver_bank_location,
       COUNT(*) AS total_laundering_transactions
FROM aml
WHERE is_laundering = TRUE
GROUP BY receiver_bank_location
ORDER BY COUNT(*) DESC;
```

------------------------------------------------------------------------

### SQL Concepts Used

-   SELECT

-   WHERE

-   GROUP BY

-   COUNT()

-   ORDER BY

------------------------------------------------------------------------

### Findings

  Receiver Bank Location Laundering Transactions   
  ------------------------------------------------ -------
  UK                                               7,308
  Morocco                                          253
  Nigeria                                          251
  Albania                                          235
  Mexico                                           197
  UAE                                              195

*(Top results shown.)*

------------------------------------------------------------------------

### Analysis

-   The United Kingdom (UK) received **7,308** laundering transactions,
    making it the most common destination in the dataset.

-   After the UK, the number of laundering transactions decreases
    significantly, with Morocco, Nigeria, Albania, Mexico, and UAE
    receiving substantially fewer suspicious transactions.

-   The large difference between the UK and all other locations
    indicates that suspicious transaction flows are highly concentrated
    toward a single destination in this synthetic dataset.

-   Such concentration may represent a high-risk corridor that would
    require additional monitoring in a real-world AML environment.

------------------------------------------------------------------------

### Business Insights

-   Countries receiving a high volume of suspicious transactions should
    be prioritized for enhanced transaction monitoring.

-   AML investigators can use destination-country analysis to identify
    emerging laundering patterns and potential high-risk jurisdictions.

-   Combining sender and receiver location analysis provides a more
    complete understanding of transaction flows and helps identify
    frequently used laundering routes.

-   These insights can support risk-based monitoring, investigation
    prioritization, and compliance reporting.

------------------------------------------------------------------------

### Key Takeaway

Receiver bank location analysis helps identify where suspicious funds
are ultimately transferred. Monitoring destination countries enables
financial institutions to detect high-risk transaction patterns and
strengthen their Anti-Money Laundering (AML) controls.

## Analysis 9 -- Most Frequently Used Payment Currency in Laundering Transactions

### Business Question

Which payment currencies are most frequently used in money laundering
transactions?

------------------------------------------------------------------------

### Objective

Identify the payment currencies most commonly used in suspicious
transactions. Understanding the distribution of payment currencies helps
identify whether laundering activity is concentrated around specific
currencies and supports transaction monitoring strategies.

------------------------------------------------------------------------

### SQL Query

SELECT payment_currency,

COUNT(*) AS total_laundering_transactions* * FROM aml* * WHERE
is_laundering = TRUE* * GROUP BY payment_currency* * ORDER BY COUNT(*)
DESC;

------------------------------------------------------------------------

### SQL Concepts Used

-   SELECT
-   WHERE
-   GROUP BY
-   COUNT()
-   ORDER BY

------------------------------------------------------------------------

### Findings

  Payment Currency Laundering Transactions   
  ------------------------------------------ -------
  UK Pounds                                  8,830
  Euro                                       260
  Moroccan Dirham                            90
  Dirham                                     89
  Swiss Franc                                82
  Turkish Lira                               73

*(Top results shown.)*

------------------------------------------------------------------------

### Analysis

-   UK Pounds account for the vast majority of laundering transactions
    in the dataset, with 8,830 suspicious transactions.
-   Other currencies such as Euro, Moroccan Dirham, Dirham, Swiss Franc,
    and Turkish Lira appear much less frequently.
-   The sharp difference in transaction counts indicates that laundering
    activity is heavily concentrated in one payment currency within this
    synthetic dataset.
-   Monitoring payment currency trends can help identify unusual
    transaction behavior and improve AML surveillance.

------------------------------------------------------------------------

### Business Insights

-   Payment currency is an important indicator in transaction monitoring
    systems.
-   A disproportionately high number of suspicious transactions in a
    particular currency may warrant enhanced monitoring and
    investigation.
-   Currency analysis can be combined with payment type, sender
    location, and receiver location to build more comprehensive risk
    profiles.
-   These findings can support the development of risk-based AML
    controls and transaction monitoring rules.

------------------------------------------------------------------------

### Key Takeaway

Analyzing payment currencies helps identify which currencies are most
frequently associated with suspicious transactions. This information
enables financial institutions to strengthen monitoring, prioritize
investigations, and better understand money laundering patterns.

## Analysis 10 -- Most Frequently Received Currency in Laundering Transactions

### Business Question

Which received currencies are most frequently observed in money
laundering transactions?

------------------------------------------------------------------------

### Objective

Identify the currencies that recipients receive most often in suspicious
transactions. This analysis helps determine whether laundering activity
is concentrated in specific destination currencies and provides
additional insight into money movement patterns.

------------------------------------------------------------------------

### SQL Query

SELECT received_currency,

COUNT(*) AS total_laundering_transactions* * FROM aml* * WHERE
is_laundering = TRUE* * GROUP BY received_currency* * ORDER BY COUNT(*)
DESC;

------------------------------------------------------------------------

### SQL Concepts Used

-   SELECT
-   WHERE
-   GROUP BY
-   COUNT()
-   ORDER BY

------------------------------------------------------------------------

### Findings

  Received Currency Laundering Transactions   
  ------------------------------------------- -------
  UK Pounds                                   6,919
  Euro                                        716
  Naira                                       288
  Moroccan Dirham                             285
  Albanian Lek                                262
  Mexican Peso                                235

*(Top results shown.)*

------------------------------------------------------------------------

### Analysis

-   UK Pounds are the most frequently received currency in laundering
    transactions, accounting for 6,919 suspicious transactions.
-   Euro is the second most common received currency, followed by Naira,
    Moroccan Dirham, Albanian Lek, and Mexican Peso.
-   Compared with the payment currency analysis, the received currency
    distribution is more diversified, suggesting that suspicious
    transactions may involve currency conversion before reaching the
    recipient.
-   Examining both payment and received currencies provides a better
    understanding of the flow of funds and potential currency conversion
    patterns used in laundering schemes.

------------------------------------------------------------------------

### Business Insights

-   Monitoring received currencies helps identify the currencies that
    ultimately receive suspicious funds.
-   Comparing payment currency with received currency can reveal
    cross-currency transactions that may require additional
    investigation.
-   Currency flow analysis strengthens transaction monitoring by
    highlighting potential foreign exchange patterns associated with
    money laundering.
-   These insights can support AML investigators in identifying
    high-risk currency corridors and enhancing risk-based monitoring.

------------------------------------------------------------------------

### Key Takeaway

Received currency analysis complements payment currency analysis by
showing the final currency received in suspicious transactions.
Together, these analyses provide a more complete understanding of how
illicit funds move through the financial system.

# AML SQL Project

------------------------------------------------------------------------

# Question 11

## Business Question

What is the total amount involved in money laundering transactions?

## Objective

Calculate the total monetary value of all transactions identified as
money laundering.

## SQL Concept Used

-   Conditional Aggregation
-   SUM(CASE)

## SQL Query

``` sql
SELECT
SUM(
    CASE
        WHEN is_laundering = 'True' THEN amount
        ELSE 0
    END
) AS total_laundered_amount
FROM aml;
```

## Output

  total_laundered_amount
  -------------------------
  (Paste your SQL result)

## Analysis

The query calculates the total monetary value of all transactions
identified as money laundering activities.

## Business Insight

The total laundered amount represents the overall financial exposure
associated with suspicious transactions. This metric helps investigators
understand the scale of financial crime within the dataset and serves as
a key indicator for monitoring laundering trends over time.

------------------------------------------------------------------------

# Question 12

## Business Question

What is the average amount involved in money laundering transactions?

## Objective

Calculate the average transaction amount of all money laundering
transactions.

## SQL Concept Used

-   Conditional Aggregation
-   AVG(CASE)

## SQL Query

``` sql
SELECT
AVG(
    CASE
        WHEN is_laundering = 'True' THEN amount
    END
) AS average_laundering_amount
FROM aml;
```

## Output

  average_laundering_amount
  ---------------------------
  40587.670882586053

## Analysis

The query calculates the average value of transactions flagged as money
laundering.

## Business Insight

The average laundering transaction amount provides a benchmark for
typical suspicious transactions. Transactions significantly above this
average may require additional investigation as they could indicate
higher-risk financial activity.

------------------------------------------------------------------------

# Question 13

## Business Question

What is the highest amount involved in money laundering transactions?

## Objective

Identify the largest money laundering transaction recorded in the
dataset.

## SQL Concept Used

-   Conditional Aggregation
-   MAX(CASE)

## SQL Query

``` sql
SELECT
MAX(
    CASE
        WHEN is_laundering = 'True' THEN amount
    END
) AS highest_laundering_amount
FROM aml;
```

## Output

  highest_laundering_amount
  ---------------------------
  (Paste your SQL result)

## Analysis

The query identifies the maximum transaction amount among all
transactions flagged as money laundering.

## Business Insight

The highest laundering transaction highlights the largest financial
exposure in the dataset. Such high-value transactions are often
considered high priority during investigations due to their potential
financial and regulatory impact.

------------------------------------------------------------------------

# Question 14

## Business Question

What is the smallest amount involved in money laundering transactions?

## Objective

Identify the smallest money laundering transaction recorded in the
dataset.

## SQL Concept Used

-   Conditional Aggregation
-   MIN(CASE)

## SQL Query

``` sql
SELECT
MIN(
    CASE
        WHEN is_laundering = 'True' THEN amount
    END
) AS smallest_laundering_amount
FROM aml;
```

## Output

  smallest_laundering_amount
  ----------------------------
  (Paste your SQL result)

## Analysis

The query identifies the minimum transaction amount among all money
laundering transactions.

## Business Insight

Money laundering is not always associated with large transactions.
Smaller suspicious transactions may indicate structuring (smurfing),
where criminals divide large amounts into multiple smaller transactions
to reduce the likelihood of detection.

------------------------------------------------------------------------

# Question 15

## Business Question

How many money laundering transactions are there?

## Objective

Count the total number of money laundering transactions.

## SQL Concept Used

-   Conditional Aggregation
-   COUNT(CASE)

## SQL Query

``` sql
SELECT
COUNT(
    CASE
        WHEN is_laundering = 'True' THEN 1
    END
) AS laundering_transaction_count
FROM aml;
```

## Output

  laundering_transaction_count
  ------------------------------

## Analysis

The query counts the total number of transactions flagged as money
laundering.

## Business Insight

The total number of laundering transactions provides an overall measure
of suspicious activity within the dataset. When analyzed alongside the
total, average, maximum, and minimum laundering amounts, it offers a
comprehensive view of the volume and characteristics of suspicious
financial activity.

Q16. Top 10 Highest-Value Transactions by Laundering Status

Business Question:

What are the top 10 highest-value transactions for each laundering
status?

SQL:

SELECT \*

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

WHERE rn \<= 10;

Finding:

The query returns the top 10 highest-value laundering and non-laundering
transactions, giving 20 transactions in total.

Analysis:

Laundering transactions can be compared with non-laundering transactions
based on transaction value. The highest-value transactions can be
prioritised for further investigation.

Key Insight:

Transaction value can be used as one risk indicator, but a high-value
transaction alone does not prove money laundering.

SQL Concepts:

ROW_NUMBER()

OVER()

PARTITION BY

ORDER BY

Subquery

WHERE

# AML SQL Project --- Question 17

## Business Question

Which laundering transactions have an amount greater than the average
laundering transaction amount?

## SQL Concept

Scalar Subquery

## SQL Query

SELECT

is_laundering,

amount

FROM aml

WHERE amount \> (

SELECT AVG(amount)

FROM aml

WHERE is_laundering = TRUE

)

AND is_laundering = TRUE;

## Finding

The average laundering transaction amount is approximately 40,587.67.

## Key Insight

Transactions above the average laundering amount can be considered a
higher-value segment for further investigation.

# AML SQL Project --- Question 18

## Business Question

For each sender account, show each transaction amount along with the
amount of that sender's previous transaction.

## SQL Concept

LAG() Window Function

## SQL Query

SELECT

sender_account,

time,

amount,

LAG(amount) OVER (

PARTITION BY sender_account

ORDER BY time

) AS previous_amount

FROM aml;

## Finding

The query shows each transaction alongside the previous transaction
amount for the same sender account.

## Key Insight

Comparing current and previous transactions can help identify sudden
changes in transaction values that may warrant further investigation.

# AML SQL Project --- Question 19

## Business Question

Which sender accounts have a total transaction amount greater than the
average total transaction amount across all sender accounts?

## SQL Concept

CTE (Common Table Expression)

## SQL Query

WITH sender_totals AS (

SELECT

sender_account,

SUM(amount) AS total_transaction

FROM aml

GROUP BY sender_account

)

SELECT \*

FROM sender_totals

WHERE total_transaction \> (

SELECT AVG(total_transaction)

FROM sender_totals

);

## Finding

The query identifies sender accounts whose total transaction amount is
higher than the average total transaction amount across all sender
accounts.

## Key Insight

Looking at total transaction activity by sender helps identify accounts
with unusually high overall transaction volumes that may warrant further
investigation.

# AML SQL Project --- Question 20

## Business Question

Which transactions are more than twice the previous transaction amount
for the same sender account?

## SQL Concepts

LAG() Window Function

CTE (Common Table Expression)

PARTITION BY

ORDER BY

## SQL Query

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

SELECT * FROM previous_amount* * WHERE amount \> 2* lag_amount;

## Finding

The query identifies transactions where the current transaction amount
is more than twice the previous transaction amount for the same sender.

## Key Insight

A sudden increase in transaction value compared with a sender's previous
activity can be treated as a potential behavioural red flag for further
investigation.

# Project Summary & Key Takeaways

## Project Summary

This project used PostgreSQL to analyze 9,504,852 synthetic financial transactions and identify transaction patterns that may warrant further financial-crime investigation. The analysis covered transaction volumes, laundering-labelled activity, transaction values, payment types, geographic and currency patterns, sender-level behaviour, and changes in transaction amounts over time.

The project demonstrates how SQL-based transaction monitoring can be used to move from a large transaction population to specific risk indicators that can support investigation and risk-based monitoring.

## Key Takeaways

- **Laundering-labelled activity was a very small proportion of the dataset:** 9,873 transactions were labelled as laundering, representing approximately **0.104%** of all transactions.
- **Transaction value was a notable differentiator:** the average amount of laundering-labelled transactions was approximately **4.65 times** the average amount of non-laundering-labelled transactions.
- **Extreme transaction values were present:** the maximum laundering-labelled transaction amount was approximately **12.62 million**, compared with approximately **1.00 million** for non-laundering-labelled transactions.
- **Payment-channel concentration was observed:** **Cross-border** transactions had the highest number of laundering-labelled transactions among the payment types analysed.
- **Geographic concentration was observed:** the **UK** was the dominant sender bank location, accounting for **9,253 of 9,873 laundering-labelled transactions (approximately 93.7%)** in the dataset. The UK was also the dominant receiver bank location in the analysis.
- **Currency concentration was observed:** **UK Pounds** accounted for the largest number of laundering-labelled transactions by payment currency.
- **Sender-level activity can provide another investigation signal:** analysing total transaction values by sender helps identify accounts with unusually high overall transaction activity.
- **Sequential behaviour can provide additional context:** transactions that increase sharply compared with the previous transaction for the same sender may represent a behavioural red flag requiring further review.

## Investigator-Oriented Takeaway

The analysis shows that transaction monitoring should not rely on a single indicator. Transaction value, payment type, geography, currency, sender-level activity, and changes in transaction behaviour can be considered together to identify transactions or accounts that may warrant further investigation.

These indicators **do not by themselves prove money laundering or other financial crime**. They are analytical signals that can support a risk-based investigation alongside customer information, transaction context, counterparties, source-of-funds information, and other available evidence.
