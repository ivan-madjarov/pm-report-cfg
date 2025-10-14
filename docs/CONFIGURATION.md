# Configuration Guide

This document provides configuration guidance for implementing Patch Manager Plus Custom Query Reports in your environment.

## Prerequisites Setup

### 1. Patch Manager Plus Configuration

**Required PMP Version**: 
- On-premises installation (any supported version)
- Query Reports feature is NOT available in PMP Cloud

**Database Access Requirements**:
- Read access to PMP database
- SQL query execution permissions
- Connection to underlying database (PostgreSQL, MSSQL, or MySQL)

### 2. Custom Fields Configuration

Before using the Extended and Short PPM reports, configure custom fields in PMP:

1. Navigate to **Admin** → **Custom Fields** → **Computer Custom Fields**
2. Configure the following fields:

| Field | Column | Recommended Name | Purpose |
|-------|---------|------------------|---------|
| col1  | Custom Field 1 | Customer Name | Client/Customer identifier |
| col2  | Custom Field 2 | CI ID | Configuration Item ID |
| col3  | Custom Field 3 | Server Description | Server role/description |
| col4  | Custom Field 4 | IP Address Local | Local IP address |
| col5  | Custom Field 5 | Group 1 | Primary grouping |
| col6  | Custom Field 6 | Group 2 | Secondary grouping |
| col7  | Custom Field 7 | Group 3 | Tertiary grouping |
| col8  | Custom Field 8 | Group 4 | Additional classification |

3. Save the configuration
4. Populate field values for managed computers

### 3. Branch Office Setup (If Applicable)

For Branch Office reports to be meaningful:

1. **Configure Branch Offices**:
   - Navigate to **Admin** → **Branch Office**
   - Add branch office definitions
   - Assign computers to branch offices

2. **Setup Replication Policies**:
   - Configure bandwidth and scheduling policies
   - Assign policies to branch offices
   - Verify policy application

## Report Implementation

### 1. Creating Your First Query Report

**Step-by-step process**:

1. **Access Query Reports**:
   ```
   PMP Console → Reports → Custom Report → New Query Report
   ```

2. **Configure Report Settings**:
   - **Report Name**: Use descriptive naming convention
   - **Description**: Include purpose and schedule
   - **SQL Query**: Paste query from repository

3. **Test Query**:
   - Run query with limited results first
   - Verify column headers and data accuracy
   - Check performance impact

4. **Save and Schedule**:
   - Save report for future use
   - Configure automated scheduling if needed
   - Set up email distribution

### 2. Report Naming Convention

Implement consistent naming for better organization:

```
Format: [Type]_[Scope]_[Frequency]_[Date]

Examples:
- ExtendedPPM_AllSystems_Monthly_2025-01
- ShortPPM_CriticalServers_Weekly_2025-01-15
- BranchOffice_RemoteSites_Quarterly_2025-Q1
- ManagedDevices_Infrastructure_Daily_2025-01-14
```

### 3. Performance Optimization

**For Large Environments (>5,000 endpoints)**:

1. **Index Management**:
   - Ensure proper database indexing
   - Monitor query execution plans
   - Consider custom indexes for frequently used columns

2. **Query Modifications**:
   ```sql
   -- Add result limits for testing
   SELECT TOP 1000 ...  -- SQL Server
   SELECT ... LIMIT 1000;  -- MySQL/PostgreSQL
   
   -- Add specific date ranges
   WHERE LONG_TO_DATE(resource.db_added_time) >= '2024-01-01'
   
   -- Filter by specific groups
   WHERE m2.col5 = 'Production Servers'
   ```

3. **Execution Scheduling**:
   - Schedule large reports during off-peak hours
   - Stagger multiple report executions
   - Monitor database performance impact

## Integration Setup

### 1. CSV Export Configuration

**Automated Processing Setup**:

1. **Configure Export Settings**:
   - Set default CSV format
   - Configure field delimiters (comma recommended)
   - Enable column headers
   - Set encoding to UTF-8

2. **File Naming Convention**:
   ```
   Format: [ReportType]_[YYYY-MM-DD]_[HHMMSS].csv
   Example: ExtendedPPM_2025-01-14_143022.csv
   ```

### 2. Dashboard Integration

**Business Intelligence Integration**:

1. **Power BI Setup**:
   ```
   Data Source: Text/CSV
   File Path: [PMP Export Directory]
   Refresh Schedule: Match PMP report schedule
   ```

2. **Tableau Integration**:
   ```
   Connection Type: Text File
   Data Interpreter: Enable
   Refresh: Configure automatic refresh
   ```

3. **Excel Integration**:
   ```
   Data → From Text/CSV
   Set up data types and formatting
   Create pivot tables and charts
   ```

### 3. Automated Processing Scripts

**PowerShell Example** (Windows):
```powershell
# Process PMP CSV exports
$csvPath = "C:\PMP_Reports\*.csv"
$processedPath = "C:\PMP_Reports\Processed\"

Get-ChildItem $csvPath | ForEach-Object {
    $data = Import-Csv $_.FullName
    # Process data as needed
    $data | Export-Csv "$processedPath\Processed_$($_.Name)" -NoTypeInformation
    Move-Item $_.FullName "$processedPath\Archive\"
}
```

**Bash Example** (Linux):
```bash
#!/bin/bash
# Process PMP CSV exports
CSV_DIR="/opt/pmp_reports"
PROCESSED_DIR="/opt/pmp_reports/processed"

for file in $CSV_DIR/*.csv; do
    if [ -f "$file" ]; then
        # Process CSV file
        basename=$(basename "$file")
        # Add processing logic here
        mv "$file" "$PROCESSED_DIR/archive/"
    fi
done
```

## Security Configuration

### 1. Access Control

**User Permissions**:
- Limit Query Report access to authorized personnel
- Implement role-based access control
- Regular access review and audit

**Database Security**:
- Use read-only database accounts for reporting
- Implement query resource limits
- Monitor query execution logs

### 2. Data Protection

**Sensitive Information Handling**:
- Review queries for sensitive data exposure
- Implement data masking if required
- Secure export file storage

**Audit Trail**:
- Enable query execution logging
- Monitor report access and downloads
- Implement change control for query modifications

## Maintenance Procedures

### 1. Regular Maintenance Tasks

**Monthly Tasks**:
- Review query performance metrics
- Update report schedules as needed
- Archive old report files
- Verify custom field data accuracy

**Quarterly Tasks**:
- Review and update query logic
- Performance optimization review
- User access audit
- Documentation updates

**Annual Tasks**:
- Complete security review
- Disaster recovery testing
- Training updates for users
- Technology upgrade planning

### 2. Troubleshooting Procedures

**Common Issues and Solutions**:

1. **Query Timeout**:
   - Add more specific WHERE clauses
   - Break query into smaller chunks
   - Review database performance

2. **Inconsistent Data**:
   - Verify custom field configuration
   - Check agent connectivity
   - Review data synchronization

3. **Performance Issues**:
   - Analyze execution plans
   - Consider database indexing
   - Optimize query logic

### 3. Change Management

**Query Modification Process**:
1. Document change requirements
2. Test modifications in development
3. Review impact on existing reports
4. Update documentation
5. Communicate changes to users
6. Implement with rollback plan

## Monitoring and Alerting

### 1. Performance Monitoring

**Key Metrics to Monitor**:
- Query execution time
- Database resource utilization
- Report generation frequency
- Export file sizes

### 2. Alerting Setup

**Recommended Alerts**:
- Query execution failures
- Performance threshold exceeded
- Disk space for export files
- Scheduled report delivery failures

**Alert Configuration Example**:
```sql
-- Database monitoring query
SELECT 
    query_start_time,
    query_duration,
    query_text
FROM query_log 
WHERE query_duration > 300  -- Alert if query takes >5 minutes
ORDER BY query_start_time DESC;
```

This configuration guide should be regularly updated as your environment evolves and new requirements emerge.