
-- OPERATIONAL FEASIBILITY ANALYSIS
-- This analysis combines carrier cost, service performance, and implementation considerations.
--
-- The data used in this project is simulated.

-- Operational feasibility assumptions should bevalidated before implementation.


-- 1. LANE-LEVEL OPERATIONAL FEASIBILITY


SELECT
    destination,
    recommended_carrier,
    shipments,
    current_cost,
    optimized_cost,
    ROUND(service_level * 100, 2) AS service_level_percent,
    break_even_discount_percent,

    CASE
        WHEN service_level >= 0.95
            THEN 'Meets Service Requirement'
        ELSE 'Does Not Meet Service Requirement'
    END AS service_feasibility,

    CASE
        WHEN break_even_discount_percent <= 20
            THEN 'Strong Negotiation Potential'
        WHEN break_even_discount_percent <= 30
            THEN 'Moderate Negotiation Potential'
        ELSE 'Limited Negotiation Potential'
    END AS commercial_feasibility

FROM vw_lane_optimization
ORDER BY break_even_discount_percent;



-- 2. IMPLEMENTATION DECISION SUPPORT

-- Combines service and cost considerations into a high-level implementation recommendation.


SELECT
    destination,
    recommended_carrier,
    ROUND(service_level * 100, 2) AS service_level_percent,
    current_cost,
    optimized_cost,
    break_even_discount_percent,

    CASE
        WHEN service_level < 0.95
            THEN 'Do Not Proceed - Service Constraint'
        WHEN break_even_discount_percent <= 20
            THEN 'Proceed to Carrier Negotiation'
        WHEN break_even_discount_percent <= 30
            THEN 'Evaluate Commercial Opportunity'
        ELSE 'Maintain Current Network'
    END AS implementation_recommendation

FROM vw_lane_optimization
ORDER BY break_even_discount_percent;



-- 3. IMPLEMENTATION VALIDATION CHECKLIST

-- These are portfolio-level implementation checkpoints for any potential carrier change.


SELECT
    destination,
    recommended_carrier,

    'Validate carrier capacity' AS capacity_check,

    'Confirm service commitment' AS service_check,

    'Review accessorial charges' AS accessorial_check,

    'Validate contract terms' AS contract_check,

    'Confirm TMS configuration' AS tms_check,

    'Confirm operational readiness' AS operational_readiness_check

FROM vw_lane_optimization
ORDER BY destination;