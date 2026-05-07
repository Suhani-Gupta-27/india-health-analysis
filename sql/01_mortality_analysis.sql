ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'gungun';
FLUSH PRIVILEGES;

USE india_health;
-- ── 1. Top 5 states with highest Infant Mortality Rate ──────────────
SELECT state, IMR
FROM nfhs_state
WHERE area = 'Total'
ORDER BY IMR DESC
LIMIT 5;
-- ── 2. Top 5 states with lowest Infant Mortality Rate ───────────────
-- Top 5 states with lowest IMR
SELECT state, IMR
FROM nfhs_state
WHERE area = 'Total'
AND IMR IS NOT NULL
ORDER BY IMR ASC
LIMIT 5;
-- ── 3. IMR comparison — NFHS vs SRS 2020 ───────────────────────────
SELECT n.state, n.IMR AS IMR_NFHS, s.IMR_SRS_2020
FROM nfhs_state n
JOIN srs_2020 s ON n.state = s.state
WHERE n.area = 'Total'
ORDER BY n.IMR DESC;
-- Check for duplicate state names in SRS table
SELECT state, COUNT(*) as count
FROM srs_2020
GROUP BY state
HAVING count > 1;
SELECT COUNT(*) FROM srs_2020;
SELECT * FROM srs_2020 WHERE state = 'India';
-- States in SRS that didn't match NFHS
SELECT s.state AS srs_state
FROM srs_2020 s
LEFT JOIN nfhs_state n ON s.state = n.state
WHERE n.state IS NULL;
-- Check exact NFHS names for these states
SELECT DISTINCT state 
FROM nfhs_state 
WHERE state LIKE '%Delhi%' 
OR state LIKE '%Maharashtra%'
OR state LIKE '%Jammu%'
OR state LIKE '%Andaman%'
OR state LIKE '%Dadra%';

SET SQL_SAFE_UPDATES = 0;
UPDATE srs_2020 SET state = 'Andaman & Nicobar Islands' 
WHERE state = 'Andaman and Nicobar Islands';

UPDATE srs_2020 SET state = 'Dadra and Nagar Haveli & Daman and Diu' 
WHERE state = 'Dadra and Nagar Haveli and Daman and Diu';

UPDATE srs_2020 SET state = 'Jammu & Kashmir' 
WHERE state = 'Jammu and Kashmir';

UPDATE srs_2020 SET state = 'NCT of Delhi' 
WHERE state = 'Delhi';
SET SQL_SAFE_UPDATES = 1;

-- ── 3. IMR comparison — NFHS vs SRS 2020 ───────────────────────────
SELECT n.state, n.IMR AS IMR_NFHS, s.IMR_SRS_2020
FROM nfhs_state n
JOIN srs_2020 s ON n.state = s.state
WHERE n.area = 'Total'
ORDER BY n.IMR DESC;
-- ── 5. Urban vs Rural IMR gap by state ──────────────────────────────
SELECT 
    urban.state,
    urban.IMR AS urban_IMR,
    rural.IMR AS rural_IMR,
    ROUND(rural.IMR - urban.IMR, 1) AS urban_rural_gap
FROM nfhs_state urban
JOIN nfhs_state rural 
    ON urban.state = rural.state
WHERE urban.area = 'Urban' 
AND rural.area = 'Rural'
AND urban.IMR IS NOT NULL 
AND rural.IMR IS NOT NULL
ORDER BY urban_rural_gap DESC;
-- ── 6. States with highest Under-5 mortality ────────────────────────
SELECT state, u5_mortality, neonatal_mortality, IMR
FROM nfhs_state
WHERE area = 'Total'
AND u5_mortality IS NOT NULL
ORDER BY u5_mortality DESC
LIMIT 10;
-- ── 7. TFR vs IMR — do high fertility states have high mortality ─────
SELECT state, TFR, IMR, u5_mortality
FROM nfhs_state
WHERE area = 'Total'
AND IMR IS NOT NULL
ORDER BY TFR DESC;