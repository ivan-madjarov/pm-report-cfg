-- =============================================================================
-- BRANCH / RESOURCE RELATION EXAMPLES
-- =============================================================================
-- Purpose: Small example queries demonstrating branch-to-resource joins
-- Use Case: Quick troubleshooting, exploring relationships between branch
--         offices, domains and resources
-- Notes: These are simple examples for inspection and learning. Add filters
--        (WHERE) for production use to limit result sets.

-- Query 1: Branch to OS and Resource relation
select * from BranchToOsRel b1 
left join branchtodomainrel b on b1.branch_office_id = b.branch_office_id 
left join resource r on b.resource_id = r.resource_id;

-- Query 2: Resource to product (PMWinOS) mapping for a specific resource
select * from resource r 
left join resourcetomssoftware r1 on r.resource_id = r1.resource_id 
left join pmwinos p on r1.productid = p.productid 
where r.resource_id = 1504;
