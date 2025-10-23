-- =============================================================================
-- EXTENDED PPM REPORT
-- =============================================================================
-- Purpose: Comprehensive patch management report with detailed system and patch information
-- Use Case: Monthly compliance reports, security assessments, detailed inventories
-- Includes: Customer info, system details, patch status, health metrics, installation data
--
-- Requirements:
-- - Custom fields configured (col1-col8)
-- - Health status monitoring enabled
-- - Patch management fully deployed
--
-- Performance: Moderate - suitable for systems up to 10,000 endpoints
-- Output: Detailed patch compliance report with system context

SELECT m2.col1               AS "Customer Name",
       m2.col2               AS "CI ID",
       m2.col3               AS "Server Description",
       m2.col4               AS "IP Address Local",
       m2.col5               AS "Group 1",
       m2.col6               AS "Group 2",
       m2.col7               AS "Group 3",
       m2.col8               AS "Group 4",
       r.NAME                AS "Computer Name",
       p.os_name             AS "Operating System",
       p.service_pack        AS "Service Pack",
       r.domain_netbios_name AS "Domain",
       CASE
         WHEN p2.health_status = 3 THEN 'Highly Vulnerable'
         WHEN p2.health_status = 2 THEN 'Vulnerable'
         WHEN p2.health_status = 1 THEN 'Healthy'
         ELSE 'Health Not Available'
       END                   AS "Health",
       p3.patchid            AS "Patch ID",
       p3.bulletinid         AS "Bulletin ID",
       pd.description        AS "Patch Description",
       CASE
         WHEN a.status_id = 202 THEN 'Missing'
         ELSE 'Installed'
       END                   AS "Patch Status",
       p5.platform_name      AS "Platform",
       CASE
         WHEN p3.noreboot = 2 THEN 'Required'
         WHEN p3.noreboot = 1 THEN 'Not Required'
         WHEN p3.noreboot = 0 THEN 'May Require'
       END                   AS "Reboot",
       LONG_TO_DATE(i.installed_time) AS "Installation Date",
       I18n_translate(i.remarks, i.remarks_args) AS "Installation Remarks",
       CASE
         WHEN p3.uninstall_status = 1 THEN 'Supported'
         ELSE 'Not Supported'
       END                   AS "Patch Uninstallation"
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