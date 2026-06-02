# ⛏️ Mining Operations Analytics

### SQL Server + Power BI | Granite Quarry Operations | 6-Month Analysis

![Dashboard Preview](dashboard_overview.jpg)

-----

## 📌 Project Overview

This is my 4th data analytics portfolio project — a comprehensive 6-month analysis of weighbridge transaction data from a second branch of a granite quarry operation in Nigeria. Unlike my previous weighbridge project (2-week snapshot), this dataset spans **6 full months** and enables deeper trend analysis including seasonality, price elasticity, weekday patterns and revenue forecasting.

The data was obtained with permission from the organization and anonymized for portfolio purposes.

**Tools Used:** Microsoft SQL Server (SSMS) · Power BI Desktop · Microsoft Excel Online

-----

## 🏗️ Business Context

A weighbridge is a large industrial scale used to weigh heavy vehicles. Every truck is weighed **twice**:

- **Tare weight** — truck weighed empty on arrival
- **Gross weight** — truck weighed again after loading

Net = Gross − Tare (actual tonnage of product loaded)

This data drives **revenue calculation, product demand tracking, pricing analysis and operational planning.**

**Key difference from Branch 1:** This branch operates **7 days a week** including Sundays, has 4 operators instead of 3, and sells an additional product (Lumps) not available at Branch 1.

-----

## 📊 Dataset

|Attribute         |Detail                                                 |
|------------------|-------------------------------------------------------|
|Period            |November 1, 2025 – May 21, 2026 (6 months)             |
|Total Transactions|10,483                                                 |
|Total Net Tons    |128,280                                                |
|Total Revenue     |₦1,048,140,021 (~₦1.05 Billion)                        |
|Active Agents     |129                                                    |
|Active Trucks     |1,158                                                  |
|Operators         |4 (AISHA, BIMPE, CHRISTY, OPE)                         |
|Products          |5/8, 3/8, 1/2, Stone Dust, Hard Core, Stone Base, Lumps|
|Price Changes     |7 price change periods across all products             |

-----

## 🧹 Data Cleaning

Raw data was cleaned in Excel Online before being imported into SQL Server:

|Issue                                          |Action Taken                                                             |
|-----------------------------------------------|-------------------------------------------------------------------------|
|Operator name typos (6 variants of CHRISTY)    |All corrected to CHRISTY                                                 |
|Product code typo (34D)                        |Corrected to 3/4D                                                        |
|Product named “Dust”                           |Renamed to “Stone Dust” for consistency                                  |
|Wrong product entry (CHRISTY in Product column)|Corrected to 5/8 via physical records                                    |
|Totals row at bottom of dataset                |Deleted                                                                  |
|Product codes renamed                          |e.g. 3/4D → 5/8, DUST → Stone Dust                                       |
|2,037 negative turnaround times                |Corrected to absolute value                                              |
|5,553 zero turnaround times                    |Flagged as system limitation — excluded from turnaround analysis         |
|Date extracted from GrossTime                  |More accurate than TransactionID for this dataset due to saved tare dates|
|Revenue calculated in SQL                      |Using dim_price_history JOIN across 7 price periods                      |

-----

## 🗄️ Database Schema

The database `Truck_weight_db` follows a **star schema** design with 1 fact table and 5 dimension tables.

```
fact_transaction
    ├── dim_products       (via Product name)
    ├── dim_agents         (via Agent name)
    ├── dim_operators      (via Operator name)
    ├── dim_trucks         (via Truck number)
    └── dim_price_history  (via dim_products → ProductID)
```

### Tables

|Table              |Rows  |Description                     |
|-------------------|------|--------------------------------|
|`fact_transaction` |10,483|Core transaction records        |
|`dim_products`     |7     |Product names and current prices|
|`dim_agents`       |129   |Agent accounts                  |
|`dim_operators`    |4     |Weighbridge operators           |
|`dim_trucks`       |1,158 |Registered truck numbers        |
|`dim_price_history`|49    |7 price periods × 7 products    |

-----

## 💰 Price History

All products went through **7 price change periods** between Nov 2025 and May 2026:

|Effective From|5/8    |3/8    |1/2    |Stone Dust|Stone Base|Hard Core|Lumps  |
|--------------|-------|-------|-------|----------|----------|---------|-------|
|Nov 1, 2025   |₦10,600|₦10,100|₦10,100|₦4,000    |₦6,500    |₦8,500   |₦8,500 |
|Feb 18, 2026  |₦11,100|₦10,100|₦10,100|₦3,500    |₦6,500    |₦8,500   |₦8,500 |
|Mar 9, 2026   |₦11,900|₦10,500|₦10,800|₦4,000    |₦7,000    |₦9,000   |₦9,000 |
|Mar 16, 2026  |₦12,600|₦10,600|₦11,600|₦4,000    |₦7,000    |₦9,000   |₦9,000 |
|Apr 3, 2026   |₦13,100|₦11,000|₦12,100|₦4,000    |₦7,500    |₦9,500   |₦9,500 |
|May 1, 2026   |₦13,700|₦11,500|₦12,600|₦4,000    |₦8,000    |₦10,000  |₦10,000|
|May 5, 2026   |₦14,100|₦12,000|₦13,000|₦4,500    |₦8,000    |₦10,000  |₦10,000|

-----

## 🔍 SQL Analysis Queries

Six business analysis queries were written and executed in SQL Server:

### 1. Monthly Revenue Trend

**Key Insight:** February 2026 was the peak month — 1,954 transactions, ₦192M revenue. Sharp drop in March despite price increases worth investigating. May revenue higher than April despite fewer transactions — price increases are working.

-----

### 2. Agent Consistency (Monthly)

**Key Insight:** CRETE dominates consistently across 6 months with May as their strongest month (₦25.3M). BADMUS is a strong second. Top 2 agents together account for over ₦220M — 21% of total revenue.

-----

### 3. Weekday Patterns

**Key Insight:** Monday is the busiest day — 2,143 transactions and ₦213.8M total revenue. Operations wind down toward the weekend. Unlike Branch 1, this branch operates on Sundays (298 transactions). Average revenue per transaction is consistent across all days at ~₦99K-₦102K.

-----

### 4. Revenue Forecasting Base Data

Daily revenue data across 178 working days — used as the base for Power BI’s built-in forecast feature to project future revenue trends.

-----

### 5. Seasonality by Product

**Key Insight:** February is the peak month across all products. Stone Dust and 5/8 are the most consistent sellers appearing strongly every month. Lumps is extremely rare — appearing in only 1 month across the entire 6-month period.

-----

### 6. Price Elasticity

**Key Insight:** As prices increased across all products, transaction volumes declined but revenue held due to the higher price per ton. 3/8 showed the most price sensitivity — transactions dropped from 328 to 133 as price rose from ₦10,100 to ₦12,000. This data can inform future pricing strategy decisions.

-----

## 📈 Power BI Dashboard

A single comprehensive dashboard with interactive month and product slicers:

**KPI Cards:** Total Transactions · Total Revenue · Total Net Tons · Avg Daily Revenue

**Charts:**

- Monthly Revenue Trend (combo line chart — Revenue + Net Tons)
- Revenue by Products (horizontal bar)
- Top 5 Agents by Revenue (horizontal bar)
- Net Tons by Products (donut chart)
- Weekdays Pattern (horizontal bar)

**Interactive filters:**

- Month slicer (Nov 2025 – May 2026)
- Product slicer
- Year buttons (2025 / 2026)

-----

## 💡 Key Business Insights

1. **₦1.05 Billion revenue in 6 months** from 10,483 transactions across 7 product lines
1. **February 2026 was the peak month** — highest transactions, tonnage and revenue. Drop in March warrants investigation
1. **Monday dominates** — 2,143 transactions vs 1,349 on Saturday. Agents restock accounts over the weekend and hit hard on Monday
1. **This branch works Sundays** — 298 Sunday transactions showing different operational culture from Branch 1
1. **CRETE and BADMUS are the power accounts** — consistently top performers every single month
1. **Price increases did not kill demand** — revenue grew despite rising prices across all products
1. **Stone Dust leads in volume** (37.4% of net tons) while 5/8 leads in revenue — higher price per ton drives revenue dominance
1. **Lumps is a niche product** — appeared in only 1 month, extremely low volume

-----

## 📁 Repository Structure

```
Mining-Operations-Analytics/
│
├── screenshots/
│   └── dashboard_overview.jpg
│
├── sql/
│   ├── 01_create_tables.sql
│   └── 02_analysis_queries.sql
│
├── data/
│   └── Weighbridge_mining_datasets.csv
│
└── README.md
```

-----

## 🔗 Related Project

This project is a continuation of my weighbridge analytics work:
👉 [Weighbridge Management Analytics — Branch 1 (2-week snapshot)](https://github.com/Pearla141/Weighbridge-Management-Analytics)

-----

## 👩‍💻 About

Built by **Pearla** · Data Analyst  
[LinkedIn](https://www.linkedin.com/in/your-linkedin) · [GitHub](https://github.com/Pearla141)

*This project uses real operational data obtained with organizational permission, anonymized for portfolio use.*
