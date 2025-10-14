-- =============================================================================
-- AGENT HEALTH MONITORING
-- =============================================================================
-- Purpose: Monitor agent connectivity and health across managed systems
-- Use Case: Infrastructure monitoring, agent troubleshooting, connectivity issues
-- Includes: Agent status, last contact times, version information

SELECT r.NAME AS "Computer Name",
       m2.col1 AS "Customer Name",
       CASE 
         WHEN managedcomputer.agent_status = 1 THEN 'Online'
         WHEN managedcomputer.agent_status = 0 THEN 'Offline'
         ELSE 'Unknown'
       END AS "Agent Status",
       managedcomputer.agent_version AS "Agent Version",
       LONG_TO_DATE(managedcomputer.agent_executed_on) AS "Last Contact",
       CASE 
         WHEN managedcomputer.agent_executed_on > (EXTRACT(EPOCH FROM NOW()) - 86400) * 1000 
         THEN 'Recent (24h)'
         WHEN managedcomputer.agent_executed_on > (EXTRACT(EPOCH FROM NOW()) - 604800) * 1000 
         THEN 'This Week'
         WHEN managedcomputer.agent_executed_on > (EXTRACT(EPOCH FROM NOW()) - 2592000) * 1000 
         THEN 'This Month'
         ELSE 'Stale'
       END AS "Contact Freshness",
       p.os_name AS "Operating System",
       r.domain_netbios_name AS "Domain",
       COALESCE(b2.branch_office_name, 'Direct') AS "Connection Type",
       CASE 
         WHEN rl.status = 1 THEN 'Reachable'
         WHEN rl.status = 0 THEN 'Unreachable'
         ELSE 'Unknown'
       END AS "Live Status"
FROM   resource r
       INNER JOIN managedcomputer ON r.resource_id = managedcomputer.resource_id
       LEFT JOIN patchmgmtosinfo p ON p.resource_id = managedcomputer.resource_id
       LEFT JOIN managedcomputercustomfields m2 ON m2.resource_id = managedcomputer.resource_id
       LEFT JOIN branchmemberresourcerel b ON b.resource_id = managedcomputer.resource_id
       LEFT JOIN branchofficedetails b2 ON b2.branch_office_id = b.branch_office_id
       LEFT JOIN resourcelivestatus rl ON rl.resource_id = managedcomputer.resource_id
WHERE  managedcomputer.managed_status = 61
ORDER BY managedcomputer.agent_executed_on DESC;