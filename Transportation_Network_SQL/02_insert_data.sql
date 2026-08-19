-- Transportation Network Optimization Portfolio Project


-- Simulated data for portfolio demonstration purposes

-- SHIPMENT DATA

INSERT INTO shipments (
    shipment_id,
    destination,
    shipments,
    current_cost
)
VALUES
    (1, 'Montreal', 4, 2480.00),
    (2, 'Ottawa', 4, 2375.00),
    (3, 'Windsor', 3, 3250.00),
    (4, 'London', 3, 1235.00),
    (5, 'Quebec City', 3, 3400.00),
    (6, 'Mississauga', 3, 860.00);


-- CARRIER RATE DATA

INSERT INTO carrier_rates (
    rate_id,
    destination,
    carrier,
    carrier_cost
)
VALUES
    (1, 'Montreal', 'Carrier A', 3590.32),
    (2, 'Montreal', 'Carrier B', 3411.20),
    (3, 'Montreal', 'Carrier C', 3709.60),

    (4, 'Ottawa', 'Carrier A', 2981.44),
    (5, 'Ottawa', 'Carrier B', 2830.40),
    (6, 'Ottawa', 'Carrier C', 3083.20),

    (7, 'Windsor', 'Carrier A', 3976.23),
    (8, 'Windsor', 'Carrier C', 3780.90),

    (9, 'London', 'Carrier A', 1698.00),
    (10, 'London', 'Carrier B', 1814.25),
    (11, 'London', 'Carrier C', 1607.70),

    (12, 'Quebec City', 'Carrier A', 6193.80),
    (13, 'Quebec City', 'Carrier B', 5898.00),
    (14, 'Quebec City', 'Carrier C', 6384.00),

    (15, 'Mississauga', 'Carrier A', 1698.00),
    (16, 'Mississauga', 'Carrier B', 1814.25),
    (17, 'Mississauga', 'Carrier C', 1599.00);

-- CARRIER SERVICE DATA

INSERT INTO carrier_service (
    carrier,
    service_level,
    minimum_service_level
)
VALUES
    ('Carrier A', 0.96, 0.95),
    ('Carrier B', 0.93, 0.95),
    ('Carrier C', 0.98, 0.95);