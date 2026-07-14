## CSPDCL Electricity Bill Analysis

An end-to-end data analytics project on real electricity billing data from CSPDCL Bilaspur (42K+ rows, 52 columns), covering the full pipeline from raw data to decision-ready dashboards.

### What this project does

**1. Data Cleaning & EDA (Python)**
Performed exploratory data analysis on raw billing records to understand distributions, detect anomalies, and surface data quality issues — missing values, duplicate service numbers, inconsistent categorical entries, and outlier consumption values. Engineered new features including billing deviation classification (`np.select` logic), deviation percentage, bill type mapping, and meter reset status flags to support downstream analysis.

**2. SQL — Answering Business Questions**
Designed a normalized MySQL schema (star-schema style, with geography, usage, and billing fact tables) and wrote SQL queries to directly answer business problems such as:
- Which locations and usage categories contribute the most to overbilling/underbilling?
- What percentage of consumers fall into high/critical arrear, and how has that trended over time?
- Which meters are flagged as problematic, and where are inspection priorities concentrated?
- How does revenue collection efficiency vary by usage category and location?

Used window functions, CTEs, and aggregate queries to translate raw tables into audit-ready, decision-relevant metrics — validated with `EXPLAIN` for query performance on a 40K+ row fact table.

**3. Power BI Dashboarding**
Built a 5-page interactive dashboard (Executive Summary, Revenue Analysis, Consumption & Recovery, Infrastructure Health, Audit Findings) with DAX-driven MoM/YoY trend measures, drill-through by service number, and cross-filtering slicers — turning the SQL-derived insights into a tool usable by non-technical stakeholders.

### Key findings
- ₹6.20 Cr billed, but only **20.44%** collection efficiency
- **26.6%** of accounts in critical arrear, **25.8%** in high arrear
- **60.8%** of consumers running low power factor; 757 meters flagged for inspection
- ₹1.54 Cr in audit credit adjustments — **19.7%** overbilling, **10.5%** underbilling identified

### Stack
Python (Pandas, EDA) • MySQL (schema design, query optimization) • Power BI (DAX, star-schema modeling)

---

Want me to also add a folder structure section (`/eda`, `/sql`, `/dashboard`, `/data`) so it maps to how your repo is actually organized?
