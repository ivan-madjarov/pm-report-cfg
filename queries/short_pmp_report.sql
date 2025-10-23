-- =============================================================================
-- SHORT PPM REPORT
-- =============================================================================
-- Purpose: Condensed patch information for quick assessments and executive summaries
-- Use Case: High-level overviews, mobile-friendly reports, quick compliance checks
-- Includes: Essential patch data, customer identification, basic system info
--
-- Requirements:
-- - Custom fields configured (col1-col4 minimum)
-- - Basic patch management deployment
--
-- Performance: Fast - suitable for large environments
-- Output: Essential patch compliance information

SELECT m2.col1               AS "Customer Name",
       m2.col2               AS "CI ID",
       m2.col3               AS "Server Description",
       m2.col4               AS "IP Address Local",
       r.NAME                AS "Computer Name",
       p.os_name             AS "Operating System",
       p3.bulletinid         AS "Bulletin ID",
       pd.description        AS "Patch Description",
       CASE
         WHEN a.status_id = 202 THEN 'Missing'
         ELSE 'Installed'
       END                   AS "Patch Status"
FROM   resource R
       INNER JOIN managedcomputer M
               ON m.resource_id = r.resource_id
       INNER JOIN patchmgmtosinfo P
               ON p.resource_id = m.resource_id
       INNER JOIN affectedpatchstatus A
               ON a.resource_id = m.resource_id
       INNER JOIN patch P3
               ON p3.patchid = a.patch_id
       INNER JOIN patchdetails Pd
               ON pd.patchid = a.patch_id
       INNER JOIN pmpatchtype P4
               ON p4.patchid = pd.patchid
       INNER JOIN platform P5
               ON p5.platform_id = p4.platform_id
       LEFT JOIN pmreshealthstatus P2
              ON p2.resource_id = m.resource_id
       LEFT JOIN installpatchstatus I
              ON i.resource_id = a.resource_id
                 AND i.patch_id = a.patch_id
       LEFT JOIN managedcomputercustomfields M2
              ON m2.resource_id = m.resource_id
WHERE  m.managed_status = 61 