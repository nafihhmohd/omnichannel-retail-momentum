USE retail_momentum;

CREATE OR REPLACE VIEW v_stg_ecommerce AS
SELECT 
    `Product Categories` AS category,
    `Customer Demographics` AS segment,
    `Sales Forecast` AS sales,
    `Advertising Spend` AS ad_spend,
    `Social Media Engagement` AS social_engagement,
    `Product Availability` AS stock_level,
    `Customer Satisfaction Score` AS satisfaction_score,
    `Average Order Value` AS aov,
    `Economic Indicator` AS eco_index
FROM retail_data;

CREATE OR REPLACE VIEW v_retail_kpis AS
SELECT 
    *,
    -- ROAS: How many dollars we make for every $1 spent on ads
    ROUND(sales / NULLIF(ad_spend, 0), 2) AS roas,
    -- Social Efficiency: How much engagement we get per ad dollar
    ROUND(social_engagement / NULLIF(ad_spend, 0), 2) AS social_efficiency,
    -- Stock Health Status
    CASE 
        WHEN stock_level < 20 THEN 'CRITICAL'
        WHEN stock_level < 50 THEN 'LOW'
        ELSE 'HEALTHY'
    END AS inventory_status
FROM v_stg_ecommerce;

CREATE TABLE fct_retail_strategy AS
SELECT 
    *,
    CASE 
        WHEN roas > 2.5 AND inventory_status = 'CRITICAL' THEN 'URGENT: Restock High-ROI Category'
        WHEN roas < 1.0 AND social_efficiency < 0.5 THEN 'BUDGET CUT: Marketing Underperforming'
        WHEN satisfaction_score < 3 THEN 'QUALITY CHECK: High Returns/Complaints'
        WHEN roas > 1.8 AND social_efficiency > 1.2 THEN 'OPPORTUNITY: Increase Social Ad Spend'
        ELSE 'STABLE: Monitor KPIs'
    END AS strategic_recommendation
FROM v_retail_kpis;

SELECT * FROM fct_retail_strategy;