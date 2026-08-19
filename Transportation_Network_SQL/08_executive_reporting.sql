
-- EXECUTIVE NETWORK REPORTING

-- This script provides executive-level KPIs and a lane-level summary for reporting.




-- 1. EXECUTIVE KPI SUMMARY


SELECT
    current_transportation_spend,
    modeled_transportation_spend,
    modeled_cost_variance,
    total_lanes,
    total_shipments,
    average_service_level_percent
FROM vw_executive_network_summary;


-
-- 2. LANE-LEVEL EXECUTIVE SUMMARY


SELECT
    destination,
    shipments,
    current_cost,
    recommended_carrier,
    optimized_cost,
    cost_variance,
    variance_percent,
    break_even_discount_percent
FROM vw_lane_optimization
ORDER BY break_even_discount_percent;



-- 3. NEGOTIATION PRIORITY


SELECT
    destination,
    recommended_carrier,
    current_cost,
    optimized_cost,
    break_even_discount_percent,
    
    CASE
        WHEN break_even_discount_percent <= 20
            THEN 'High Priority'
        WHEN break_even_discount_percent <= 30
            THEN 'Medium Priority'
        ELSE 'Lower Priority'
    END AS negotiation_priority

FROM vw_lane_optimization
ORDER BY break_even_discount_percent;