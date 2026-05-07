-- ── 1. Top 10 states with highest child stunting ─────────────────────
SELECT state, stunting_pct
FROM nfhs_state
WHERE area = 'Total'
AND stunting_pct IS NOT NULL
ORDER BY stunting_pct DESC
LIMIT 10;
-- ── 2. Top 10 states with lowest child stunting ──────────────────────
SELECT state, stunting_pct
FROM nfhs_state
WHERE area = 'Total'
AND stunting_pct IS NOT NULL
ORDER BY stunting_pct ASC
LIMIT 10;
-- ── 3. All 3 malnutrition indicators together by state ───────────────
SELECT state, stunting_pct, wasting_pct, underweight_pct
FROM nfhs_state
WHERE area = 'Total'
AND stunting_pct IS NOT NULL
ORDER BY stunting_pct DESC;
-- ── 4. Urban vs Rural stunting gap ───────────────────────────────────
SELECT 
    urban.state,
    urban.stunting_pct AS urban_stunting,
    rural.stunting_pct AS rural_stunting,
    ROUND(rural.stunting_pct - urban.stunting_pct, 1) AS gap
FROM nfhs_state urban
JOIN nfhs_state rural ON urban.state = rural.state
WHERE urban.area = 'Urban' AND rural.area = 'Rural'
AND urban.stunting_pct IS NOT NULL
AND rural.stunting_pct IS NOT NULL
ORDER BY gap DESC;
-- ── 5. Correlation — women literacy vs child stunting ────────────────
SELECT state, women_literacy_pct, stunting_pct, underweight_pct
FROM nfhs_state
WHERE area = 'Total'
AND stunting_pct IS NOT NULL
ORDER BY women_literacy_pct ASC;
-- ── 6. States where all 3 malnutrition indicators exceed national avg─
SELECT state, stunting_pct, wasting_pct, underweight_pct
FROM nfhs_state
WHERE area = 'Total'
AND stunting_pct > (SELECT stunting_pct FROM nfhs_state WHERE state = 'India' AND area = 'Total')
AND wasting_pct > (SELECT wasting_pct FROM nfhs_state WHERE state = 'India' AND area = 'Total')
AND underweight_pct > (SELECT underweight_pct FROM nfhs_state WHERE state = 'India' AND area = 'Total')
ORDER BY stunting_pct DESC;