
-- CARRIER SWITCH BREAK-EVEN ANALYSIS

-- This query calculates the percentage reduction required for the recommended carrier's modeled rate to reach the current transportation cost.


WITH eligible_carriers AS (
    SELECT
        cr.destination,
        cr.carrier,
        cr.carrier_cost
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
        ROW_NUMBER() OVER (
            PARTITION BY destination
            ORDER BY carrier_cost
        ) AS cost_rank
    FROM eligible_carriers
),

recommended_carriers AS (
    SELECT
        destination,
        carrier AS recommended_carrier,
        carrier_cost AS optimized_cost
    FROM ranked_carriers
    WHERE cost_rank = 1
)

SELECT
    s.destination,
    s.current_cost,
    r.recommended_carrier,
    r.optimized_cost,
    ROUND(
        ((r.optimized_cost - s.current_cost) / r.optimized_cost) * 100,
        2
    ) AS break_even_discount_percent
FROM shipments s
INNER JOIN recommended_carriers r
    ON s.destination = r.destination
ORDER BY break_even_discount_percent;