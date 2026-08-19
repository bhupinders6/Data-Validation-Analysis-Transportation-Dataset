
-- DATA QUALITY SUMMARY

-- This script provides a consolidated view of basic data-quality checks before analysis and reporting.
--
-- Expected result for the current simulated data: all shipment records are valid and no duplicate
-- shipment IDs should be returned.




-- 1. TABLE RECORD COUNTS


SELECT
    'shipments' AS table_name,
    COUNT(*) AS record_count
FROM shipments

UNION ALL

SELECT
    'carrier_rates' AS table_name,
    COUNT(*) AS record_count
FROM carrier_rates

UNION ALL

SELECT
    'carrier_service' AS table_name,
    COUNT(*) AS record_count
FROM carrier_service;



-- 2. SHIPMENT DATA VALIDATION SUMMARY


WITH validation_results AS (
    SELECT
        shipment_id,
        CASE
            WHEN destination IS NULL
                OR TRIM(destination) = ''
                THEN 'Invalid Destination'

            WHEN shipments IS NULL
                OR shipments <= 0
                THEN 'Invalid Shipment Count'

            WHEN current_cost IS NULL
                OR current_cost < 0
                THEN 'Invalid Current Cost'

            ELSE 'Valid'
        END AS validation_status
    FROM shipments
)

SELECT
    validation_status,
    COUNT(*) AS record_count
FROM validation_results
GROUP BY validation_status
ORDER BY validation_status;



-- 3. DUPLICATE SHIPMENT ID CHECK


SELECT
    shipment_id,
    COUNT(*) AS record_count
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;


-- 4. CARRIER SERVICE DATA CHECK


SELECT
    carrier,
    ROUND(service_level * 100, 2) AS service_level_percent,
    ROUND(minimum_service_level * 100, 2) AS minimum_service_level_percent,

    CASE
        WHEN service_level IS NULL
            THEN 'Missing Service Level'

        WHEN minimum_service_level IS NULL
            THEN 'Missing Minimum Requirement'

        WHEN service_level < 0
            OR service_level > 1
            THEN 'Invalid Service Level'

        WHEN minimum_service_level < 0
            OR minimum_service_level > 1
            THEN 'Invalid Minimum Requirement'

        ELSE 'Valid'
    END AS validation_status

FROM carrier_service
ORDER BY carrier;



-- 5. CARRIER RATE DATA CHECK


SELECT
    rate_id,
    destination,
    carrier,
    carrier_cost,

    CASE
        WHEN destination IS NULL
            OR TRIM(destination) = ''
            THEN 'Invalid Destination'

        WHEN carrier IS NULL
            OR TRIM(carrier) = ''
            THEN 'Invalid Carrier'

        WHEN carrier_cost IS NULL
            OR carrier_cost < 0
            THEN 'Invalid Carrier Cost'

        ELSE 'Valid'
    END AS validation_status

FROM carrier_rates
ORDER BY rate_id;



-- 6. OVERALL DATA QUALITY STATUS


WITH shipment_checks AS (
    SELECT
        COUNT(*) FILTER (
            WHERE destination IS NULL
               OR TRIM(destination) = ''
               OR shipments IS NULL
               OR shipments <= 0
               OR current_cost IS NULL
               OR current_cost < 0
        ) AS invalid_shipment_records
    FROM shipments
),

duplicate_checks AS (
    SELECT
        COUNT(*) AS duplicate_shipment_ids
    FROM (
        SELECT shipment_id
        FROM shipments
        GROUP BY shipment_id
        HAVING COUNT(*) > 1
    ) duplicates
),

carrier_rate_checks AS (
    SELECT
        COUNT(*) FILTER (
            WHERE destination IS NULL
               OR TRIM(destination) = ''
               OR carrier IS NULL
               OR TRIM(carrier) = ''
               OR carrier_cost IS NULL
               OR carrier_cost < 0
        ) AS invalid_carrier_rate_records
    FROM carrier_rates
),

carrier_service_checks AS (
    SELECT
        COUNT(*) FILTER (
            WHERE service_level IS NULL
               OR minimum_service_level IS NULL
               OR service_level < 0
               OR service_level > 1
               OR minimum_service_level < 0
               OR minimum_service_level > 1
        ) AS invalid_service_records
    FROM carrier_service
)

SELECT
    sc.invalid_shipment_records,
    dc.duplicate_shipment_ids,
    crc.invalid_carrier_rate_records,
    csc.invalid_service_records,

    CASE
        WHEN sc.invalid_shipment_records = 0
         AND dc.duplicate_shipment_ids = 0
         AND crc.invalid_carrier_rate_records = 0
         AND csc.invalid_service_records = 0
            THEN 'PASS - Data Ready for Analysis'
        ELSE 'REVIEW REQUIRED - Data Quality Issues Found'
    END AS overall_data_quality_status

FROM shipment_checks sc
CROSS JOIN duplicate_checks dc
CROSS JOIN carrier_rate_checks crc
CROSS JOIN carrier_service_checks csc;