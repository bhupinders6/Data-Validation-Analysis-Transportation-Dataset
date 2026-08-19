
-- REUSABLE SQL VIEWS

-- These views create reusable datasets for lane-level analysis and executive reporting.


-- 1. LANE-LEVEL OPTIMIZATION VIEW
CREATE OR REPLACE VIEW vw_lane_optimization AS

WITH eligible_carriers AS (
    SELECT
        cr.destination,
        cr.carrier,
        cr.carrier_cost,
        cs.service_level
    FROM carrier_rates cr
    INNER JOIN carrier_service cs
        ON cr.carrier = cs.carrier
    WHERE cs.service_level >= cs.minimum_service_level
),

ranked_carriers AS (
    SELECT
        destination,
        carrier,
        carrier_cost,
        service_level,
        ROW_NUMBER() OVER (
            PARTITION BY destination
            ORDER BY carrier_cost
        ) AS cost_rank
    FROM eligible_carriers
)

SELECT
    s.shipment_id,
    s.destination,
    s.shipments,
    s.current_cost,
    r.carrier AS recommended_carrier,
    r.carrier_cost AS optimized_cost,
    r.service_level,
    s.current_cost - r.carrier_cost AS cost_variance,
    ROUND(
        ((s.current_cost - r.carrier_cost) / s.current_cost) * 100,
        2
    ) AS variance_percent,
    ROUND(
        ((r.carrier_cost - s.current_cost) / r.carrier_cost) * 100,
        2
    ) AS break_even_discount_percent
FROM shipments s
INNER JOIN ranked_carriers r
    ON s.destination = r.destination
WHERE r.cost_rank = 1;



-- 2. EXECUTIVE NETWORK SUMMARY VIEW

CREATE OR REPLACE VIEW vw_executive_network_summary AS

SELECT
    SUM(current_cost) AS current_transportation_spend,
    SUM(optimized_cost) AS modeled_transportation_spend,
    SUM(cost_variance) AS modeled_cost_variance,
    COUNT(*) AS total_lanes,
    SUM(shipments) AS total_shipments,
    ROUND(AVG(service_level) * 100, 2) AS average_service_level_percent
FROM vw_lane_optimization;