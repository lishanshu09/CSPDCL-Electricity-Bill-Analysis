-- Problem 1: Total revenue billed vs collected --
SELECT 
	SUM(amount_billed) AS total_billed, 
    SUM(amount_paid) AS total_collected, 
    ROUND(SUM(amount_paid) * 100.0 / SUM(amount_billed), 2) AS collection_efficiency_pct 
FROM merged;

-- Problem 2: Locations with highest outstanding dues --
SELECT 
	location, 
    SUM(outstanding_dues) AS total_dues 
FROM merged 
GROUP BY location 
ORDER BY total_dues DESC 
LIMIT 10;

-- Problem 3: Penalty revenue vs genuine non-payment --
SELECT 
	SUM(penalty_amount) AS total_penalty, 
    SUM(amount_billed) AS total_billed, 
    ROUND(SUM(penalty_amount) * 100.0 / SUM(amount_billed), 2) AS penalty_rate_pct 
FROM merged;

-- Problem 4: Revenue split by charge component --
SELECT 
	SUM(fixed_charge) AS fixed_charge_total, 
    SUM(fca) AS fca_total, 
    SUM(lt_wt) AS lt_wt_total, 
    SUM(cess) AS cess_total 
FROM merged;

-- Problem 5: Billing discrepancy between expected and actual charges --
SELECT 
	service_number, 
    expected_amount, 
    amount_billed, 
    (amount_billed - expected_amount) AS discrepancy 
FROM merged 
WHERE ABS(amount_billed - expected_amount) > 0 
ORDER BY discrepancy DESC 
LIMIT 20;

-- Problem 6: MoM and YoY consumption trend --
SELECT 
	DATE_FORMAT(bill_date, '%Y-%m') AS month, 
    SUM(units_consumed) AS total_units, 
    LAG(SUM(units_consumed)) OVER (ORDER BY DATE_FORMAT(bill_date, '%Y-%m')) AS prev_month_units 
FROM merged 
GROUP BY month 
ORDER BY month;

-- Problem 7: Consumption by usage category --
SELECT 
	usage_category, 
    SUM(units_consumed) AS total_units 
FROM merged 
GROUP BY usage_category 
ORDER BY total_units DESC;

-- Problem 8: Percentage of consumers in critical or high arrear over time --
SELECT 
	DATE_FORMAT(bill_date, '%Y-%m') AS month, 
    SUM(CASE WHEN arrear_severity IN ('Critical','High') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_high_risk 
FROM merged 
GROUP BY month 
ORDER BY month;

-- Problem 9: Outstanding dues growth vs collections --
SELECT 
	DATE_FORMAT(bill_date, '%Y-%m') AS month, 
    SUM(outstanding_dues) AS dues, 
    SUM(amount_paid) AS collected 
FROM merged 
GROUP BY month 
ORDER BY month;

-- Problem 10: Arrear risk by bill type --
SELECT 
	bill_type, 
    arrear_severity, 
    COUNT(*) AS consumer_count 
FROM merged 
GROUP BY bill_type, arrear_severity 
ORDER BY bill_type, consumer_count DESC;

-- Problem 11: Meters needing inspection --
SELECT 
	COUNT(*) AS meters_needing_inspection 
FROM merged 
WHERE meter_status IN ('LT-Meter Defective','LT-Door Lock','LT-No use');

-- Problem 12: Percentage of problematic meter fleet --
SELECT 
	SUM(CASE WHEN meter_status <> 'Normal' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_problematic 
FROM merged;

-- Problem 13: Worst locations for problematic meters --
SELECT 
	location, 
    SUM(CASE WHEN meter_status <> 'Normal' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS problematic_pct 
FROM merged 
GROUP BY location 
ORDER BY problematic_pct DESC 
LIMIT 10;

-- Problem 14: Percentage of consumers with low power factor --
SELECT 
	SUM(CASE WHEN power_factor < 0.9 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_low_pf 
FROM merged;

-- Problem 15: Problematic meter trend over time --
SELECT 
	DATE_FORMAT(bill_date, '%Y-%m') AS month, 
    SUM(CASE WHEN meter_status <> 'Normal' THEN 1 ELSE 0 END) AS problematic_count 
FROM merged 
GROUP BY month 
ORDER BY month;

-- Problem 16: Overbilling vs underbilling vs normal split --
SELECT 
	deviation_remark, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct 
FROM merged 
GROUP BY deviation_remark 
ORDER BY count DESC;

-- Problem 17: Locations with highest overbilling --
SELECT 
	location, 
    COUNT(*) AS overbilling_count 
FROM merged 
WHERE deviation_remark = 'High overbilling' 
GROUP BY location 
ORDER BY overbilling_count DESC 
LIMIT 10;

-- Problem 18: Total credit amount owed back to consumers --
SELECT 
	SUM(credit_amount) AS total_credit_owed 
FROM merged 
WHERE credit_amount > 0;

-- Problem 19: Underbilling concentration by usage category --
SELECT 
	usage_category, 
    COUNT(*) AS underbilling_count 
FROM merged 
WHERE deviation_remark IN ('Minor underbilling','Moderate underbilling','Severe underbilling') 
GROUP BY usage_category 
ORDER BY underbilling_count DESC;

-- Problem 20: Deviation severity band for escalation priority --
SELECT 
	deviation_remark, 
    CASE 
		WHEN deviation_remark IN ('Severe overbilling','Severe underbilling') THEN 'Escalate Immediately' 
        WHEN deviation_remark IN ('Moderate overbilling','Moderate underbilling') THEN 'Review Within 30 Days' 
        ELSE 'Routine Monitoring' 
	END AS action_priority, 
    COUNT(*) AS count 
FROM merged 
GROUP BY deviation_remark, action_priority 
ORDER BY count DESC;

