# Query Index

This document provides a comprehensive index of all available SQL queries in the repository.

## Core Reports (queries/)

### 1. Extended PPM Report
**File:** `queries/extended_pmp_report.sql`  
**Purpose:** Comprehensive patch management report with detailed system and patch information  
**Use Case:** Monthly compliance reports, security assessments, detailed inventories  
**Performance:** Moderate - suitable for systems up to 10,000 endpoints  
**Requirements:** Custom fields configured, health status monitoring enabled  

**Key Fields:**
- Customer information and CI details
- Complete system identification
- Patch status and health metrics
- Installation history and remarks
- Reboot requirements

### 2. Short PPM Report
**File:** `queries/short_pmp_report.sql`  
**Purpose:** Condensed patch information for quick assessments  
**Use Case:** Executive summaries, mobile reports, quick compliance checks  
**Performance:** Fast - suitable for large environments  
**Requirements:** Basic custom fields (col1-col4)  

**Key Fields:**
- Essential customer identification
- Basic system information
- Patch status summary

### 3. Branch Office - Simple Count
**File:** `queries/branch_office_simple.sql`  
**Purpose:** Basic computer count per branch office  
**Use Case:** Quick inventory, agent deployment verification  
**Performance:** Very Fast  
**Requirements:** Branch office configuration  

**Key Fields:**
- Computer count per branch
- Master agent presence
- Branch office names

### 4. Branch Office - Comprehensive
**File:** `queries/branch_office_detailed.sql`  
**Purpose:** Detailed branch office information with replication policies  
**Use Case:** Branch management, policy monitoring, configuration audits  
**Performance:** Moderate  
**Requirements:** Branch offices and replication policies configured  

**Key Fields:**
- Complete replication policy details
- Bandwidth and scheduling configuration
- Computer distribution analysis

### 5. Managed Devices Details
**File:** `queries/managed_devices_details.sql`  
**Purpose:** Complete device inventory and management status  
**Use Case:** Asset management, agent health monitoring, lifecycle tracking  
**Performance:** Resource intensive - consider filtering for large environments  
**Requirements:** Full PMP deployment with agents  

**Key Fields:**
- Complete agent lifecycle information
- System specifications and status
- Branch office associations
- Live connectivity status

## Example Reports (examples/)

### 1. Security Vulnerability Report
**File:** `examples/security_vulnerability_report.sql`  
**Purpose:** Focus on security-related patches and vulnerabilities  
**Use Case:** Security team reporting, vulnerability management, compliance  
**Performance:** Moderate  
**Special Notes:** Filters for security bulletins and critical patches only  

**Key Fields:**
- Security health assessment
- Missing critical patches
- Vulnerability descriptions
- Protection status

### 2. Patch Compliance Summary  
**File:** `examples/patch_compliance_summary.sql`  
**Purpose:** High-level compliance statistics and percentages  
**Use Case:** Executive dashboards, compliance metrics, KPI reporting  
**Performance:** Fast aggregated query  
**Output:** Statistical summary by customer  

**Key Fields:**
- Compliance percentages
- System health distribution
- Patch count summaries
- Reboot requirement statistics

### 3. Agent Health Monitoring
**File:** `examples/agent_health_monitoring.sql`  
**Purpose:** Monitor agent connectivity and health  
**Use Case:** Infrastructure monitoring, troubleshooting, connectivity issues  
**Performance:** Fast  
**Special Notes:** Includes contact freshness analysis  

**Key Fields:**
- Agent online/offline status
- Last contact timestamps
- Version information
- Live connectivity status

### 4. Branch & Resource Relationship Examples
**File:** `examples/branch_and_resource_examples.sql`
**Purpose:** Small examples showing joins between branch-related tables and resources
**Use Case:** Exploration, troubleshooting, and quick checks of branch-resource mappings
**Performance:** Very fast (small tables), add WHERE filters for larger datasets

## Query Selection Guide

### By Use Case

**Security & Compliance:**
- `extended_pmp_report.sql` - Comprehensive compliance reporting
- `security_vulnerability_report.sql` - Security-focused analysis
- `patch_compliance_summary.sql` - Compliance metrics and KPIs

**Operations & Monitoring:**
- `agent_health_monitoring.sql` - Infrastructure health
- `managed_devices_details.sql` - Complete asset inventory
- `branch_office_simple.sql` - Quick distributed environment check

**Executive Reporting:**
- `short_pmp_report.sql` - Executive summaries
- `patch_compliance_summary.sql` - High-level metrics
- `branch_office_detailed.sql` - Distributed environment overview

**Troubleshooting & Analysis:**
- `managed_devices_details.sql` - Detailed system analysis
- `agent_health_monitoring.sql` - Connectivity troubleshooting
- `branch_office_detailed.sql` - Branch office configuration review

### By Performance Requirements

**High Performance (Large Environments >10K endpoints):**
- `short_pmp_report.sql`
- `patch_compliance_summary.sql`
- `branch_office_simple.sql`
- `agent_health_monitoring.sql`

**Moderate Performance (Medium Environments 1K-10K endpoints):**
- `extended_pmp_report.sql`
- `security_vulnerability_report.sql`
- `branch_office_detailed.sql`

**Resource Intensive (Small Environments <1K endpoints or filtered queries):**
- `managed_devices_details.sql` (consider adding WHERE filters)

### By Data Requirements

**Requires Custom Fields Configuration:**
- `extended_pmp_report.sql` (col1-col8)
- `short_pmp_report.sql` (col1-col4)
- `security_vulnerability_report.sql` (col1 minimum)

**Requires Branch Office Setup:**
- `branch_office_simple.sql`
- `branch_office_detailed.sql`
- `managed_devices_details.sql` (optional branch info)

**Requires Health Status Monitoring:**
- `extended_pmp_report.sql`
- `security_vulnerability_report.sql`
- `patch_compliance_summary.sql`

**Requires Live Status Monitoring:**
- `agent_health_monitoring.sql`
- `managed_devices_details.sql` (optional live status)

## Customization Examples

### Adding Date Filters
```sql
-- Add to any query WHERE clause
AND LONG_TO_DATE(resource.db_updated_time) >= '2024-01-01'
```

### Filtering by Customer
```sql  
-- Add to queries with custom fields
AND m2.col1 = 'Specific Customer Name'
```

### Limiting Results for Testing
```sql
-- Add at end of query
LIMIT 100  -- PostgreSQL/MySQL
-- OR
SELECT TOP 100 ...  -- SQL Server
```

### Performance Optimization
```sql
-- Add specific resource filters
AND r.resource_id IN (SELECT resource_id FROM your_filter_table)
```

## Getting Started

1. **First Time Users:** Start with `short_pmp_report.sql`
2. **Security Focus:** Use `security_vulnerability_report.sql`
3. **Complete Analysis:** Progress to `extended_pmp_report.sql`
4. **Branch Offices:** Begin with `branch_office_simple.sql`
5. **Asset Management:** Use `managed_devices_details.sql`

## Support and Documentation

- **Setup Guide:** `docs/CONFIGURATION.md`
- **Usage Instructions:** `docs/USAGE_GUIDE.md`
- **Database Reference:** `docs/DATABASE_SCHEMA.md`
- **Main Documentation:** `README.md`