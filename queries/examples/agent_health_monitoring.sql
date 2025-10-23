-- =============================================================================
-- AGENT HEALTH MONITORING
-- =============================================================================
-- Purpose: Monitor agent connectivity and health across managed systems
-- Use Case: Infrastructure monitoring, agent troubleshooting, connectivity issues
-- Includes: Agent status, last contact times, version information

SELECT r.NAME AS "Computer Name",
       m2.col1 AS "Customer Name",
       managedcomputer.agent_status AS "Agent Status",
       managedcomputer.agent_version AS "Agent Version",
       LONG_TO_DATE(managedcomputer.agent_executed_on) AS "Last Contact",
       managedcomputer.agent_executed_on AS "Agent Executed On Timestamp",
       p.os_name AS "Operating System",
       r.domain_netbios_name AS "Domain",
       b2.branch_office_name AS "Branch Office",
       rl.status AS "Live Status"
FROM   resource r
       INNER JOIN managedcomputer ON r.resource_id = managedcomputer.resource_id
       LEFT JOIN patchmgmtosinfo p ON p.resource_id = managedcomputer.resource_id
       LEFT JOIN managedcomputercustomfields m2 ON m2.resource_id = managedcomputer.resource_id
       LEFT JOIN branchmemberresourcerel b ON b.resource_id = managedcomputer.resource_id
       LEFT JOIN branchofficedetails b2 ON b2.branch_office_id = b.branch_office_id
       LEFT JOIN resourcelivestatus rl ON rl.resource_id = managedcomputer.resource_id
WHERE  managedcomputer.managed_status = 61 