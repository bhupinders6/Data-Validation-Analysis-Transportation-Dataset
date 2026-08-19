
-- DATA VALIDATION CHECKS

-- These queries check the shipment data for missing values, invalid values, and duplicates.


--1. CHECK FOR INVALID SHIPMENT DATA

SELECT
    shipment_id,
    destination,
    shipments,
    current_cost,
    CASE
        WHEN destination IS NULL OR TRIM(destination) = ''
            THEN 'Invalid Destination'
        WHEN shipments IS NULL OR shipments <= 0
            THEN 'Invalid Shipment Count'
        WHEN current_cost IS NULL OR current_cost < 0
            THEN 'Invalid Current Cost'
        ELSE 'Valid'
    END AS validation_status
FROM shipments
ORDER BY shipment_id;

-- 2. CHECK FOR DUPLICATE SHIPMENT IDs

SELECT
    shipment_id,
    COUNT(*) AS record_count
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;