
-- CARRIER ELIGIBILITY ANALYSIS

-- This query evaluates each carrier against the minimum required service level.

SELECT
    cs.carrier,
    ROUND(cs.service_level * 100, 2) AS service_level_percent,
    ROUND(cs.minimum_service_level * 100, 2) AS minimum_required_percent,
    
    CASE
        WHEN cs.service_level >= cs.minimum_service_level
            THEN 'Eligible'
        ELSE 'Not Eligible'
    END AS eligibility_status,

    CASE
        WHEN cs.service_level >= cs.minimum_service_level
            THEN 'Included in Optimization'
        ELSE 'Excluded from Optimization'
    END AS optimization_decision

FROM carrier_service cs
ORDER BY cs.service_level DESC;


-- ELIGIBLE CARRIER RATE OPTIONS

-- Returns only carrier rates that meet the minimum service-level requirement.


SELECT
    cr.destination,
    cr.carrier,
    cr.carrier_cost,
    ROUND(cs.service_level * 100, 2) AS service_level_percent
FROM carrier_rates cr
INNER JOIN carrier_service cs
    ON cr.carrier = cs.carrier
WHERE cs.service_level >= cs.minimum_service_level
ORDER BY
    cr.destination,
    cr.carrier_cost;