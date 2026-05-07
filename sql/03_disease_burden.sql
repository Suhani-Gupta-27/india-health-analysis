-- ── 1. Anaemia burden — children, women, men by state ────────────────
SELECT state, child_anaemia_pct, women_anaemia_pct, men_anaemia_pct
FROM nfhs_state
WHERE area = 'Total'
AND child_anaemia_pct IS NOT NULL
ORDER BY child_anaemia_pct DESC;
-- ── 2. Urban vs Rural anaemia gap in women ───────────────────────────
SELECT
    urban.state,
    urban.women_anaemia_pct AS urban_anaemia,
    rural.women_anaemia_pct AS rural_anaemia,
    ROUND(rural.women_anaemia_pct - urban.women_anaemia_pct, 1) AS gap
FROM nfhs_state urban
JOIN nfhs_state rural ON urban.state = rural.state
WHERE urban.area = 'Urban' AND rural.area = 'Rural'
AND urban.women_anaemia_pct IS NOT NULL
ORDER BY gap DESC;
-- ── 3. Diabetes prevalence — women vs men by state ───────────────────
SELECT state, women_diabetes_pct, men_diabetes_pct,
    ROUND(women_diabetes_pct - men_diabetes_pct, 1) AS gender_gap
FROM nfhs_state
WHERE area = 'Total'
AND women_diabetes_pct IS NOT NULL
ORDER BY women_diabetes_pct DESC;
-- ── 4. Urban vs Rural diabetes gap ───────────────────────────────────
SELECT
    urban.state,
    urban.women_diabetes_pct AS urban_diabetes,
    rural.women_diabetes_pct AS rural_diabetes,
    ROUND(urban.women_diabetes_pct - rural.women_diabetes_pct, 1) AS urban_rural_gap
FROM nfhs_state urban
JOIN nfhs_state rural ON urban.state = rural.state
WHERE urban.area = 'Urban' AND rural.area = 'Rural'
AND urban.women_diabetes_pct IS NOT NULL
ORDER BY urban_rural_gap DESC;
-- ── 7. Tobacco and alcohol use by state ──────────────────────────────
SELECT state, women_tobacco_pct, men_tobacco_pct, 
       women_alcohol_pct, men_alcohol_pct
FROM nfhs_state
WHERE area = 'Total'
AND men_tobacco_pct IS NOT NULL
ORDER BY men_tobacco_pct DESC;