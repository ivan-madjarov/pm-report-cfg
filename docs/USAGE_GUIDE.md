# Query Usage Guide

This document provides detailed instructions for using the SQL queries in this repository with ManageEngine Patch Manager Plus.

## Getting Started

### Prerequisites
1. ManageEngine Patch Manager Plus (On-premises installation)
2. Administrative access to PMP web console
3. Database query permissions
4. Understanding of your organization's PMP configuration

### Accessing Query Reports
1. Log into Patch Manager Plus web console
2. Navigate to **Reports** → **Custom Report**
3. Click **New Query Report** button
4. The Query Report creation interface will open

## Using the Queries

### 1. Extended PPM Report

**Purpose**: Comprehensive patch management reporting with detailed system and patch information.

**Use Cases**:
- Monthly patch compliance reports
- Security vulnerability assessments
- Detailed system inventory with patch status
- Customer-specific reporting with CI integration

**Steps to Use**:
1. Copy the Extended PPM Report query from `queries/extended_pmp_report.sql` (or legacy `queries/archive/SQL Query Reports.sql`)
2. Paste into the SQL Query field
3. Configure report name: "Extended PPM Report - [Date]"
4. Set description: "Comprehensive patch status report with system details"
5. Click **Generate Report**
6. Review results and save for future use

**Output Columns**:
- Customer information and CI details
- System identification (Computer Name, IP, Groups)
- Operating system details
- Patch information (ID, Description, Status)
- Health assessment
- Reboot requirements
- Installation details

### 2. Short PPM Report

**Purpose**: Condensed patch information for quick assessments.

**Use Cases**:
- Executive summaries
- Quick compliance checks
- Mobile-friendly reports
- High-level patch status overview

**Steps to Use**:
1. Copy the Short PPM Report query
2. Create new Query Report with descriptive name
3. Generate and review results
4. Export to CSV for further processing if needed

### 3. Branch Office Details

**Purpose**: Managing distributed environments and remote locations.

**Use Cases**:
- Branch office management
- Agent deployment verification
- Replication policy monitoring
- Remote site inventory

**Available Variants**:
- **Simple Count**: Basic computer count per branch office
- **Detailed**: Includes replication policies and configuration

### 4. Managed Devices Details

**Purpose**: Complete device inventory and management status.

**Use Cases**:
- Asset management integration
- Agent health monitoring
- System lifecycle tracking
- Troubleshooting connectivity issues

## Customizing Queries

### Adding Filters

**Filter by Date Range**:
```sql
WHERE m.managed_status = 61 
  AND LONG_TO_DATE(resource.db_added_time) >= '2024-01-01'
  AND LONG_TO_DATE(resource.db_added_time) <= '2024-12-31'
```

**Filter by Customer**:
```sql
WHERE m.managed_status = 61 
  AND m2.col1 = 'Customer Name Here'
```

**Filter by Patch Severity**:
```sql
WHERE m.managed_status = 61 
  AND p2.health_status = 3  -- Highly Vulnerable only
```

**Filter by Operating System**:
```sql
WHERE m.managed_status = 61 
  AND p.os_name LIKE '%Windows Server%'
```

### Sorting Results

**Sort by Health Status**:
```sql
ORDER BY p2.health_status DESC, r.name ASC
```

**Sort by Patch Count**:
```sql
ORDER BY COUNT(p3.patchid) DESC
```

**Sort by Installation Date**:
```sql
ORDER BY LONG_TO_DATE(i.installed_time) DESC
```

### Adding Aggregation

**Count Missing Patches per System**:
```sql
SELECT r.name, COUNT(*) as missing_patches
FROM resource r
-- ... joins ...
WHERE a.status_id = 202
GROUP BY r.name
```

## Performance Considerations

### Query Optimization Tips

1. **Use Appropriate Indexes**: Always include `resource_id` in WHERE clauses
2. **Limit Result Sets**: Add specific filters to reduce data volume
3. **Avoid SELECT ***: Only select columns you need
4. **Use INNER JOINs**: When you know relationships exist
5. **Filter Early**: Apply WHERE conditions before JOINs when possible

### Large Environment Considerations

For environments with >10,000 managed systems:

1. **Batch Processing**: Run reports for specific groups or date ranges
2. **Scheduled Reports**: Use PMP's scheduling features for large queries
3. **Pagination**: Add LIMIT clauses for initial testing
4. **Monitoring**: Monitor query execution time and database impact

## Report Scheduling

### Automated Reports
1. Create and save your customized query
2. Navigate to **Reports** → **Scheduled Reports**
3. Add new scheduled report
4. Select your saved Query Report
5. Configure frequency (Daily, Weekly, Monthly)
6. Set email recipients for automated delivery
7. Choose export format (PDF, CSV, XLS)

### Best Practices for Scheduling
- Schedule resource-intensive reports during off-peak hours
- Use CSV format for automated processing
- Include date ranges in report names
- Monitor email delivery and report generation logs

## Exporting and Integration

### Export Formats
- **CSV**: Best for data processing and integration
- **PDF**: Ideal for distribution and archival
- **XLS**: Good for manual analysis in Excel

### Integration Options

**CSV Processing**:
```bash
# Example: Process exported CSV with command-line tools
cat report.csv | grep "Missing" | wc -l  # Count missing patches
```

**Database Integration**:
- Import CSV into external databases
- Use ETL tools for data warehouse integration
- Create automated dashboards with BI tools

## Troubleshooting

### Common Issues

**Query Timeout**:
- Reduce result set with additional WHERE clauses
- Break large queries into smaller chunks
- Contact DBA for query optimization

**No Results Returned**:
- Verify managed systems exist (`managed_status = 61`)
- Check date filters and ranges
- Ensure custom fields are configured

**Column Not Found Errors**:
- Verify PMP version compatibility
- Check if custom fields are properly configured
- Review database schema changes

**Performance Issues**:
- Add appropriate indexes
- Reduce JOIN complexity
- Implement query caching if available

### Getting Help

1. **Test Queries**: Always test in development environment first
2. **Check Logs**: Review PMP application logs for errors
3. **Database Documentation**: Consult PMP database schema documentation
4. **Support Resources**: Contact ManageEngine support for database-related issues

## Security Best Practices

1. **Access Control**: Limit Query Report access to authorized personnel
2. **Data Privacy**: Be mindful of sensitive information in reports
3. **Audit Trail**: Maintain logs of who runs which reports
4. **Export Security**: Secure exported files containing system information
5. **Database Credentials**: Protect database access credentials

## Advanced Usage

### Creating Views
For frequently used query patterns, consider creating database views:

```sql
CREATE VIEW v_managed_systems AS
SELECT r.resource_id, r.name, m.managed_status
FROM resource r
INNER JOIN managedcomputer m ON r.resource_id = m.resource_id
WHERE m.managed_status = 61;
```

### Stored Procedures
For complex reporting logic, stored procedures can improve performance:

```sql
CREATE PROCEDURE sp_patch_compliance_report(@start_date DATE, @end_date DATE)
AS
-- Complex reporting logic here
```

### Report Templates
Create standardized report templates for consistency:
- Monthly Security Report Template
- Quarterly Compliance Report Template
- Annual Asset Review Template

These templates ensure consistent formatting and data inclusion across reports.