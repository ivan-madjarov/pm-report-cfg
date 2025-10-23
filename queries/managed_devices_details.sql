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
       LONG_TO_DATE(resource.db_added_time) AS "DB Added Time",
       LONG_TO_DATE(resource.db_updated_time) AS "DB Updated Time",
       resource.domain_netbios_name AS "Domain",
       resource.is_inactive AS "Is Inactive",
       resource."name" AS "Name",
       resource.resource_id AS "Resource ID",
       resource.resource_type AS "Resource Type",
       managedcomputer.agent_installed_dir AS "Agent Installed Dir",
       LONG_TO_DATE(managedcomputer.added_time) AS "Added Time",
       LONG_TO_DATE(managedcomputer.agent_executed_on) AS "Agent Executed On",
       LONG_TO_DATE(managedcomputer.agent_installed_on) AS "Agent Installed On",
       managedcomputer.agent_status AS "Agent Status",
       LONG_TO_DATE(managedcomputer.agent_uninstalled_on) AS "Agent Uninstalled On",
       LONG_TO_DATE(managedcomputer.agent_upgraded_on) AS "Agent Upgraded On",
       managedcomputer.agent_version AS "Agent Version",
       managedcomputer.fqdn_name AS "FQDN Name",
       managedcomputer.full_name AS "Full Name",
       managedcomputer.guid AS "GUID",
       managedcomputer.installation_status AS "Installation Status",
       managedcomputer.managed_status AS "Managed Status",
       LONG_TO_DATE(managedcomputer.modified_time) AS "Modified Time",
       managedcomputer.remarks AS "Remarks",
       managedcomputer.remarks_args AS "Remarks Args",
       LONG_TO_DATE(managedcomputer.status_updated_time) AS "Status Updated Time",
       managedcomputer.uuid AS "UUID",
       resource.unique_value AS "Unique Value",
       c.os_name AS "OS Name",
       c.os_version AS "OS Version",
       c.service_pack AS "Service Pack",
       c.os_platform AS "OS Platform",
       c.is_server_os AS "Is Server OS",
       c.db_updated_time AS "Computer DB Updated Time",
       b2.branch_office_id AS "Branch Office ID",
       b2.branch_office_name AS "Branch Office Name",
       r.status_update_time AS "Live Status Update Time",
       r.status AS "Status"
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