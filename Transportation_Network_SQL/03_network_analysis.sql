-- TRANSPORTATION NETWORK ANALYSIS

-- This query selects the lowest-cost carrier that mmeets the minimum service requirement for each transportation lane. 


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
),

recommended_carriers AS (

    SELECT
        destination,
        carrier AS recommended_carrier,
        carrier_cost AS optimized_cost,
        service_level
    FROM ranked_carriers
    WHERE cost_rank = 1
)

SELECT
    s.destination,
    s.shipments,
    s.current_cost,
    r.recommended_carrier,
    r.optimized_cost,
    r.service_level,
    s.current_cost - r.optimized_cost AS cost_variance,
    ROUND(

        ((s.current_cost - r.optimized_cost) / s.current_cost) * 100,

        2
    ) AS variance_percent

FROM shipments s
INNER JOIN recommended_carriers r

    ON s.destination = r.destination
    
ORDER BY s.destination;