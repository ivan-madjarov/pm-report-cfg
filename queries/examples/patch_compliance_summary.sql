-- =============================================================================
-- PATCH COMPLIANCE SUMMARY
-- =============================================================================
-- Purpose: High-level compliance statistics and percentages
-- Use Case: Executive dashboards, compliance metrics, KPI reporting
-- Includes: Patch counts, compliance percentages, health distribution

SELECT m2.col1 AS "Customer Name",
       COUNT(DISTINCT r.resource_id) AS "Total Systems",
       COUNT(CASE WHEN a.status_id = 202 THEN 1 END) AS "Missing Patches",
       COUNT(CASE WHEN a.status_id != 202 THEN 1 END) AS "Installed Patches",
       ROUND(
         (COUNT(CASE WHEN a.status_id != 202 THEN 1 END) * 100.0) / 
         NULLIF(COUNT(*), 0), 2
       ) AS "Compliance Percentage",
       COUNT(CASE WHEN p2.health_status = 3 THEN 1 END) AS "Highly Vulnerable Systems",
       COUNT(CASE WHEN p2.health_status = 2 THEN 1 END) AS "Vulnerable Systems",
       COUNT(CASE WHEN p2.health_status = 1 THEN 1 END) AS "Healthy Systems",
       COUNT(CASE WHEN p3.noreboot = 2 AND a.status_id = 202 THEN 1 END) AS "Reboot Required Patches"
FROM   resource R
       INNER JOIN managedcomputer M ON m.resource_id = r.resource_id
       INNER JOIN affectedpatchstatus A ON a.resource_id = m.resource_id
       INNER JOIN patch P3 ON p3.patchid = a.patch_id
       LEFT JOIN pmreshealthstatus P2 ON p2.resource_id = m.resource_id
       LEFT JOIN managedcomputercustomfields M2 ON m2.resource_id = m.resource_id
WHERE  m.managed_status = 61 