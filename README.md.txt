# Transportation Network Optimization & Carrier Strategy

## Overview

This project features a simulated supply chain network transportation analysis, which will help build out my supply chain and solution architect portfolio.

This analysis examined how the different transportation lanes would impact transportation costs, what carrier choices would provide the best service levels, and whether or not it would be wise to switch to new carriers.

I developed these transportation cost models in Excel, then recreated a large portion of the analysis in PostgreSQL. This part of the project focuses on developing a data model, building data validation rules, and developing core views in SQL that would enable the development of a reporting solution using software such as Power BI and Tableau.
All data used in this project is simulated.

## Business Problem

Choosing the lowest carrier rate can have unintended negative consequences. It may appear to lower the cost of service, but it may have hidden risks related to capacity or operational issues.

When performing this analysis, I evaluated the service level associated with each carrier at the minimum cost. This evaluation was based on a 95% service level.

The model is designed to answer the following questions:

- What is the lower cost carrier options for each lane that meets the service level requirements?

- What is the service level associated with each carrier option at the lowest cost?

- How do the modeled carrier rates compared to current transport cost?

- What are the most optimal lanes for carrier negotiations?

- How much would a carrier rate have to decrease to justify a switch?

## Data Model

The PostgreSQL database has three primary tables.

### Shipments

This table has the transportation lanes used in the analysis.

Key fields include:

- Shipment ID
- Destination
- Number of shipments
- Current transportation cost

### Carrier Rates

This table has the simulated carrier pricing for each destination.

Key fields include:

- Rate ID
- Destination
- Carrier
- Carrier cost

### Carrier Service

This table contains service-level performance for each carrier along with the minimum required service level.

Key fields include:

- Carrier
- Service level
- Minimum service level

## Analysis Approach

The analysis follows a simple process:

1. Validate the source data.
2. Join carrier pricing with carrier service performance.
3. Remove carriers that do not meet the 95% minimum service requirement.
4. Rank the remaining carriers by cost within each destination.
5. Select the lowest-cost eligible carrier.
6. Compare the modeled cost with the current transportation cost.
7. Calculate the break-even discount required to make a carrier switch financially viable.
8. Create reusable SQL views for lane-level and executive reporting.

## SQL Skills Used

The project includes:

- Creating tables
- Inserting data
- Filtering and sorting
- INNER JOINs
- Aggregate functions
- GROUP BY and HAVING
- CASE statements
- Common Table Expressions (CTEs)
- Window functions
- ROW_NUMBER() and PARTITION BY
- Data validation queries
- Creating reusable SQL views

## Key Business Rule

A carrier is only considered for the optimization if its service level meets or exceeds the required minimum.

```sql
service_level >= minimum_service_level