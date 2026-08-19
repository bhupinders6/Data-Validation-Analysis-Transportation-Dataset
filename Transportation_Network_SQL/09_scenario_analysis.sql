
-- CARRIER RATE SCENARIO ANALYSIS

-- This analysis models 5%, 10%, and 15% reductions to the recommended carrier rate and compares each scenario with current cost.


SELECT
    destination,
    recommended_carrier,
    current_cost,
    optimized_cost,

    ROUND(optimized_cost * 0.95, 2) AS rate_reduction_5_percent,

    ROUND(optimized_cost * 0.90, 2) AS rate_reduction_10_percent,

    ROUND(optimized_cost * 0.85, 2) AS rate_reduction_15_percent

FROM vw_lane_optimization
ORDER BY destination;


-- SCENARIO COST COMPARISON

-- Determines whether each negotiated-rate scenario reaches cost parity with the current transportation network.


SELECT
    destination,
    recommended_carrier,
    current_cost,
    optimized_cost,

    ROUND(optimized_cost * 0.95, 2) AS scenario_5_percent,

    ROUND(optimized_cost * 0.90, 2) AS scenario_10_percent,

    ROUND(optimized_cost * 0.85, 2) AS scenario_15_percent,

    CASE
        WHEN optimized_cost * 0.90 <= current_cost
            THEN 'Cost Advantage'
        ELSE 'Still Above Current Cost'
    END AS ten_percent_scenario_result

FROM vw_lane_optimization
ORDER BY destination;



-- NEGOTIATED RATE RECOMMENDATION

-- Uses the break-even discount to identify the approximate negotiation requirement for each lane.


SELECT
    destination,
    recommended_carrier,
    current_cost,
    optimized_cost,
    break_even_discount_percent,

    CASE
        WHEN break_even_discount_percent <= 15
            THEN 'Strong Negotiation Opportunity'
        WHEN break_even_discount_percent <= 25
            THEN 'Moderate Negotiation Opportunity'
        WHEN break_even_discount_percent <= 35
            THEN 'Challenging Negotiation Opportunity'
        ELSE 'Low Probability of Cost Parity'
    END AS negotiation_assessment

FROM vw_lane_optimization
ORDER BY break_even_discount_percent;