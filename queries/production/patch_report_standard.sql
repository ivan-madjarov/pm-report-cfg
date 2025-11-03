-- =============================================================================
-- SEVERITY-FILTERED MISSING PATCHES REPORT
-- =============================================================================
-- Purpose: List missing patches (A.status_id = 202) with bulletin severity text
-- Usage: Run this query to get a focused view of missing critical/important patches
-- Requirements: managed computer custom fields (col1-col3) available
-- Filters: Managed status IN (61, 65); only patches with affectedpatchstatus.status_id = 202
--
SELECT
        M2.col1           AS "Customer Name",
        M2.col2           AS "CI ID",
        R.name            AS "Computer Name",
        M2.col3           AS "Server Description",
        P.os_name         AS "Operating System",
        P3.bulletinid     AS "Bulletin ID",
        CASE
                WHEN P3.severityid = 1 THEN 'Critical'
                WHEN P3.severityid = 2 THEN 'Important'
                WHEN P3.severityid = 3 THEN 'Moderate'
                WHEN P3.severityid = 4 THEN 'Low'
                ELSE 'Unspecified'
        END               AS "Severity",
        CASE
                WHEN A.status_id = 202 THEN 'Missing'
                ELSE 'Installed'
        END               AS "Patch Status",
        PD.description    AS "Patch Description"
FROM resource R
INNER JOIN managedcomputer M
        ON M.resource_id = R.resource_id
INNER JOIN patchmgmtosinfo P
        ON P.resource_id = M.resource_id
INNER JOIN affectedpatchstatus A
        ON A.resource_id = M.resource_id
INNER JOIN patch P3
        ON P3.patchid = A.patch_id
INNER JOIN patchdetails PD
        ON PD.patchid = A.patch_id
INNER JOIN pmpatchtype P4
        ON P4.patchid = PD.patchid
INNER JOIN platform P5
        ON P5.platform_id = P4.platform_id
LEFT JOIN managedcomputercustomfields M2
        ON M2.resource_id = M.resource_id
WHERE M.managed_status IN (61, 65)
        AND A.status_id = 202;