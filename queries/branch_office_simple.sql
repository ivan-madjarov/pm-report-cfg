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

SELECT COUNT(m.resource_id) AS "Computer Count",
       b2.branch_office_name AS "Branch Office Name",
       CASE 
         WHEN b2.has_masteragent = 1 THEN 'Yes' 
         ELSE 'No' 
       END AS "Has Master Agent"
FROM   resource r 
       INNER JOIN managedcomputer m 
               ON m.resource_id = r.resource_id 
       INNER JOIN branchmemberresourcerel b 
               ON b.resource_id = m.resource_id 
       INNER JOIN branchofficedetails b2 
               ON b2.branch_office_id = b.branch_office_id
WHERE  m.managed_status = 61 