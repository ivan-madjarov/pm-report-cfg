-- =============================================================================
-- BRANCH OFFICE DETAILS - SIMPLE COUNT
-- =============================================================================
-- Purpose: Basic computer count per branch office with master agent status
-- Use Case: Quick branch office inventory, agent deployment verification
-- Includes: Computer counts, branch office names, master agent presence
--
-- Requirements:
-- - Branch office configuration in PMP
-- - Computers assigned to branch offices
--
-- Performance: Very Fast
-- Output: Summary of branch office computer distribution

SELECT COUNT(m.resource_id) AS "Count",
       b2.branch_office_name AS "Branch Office Name",
       b2.has_masteragent AS "Has Master Agent"
FROM   resource r 
       INNER JOIN managedcomputer m 
               ON m.resource_id = r.resource_id 
       INNER JOIN branchmemberresourcerel b 
               ON b.resource_id = m.resource_id 
       INNER JOIN branchofficedetails b2 
               ON b2.branch_office_id = b.branch_office_id
GROUP BY b2.branch_office_name, b2.has_masteragent