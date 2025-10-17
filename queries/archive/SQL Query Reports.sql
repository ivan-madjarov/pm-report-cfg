/*
 * Patch Manager Plus Custom Query Reports
 * 
 * Repository: pm-report-cfg
 * Purpose: Collection of SQL queries for ManageEngine Patch Manager Plus custom reporting
 * 
 * Note: These queries are designed for on-premises PMP installations only.
 *       Query Reports are not available for PMP Cloud deployments.
 * 
 * Usage: Copy and paste desired queries into PMP Reports -> Custom Report -> New Query Report
 */

-- =============================================================================
-- EXTENDED PPM REPORT
-- =============================================================================
-- Purpose: Comprehensive patch management report with detailed system and patch information
-- Use Case: Monthly compliance reports, security assessments, detailed inventories
-- Includes: Customer info, system details, patch status, health metrics, installation data

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
         ELSE 'Health Not Avaialble'
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
       --- no longer available? Long_to_date(i.installed_time, "deployed date"),
       I18n_translate(i.remarks, i.remarks_args),
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




-- =============================================================================
-- STANDARD PPM REPORT
-- =============================================================================
-- Purpose: Condensed patch information for quick assessments and executive summaries
-- Use Case: High-level overviews, mobile-friendly reports, quick compliance checks
-- Includes: Essential patch data, customer identification, basic system info

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



-- =============================================================================
-- BRANCH OFFICE DETAILS - SIMPLE COUNT
-- =============================================================================
-- Purpose: Basic computer count per branch office with master agent status
-- Use Case: Quick branch office inventory, agent deployment verification
-- Includes: Computer counts, branch office names, master agent presence

select count(m.resource_id) as count,b2.branch_office_name,b2.has_masteragent from resource r 
inner join managedcomputer m on m.resource_id = r.resource_id 
inner join branchmemberresourcerel b on b.resource_id = m.resource_id 
inner join branchofficedetails b2 on b2.branch_office_id = b.branch_office_id
group by b2.branch_office_name,b2.has_masteragent



-- =============================================================================
-- BRANCH OFFICE DETAILS - COMPREHENSIVE
-- =============================================================================
-- Purpose: Detailed branch office information including replication policies
-- Use Case: Branch office management, policy monitoring, configuration audits
-- Includes: Computer counts, replication settings, policy details

select
	branchofficedetails.branch_office_name,
	branchofficedetails.has_masteragent,
	Mg_count.computer_count,
	r.policy_name,
	r.polling_interval,
	r.data_transfer_rate,
	r.data_transfer_rate_lan,
	r.rep_days_of_week,
	r.rep_window_start_time,
	r.rep_window_end_time
from
	branchofficedetails
left join branchmemberresourcerel on
	branchmemberresourcerel.branch_office_id = branchofficedetails.branch_office_id
left join policytobranchofficerel p on
	p.branch_office_id = branchofficedetails.branch_office_id
left join replicationpolicydetails r on
	r.policy_id = p.policy_id
left join (
	select
		branchofficedetails.branch_office_name,
		branchofficedetails.branch_office_id,
		count(branchmemberresourcerel.resource_id) as "computer_count"
	from
		branchofficedetails
	left join branchmemberresourcerel on
		branchmemberresourcerel.branch_office_id = branchofficedetails.branch_office_id
	group by
		branchofficedetails.branch_office_name,
		branchofficedetails.branch_office_id) Mg_count on
	Mg_count.branch_office_id = branchofficedetails.branch_office_id


-- =============================================================================
-- MANAGED DEVICES DETAILS
-- =============================================================================
-- Purpose: Complete device inventory and management status information
-- Use Case: Asset management, agent health monitoring, system lifecycle tracking
-- Includes: Agent details, system info, branch associations, live status

Select 
	resource.customer_id,
	LONG_TO_DATE (resource.db_added_time),
	LONG_TO_DATE (resource.db_updated_time),
	resource.domain_netbios_name,
	resource.is_inactive,
	resource."name",
	resource.resource_id,
	resource.resource_type,
	managedcomputer.agent_installed_dir,
	LONG_TO_DATE (managedcomputer.added_time),
	LONG_TO_DATE (managedcomputer.agent_executed_on),
	LONG_TO_DATE (managedcomputer.agent_installed_on),
	managedcomputer.agent_status,
	LONG_TO_DATE (managedcomputer.agent_uninstalled_on),
	LONG_TO_DATE (managedcomputer.agent_upgraded_on),
	managedcomputer.agent_version,
	managedcomputer.fqdn_name,
	managedcomputer.full_name,
	managedcomputer.guid,
	managedcomputer.installation_status,
	managedcomputer.managed_status,
	LONG_TO_DATE (managedcomputer.modified_time),
	managedcomputer.remarks,
	managedcomputer.remarks_args,
	LONG_TO_DATE (managedcomputer.status_updated_time),
	managedcomputer.uuid,
	resource.unique_value,
	c.os_name,
	c.os_version,
	c.service_pack,
	c.os_platform,
	c.is_server_os,
	c.db_updated_time,
	b2.branch_office_id,
	b2.branch_office_name,
	r.status_update_time as live_status_update,
	r.status
from resource 
	inner join managedcomputer on resource.resource_id = managedcomputer.resource_id
	left join computer c on c.resource_id = managedcomputer.resource_id 
	left join branchmemberresourcerel b on b.resource_id = managedcomputer.resource_id 
	left join branchofficedetails b2 on b2.branch_office_id = b.branch_office_id 
	left join resourcelivestatus r on r.resource_id = managedcomputer.resource_id 