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
       branchofficedetails.has_masteragent AS "Has Master Agent",
       Mg_count.computer_count AS "Computer Count",
       r.policy_name AS "Replication Policy",
       r.polling_interval AS "Polling Interval",
       r.data_transfer_rate AS "Data Transfer Rate",
       r.data_transfer_rate_lan AS "Data Transfer Rate LAN",
       r.rep_days_of_week AS "Replication Days",
       r.rep_window_start_time AS "Replication Window Start",
       r.rep_window_end_time AS "Replication Window End"
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
         GROUP BY branchofficedetails.branch_office_name, branchofficedetails.branch_office_id
       ) Mg_count 
              ON Mg_count.branch_office_id = branchofficedetails.branch_office_id 