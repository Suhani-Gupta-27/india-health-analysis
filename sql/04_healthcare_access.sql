-- ── 1. Institutional births ranking by state ─────────────────────────
SELECT state, institutional_births_pct
FROM nfhs_state
WHERE area = 'Total'
AND institutional_births_pct IS NOT NULL
ORDER BY institutional_births_pct DESC;
-- ── 2. States below 80% institutional births ─────────────────────────
SELECT state, institutional_births_pct
FROM nfhs_state
WHERE area = 'Total'
AND institutional_births_pct < 80
AND institutional_births_pct IS NOT NULL
ORDER BY institutional_births_pct ASC;
-- ── 3. Full vaccination coverage by state ────────────────────────────
SELECT state, full_vaccination_pct
FROM nfhs_state
WHERE area = 'Total'
AND full_vaccination_pct IS NOT NULL
ORDER BY full_vaccination_pct DESC;
-- ── 4. ANC visits coverage — first trimester and 4+ visits ───────────
SELECT state, ANC_trimester_pct, ANC_4visits_pct,
    ROUND(ANC_trimester_pct - ANC_4visits_pct, 1) AS dropout_gap
FROM nfhs_state
WHERE area = 'Total'
AND ANC_trimester_pct IS NOT NULL
ORDER BY dropout_gap DESC;
-- ── 5. Urban vs Rural institutional births gap ───────────────────
SELECT
    urban.state,
    urban.institutional_births_pct AS urban_births,
    rural.institutional_births_pct AS rural_births,
    ROUND(urban.institutional_births_pct - rural.institutional_births_pct, 1) AS gap
FROM nfhs_state urban
JOIN nfhs_state rural ON urban.state = rural.state
WHERE urban.area = 'Urban' AND rural.area = 'Rural'
AND urban.institutional_births_pct IS NOT NULL
ORDER BY gap DESC;
-- ── 6. States where low vaccination correlates with high U5 mortality─
SELECT state, full_vaccination_pct, u5_mortality, IMR
FROM nfhs_state
WHERE area = 'Total'
AND full_vaccination_pct IS NOT NULL
AND u5_mortality IS NOT NULL
ORDER BY full_vaccination_pct ASC;
-- ── 7. Overall healthcare access score per state ─────────────────────
SELECT state,
    ROUND((institutional_births_pct + full_vaccination_pct + 
           ANC_trimester_pct + ANC_4visits_pct) / 4, 1) AS access_score
FROM nfhs_state
WHERE area = 'Total'
AND institutional_births_pct IS NOT NULL
ORDER BY access_score DESC;

