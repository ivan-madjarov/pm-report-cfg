-- =============================================================================
-- BRANCH OFFICE DETAILS - COMPREHENSIVE
-- =============================================================================
-- Purpose: Detailed branch office information including replication policies
-- Use Case: Branch office management, policy monitoring, configuration audits
-- Includes: Computer counts, replication settings, policy details
--
-- Requirements:
-- - Branch office configuration
-- - Replication policies configured
-- - Policy assignments to branch offices
--
-- Performance: Moderate
-- Output: Complete branch office configuration and status

SELECT branchofficedetails.branch_office_name AS "Branch Office Name",
       CASE 
         WHEN branchofficedetails.has_masteragent = 1 THEN 'Yes' 
         ELSE 'No' 
       END AS "Has Master Agent",
       COALESCE(Mg_count.computer_count, 0) AS "Computer Count",
       r.policy_name AS "Replication Policy",
       r.polling_interval AS "Polling Interval (minutes)",
       r.data_transfer_rate AS "WAN Transfer Rate (KB/s)",
       r.data_transfer_rate_lan AS "LAN Transfer Rate (KB/s)",
       r.rep_days_of_week AS "Replication Days",
       CASE 
         WHEN r.rep_window_start_time IS NOT NULL 
         THEN CAST(r.rep_window_start_time AS VARCHAR)
         ELSE 'Not Set'
       END AS "Replication Start Time",
       CASE 
         WHEN r.rep_window_end_time IS NOT NULL 
         THEN CAST(r.rep_window_end_time AS VARCHAR)
         ELSE 'Not Set'
       END AS "Replication End Time"
FROM   branchofficedetails
       LEFT JOIN branchmemberresourcerel 
              ON branchmemberresourcerel.branch_office_id = branchofficedetails.branch_office_id
       LEFT JOIN policytobranchofficerel p 
              ON p.branch_office_id = branchofficedetails.branch_office_id
       LEFT JOIN replicationpolicydetails r 
              ON r.policy_id = p.policy_id
       LEFT JOIN (
         SELECT branchofficedetails.branch_office_name,
                branchofficedetails.branch_office_id,
                COUNT(branchmemberresourcerel.resource_id) AS "computer_count"
         FROM   branchofficedetails
                LEFT JOIN branchmemberresourcerel 
                       ON branchmemberresourcerel.branch_office_id = branchofficedetails.branch_office_id
                LEFT JOIN managedcomputer m
                       ON m.resource_id = branchmemberresourcerel.resource_id
         WHERE  m.managed_status = 61 OR m.managed_status IS NULL
         GROUP BY branchofficedetails.branch_office_name,
                  branchofficedetails.branch_office_id
       ) Mg_count 
              ON Mg_count.branch_office_id = branchofficedetails.branch_office_id
ORDER BY branchofficedetails.branch_office_name;