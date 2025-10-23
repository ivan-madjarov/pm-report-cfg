# Patch Manager Plus Custom Query Reports

A repository containing SQL queries and configuration files for creating custom reports in ManageEngine Patch Manager Plus. This collection enables organizations to extract specific information from the Patch Manager Plus database that may not be available through standard canned reports.

## Overview

Patch Manager Plus provides the ability to retrieve custom information from its database using Query Reports. This is particularly useful when standard reports don't provide the specific data required for compliance, auditing, or operational needs. Query Reports can be created through the Reports tab → Custom Report → New Query Report functionality.

## Features

- **Extended PPM Reports**: Comprehensive patch management reports with customer information, system details, patch status, and health metrics
- **Short PPM Reports**: Condensed reports focusing on essential patch information
- **Branch Office Details**: Reports for managing distributed environments and branch office configurations
- **Managed Devices Details**: Detailed device inventory and management status reports

## Repository Structure

```
pm-report-cfg/
├── README.md                    # Main documentation
├── LICENSE                     # Mitel proprietary license
├── CHANGELOG.md                # Version history
├── queries/                    # SQL query files
│   ├── extended_pmp_report.sql
│   ├── short_pmp_report.sql
│   ├── branch_office_simple.sql
│   ├── branch_office_detailed.sql
│   ├── managed_devices_details.sql
│   ├── examples/               # Example and specialized queries
│   │   ├── security_vulnerability_report.sql
│   │   ├── patch_compliance_summary.sql
│   │   └── agent_health_monitoring.sql
│   └── archive/                # Archived/legacy files
│       └── SQL Query Reports.sql   # Legacy combined file
└── docs/                       # Detailed documentation
    ├── CONFIGURATION.md        # Setup and configuration guide
    ├── USAGE_GUIDE.md          # Detailed usage instructions
    ├── QUERY_INDEX.md          # Complete query reference
    └── DATABASE_SCHEMA.md      # Database reference
```

## Available Reports

### Core Reports (queries/)

1. **Extended PPM Report** (`extended_pmp_report.sql`)
   - Comprehensive patch management with detailed system information
   - Customer information, CI details, and server descriptions
   - Complete patch status, health metrics, and installation history
   - Suitable for monthly compliance reports and security assessments

2. **Short PPM Report** (`short_pmp_report.sql`)
   - Condensed patch information for quick assessments
   - Essential customer identification and basic system info
   - Fast execution suitable for large environments
   - Ideal for executive summaries and mobile reports

3. **Branch Office Reports** 
   - **Simple Count** (`branch_office_simple.sql`): Quick computer count per branch
   - **Detailed** (`branch_office_detailed.sql`): Comprehensive branch management with replication policies

4. **Managed Devices Details** (`managed_devices_details.sql`)
   - Complete device inventory and management status
   - Agent lifecycle information and connectivity status
   - Asset management integration capabilities

### Example Reports (queries/examples/)

5. **Security Vulnerability Report** (`examples/security_vulnerability_report.sql`)
   - Security-focused analysis with critical patch identification
   - Vulnerability assessment and compliance auditing

6. **Patch Compliance Summary** (`examples/patch_compliance_summary.sql`)
   - High-level compliance statistics and percentages
   - Executive dashboards and KPI reporting

7. **Agent Health Monitoring** (`examples/agent_health_monitoring.sql`)
   - Infrastructure monitoring and agent connectivity
   - Troubleshooting and health assessment

## Prerequisites

- ManageEngine Patch Manager Plus (On-premises version)
- Database access permissions for query execution
- Understanding of Patch Manager Plus database schema

**Note**: Query Reports are not applicable for Patch Manager Plus Cloud (PMP Cloud) deployments.

## Quick Start

1. **Choose a Report:** Browse the `docs/QUERY_INDEX.md` for available queries
2. **Access PMP Console:** Navigate to **Reports** → **Custom Report** → **New Query Report**
3. **Copy Query:** Select and copy the desired SQL query from the appropriate file
4. **Create Report:** Paste query, configure name and description, then generate
5. **Save & Export:** Save for future use and export to CSV for processing

**For detailed instructions:** See `docs/USAGE_GUIDE.md`  
**For setup requirements:** See `docs/CONFIGURATION.md`

## Database Tables Reference

The queries in this repository utilize the following key database tables:
- `resource`: System resource information
- `managedcomputer`: Managed computer details
- `patchmgmtosinfo`: Operating system information
- `affectedpatchstatus`: Patch status details
- `patch`: Patch definitions
- `patchdetails`: Detailed patch information
- `branchofficedetails`: Branch office configuration
- `managedcomputercustomfields`: Custom field data

## Customization

These queries can be customized to meet specific organizational requirements:
- Modify WHERE clauses to filter specific systems or groups
- Add additional JOIN statements to include more data
- Adjust SELECT statements to include/exclude specific columns
- Add GROUP BY and ORDER BY clauses for data aggregation and sorting

## Export and Integration

Query Reports can be:
- Saved for future reference within Patch Manager Plus
- Exported to CSV format for external processing
- Scheduled for regular execution (depending on PMP version)
- Integrated with external reporting tools through CSV exports

## Compliance and Auditing

These reports are designed to support:
- Security compliance reporting
- Patch management audits
- Vulnerability assessment reporting
- System inventory management
- Change management documentation

## Support and Documentation

For additional information about Patch Manager Plus Query Reports:
- [ManageEngine Patch Manager Plus Documentation](https://www.manageengine.com/patch-management/)
- [Custom Query Request Form](https://www.manageengine.com/patch-management/custom-query-request.html)

## Contributing

When adding new queries to this repository:
1. Document the purpose and use case for each query
2. Include comments explaining complex JOIN operations
3. Test queries against a development environment first
4. Follow consistent formatting and naming conventions

## Security Notice

- Ensure database credentials are properly secured
- Limit query report access to authorized personnel only
- Regular review of custom queries for performance impact
- Follow organizational data privacy and security policies

## License

This repository is proprietary to Mitel Networks Corporation. See LICENSE file for details.

---

**Disclaimer**: These SQL queries are provided as-is for use with ManageEngine Patch Manager Plus. Always test queries in a development environment before using in production. Database schema may vary between different versions of Patch Manager Plus.