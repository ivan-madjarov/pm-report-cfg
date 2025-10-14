-- =============================================================================
-- MANAGED DEVICES DETAILS
-- =============================================================================
-- Purpose: Complete device inventory and management status information
-- Use Case: Asset management, agent health monitoring, system lifecycle tracking
-- Includes: Agent details, system info, branch associations, live status
--
-- Requirements:
-- - Full PMP deployment with agents
-- - Optional: Branch office configuration
-- - Optional: Live status monitoring enabled
--
-- Performance: Resource intensive - consider filtering for large environments
-- Output: Comprehensive device inventory with management details

SELECT resource.customer_id AS "Customer ID",
       LONG_TO_DATE(resource.db_added_time) AS "Database Added Date",
       LONG_TO_DATE(resource.db_updated_time) AS "Database Updated Date",
       resource.domain_netbios_name AS "Domain",
       CASE 
         WHEN resource.is_inactive = 1 THEN 'Inactive' 
         ELSE 'Active' 
       END AS "Resource Status",
       resource."name" AS "Computer Name",
       resource.resource_id AS "Resource ID",
       resource.resource_type AS "Resource Type",
       managedcomputer.agent_installed_dir AS "Agent Install Directory",
       LONG_TO_DATE(managedcomputer.added_time) AS "Added to Management",
       LONG_TO_DATE(managedcomputer.agent_executed_on) AS "Agent Last Executed",
       LONG_TO_DATE(managedcomputer.agent_installed_on) AS "Agent Installed Date",
       CASE 
         WHEN managedcomputer.agent_status = 1 THEN 'Active'
         WHEN managedcomputer.agent_status = 0 THEN 'Inactive'
         ELSE 'Unknown'
       END AS "Agent Status",
       LONG_TO_DATE(managedcomputer.agent_uninstalled_on) AS "Agent Uninstalled Date",
       LONG_TO_DATE(managedcomputer.agent_upgraded_on) AS "Agent Upgraded Date",
       managedcomputer.agent_version AS "Agent Version",
       managedcomputer.fqdn_name AS "FQDN",
       managedcomputer.full_name AS "Full Name",
       managedcomputer.guid AS "GUID",
       CASE 
         WHEN managedcomputer.installation_status = 1 THEN 'Installed'
         WHEN managedcomputer.installation_status = 0 THEN 'Not Installed'
         ELSE 'Unknown'
       END AS "Installation Status",
       CASE 
         WHEN managedcomputer.managed_status = 61 THEN 'Managed'
         ELSE 'Not Managed'
       END AS "Management Status",
       LONG_TO_DATE(managedcomputer.modified_time) AS "Last Modified",
       managedcomputer.remarks AS "Remarks",
       LONG_TO_DATE(managedcomputer.status_updated_time) AS "Status Updated",
       managedcomputer.uuid AS "UUID",
       resource.unique_value AS "Unique Value",
       c.os_name AS "Operating System",
       c.os_version AS "OS Version",
       c.service_pack AS "Service Pack",
       c.os_platform AS "OS Platform",
       CASE 
         WHEN c.is_server_os = 1 THEN 'Server' 
         ELSE 'Workstation' 
       END AS "OS Type",
       LONG_TO_DATE(c.db_updated_time) AS "OS Info Updated",
       COALESCE(b2.branch_office_id, 0) AS "Branch Office ID",
       COALESCE(b2.branch_office_name, 'Unassigned') AS "Branch Office Name",
       CASE 
         WHEN r.status_update_time IS NOT NULL 
         THEN LONG_TO_DATE(r.status_update_time) 
         ELSE NULL 
       END AS "Live Status Updated",
       COALESCE(r.status, 'Unknown') AS "Live Status"
FROM   resource 
       INNER JOIN managedcomputer 
               ON resource.resource_id = managedcomputer.resource_id
       LEFT JOIN computer c 
              ON c.resource_id = managedcomputer.resource_id 
       LEFT JOIN branchmemberresourcerel b 
              ON b.resource_id = managedcomputer.resource_id 
       LEFT JOIN branchofficedetails b2 
              ON b2.branch_office_id = b.branch_office_id 
       LEFT JOIN resourcelivestatus r 
              ON r.resource_id = managedcomputer.resource_id 
WHERE  managedcomputer.managed_status = 61
ORDER BY resource."name";