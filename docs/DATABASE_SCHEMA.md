# Database Schema Reference

This document provides reference information about the ManageEngine Patch Manager Plus database tables used in the custom queries.

## Core Tables

### resource
Primary table containing system resource information.

**Key Columns:**
- `resource_id`: Unique identifier for each resource
- `name`: Computer/device name
- `domain_netbios_name`: Domain information
- `customer_id`: Customer identifier
- `db_added_time`: Timestamp when resource was added
- `db_updated_time`: Last update timestamp
- `is_inactive`: Active/inactive status
- `resource_type`: Type of resource
- `unique_value`: Unique system identifier

### managedcomputer
Extended information for managed computer resources.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `agent_installed_dir`: Installation directory of the agent
- `added_time`: When computer was added to management
- `agent_executed_on`: Last agent execution time
- `agent_installed_on`: Agent installation timestamp
- `agent_status`: Current agent status
- `agent_version`: Version of installed agent
- `fqdn_name`: Fully qualified domain name
- `managed_status`: Management status (61 = Managed)
- `installation_status`: Installation status
- `uuid`: System UUID

### patchmgmtosinfo
Operating system information for patch management.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `os_name`: Operating system name
- `os_version`: OS version information
- `service_pack`: Service pack level
- `os_platform`: Platform type
- `is_server_os`: Boolean indicating server OS

### affectedpatchstatus
Patch status information for managed systems.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `patch_id`: Foreign key to patch table
- `status_id`: Patch status (202 = Missing, others = Installed)

### patch
Master patch information table.

**Key Columns:**
- `patchid`: Unique patch identifier
- `bulletinid`: Security bulletin identifier
- `noreboot`: Reboot requirement (0=May Require, 1=Not Required, 2=Required)
- `uninstall_status`: Uninstallation support (1=Supported, 0=Not Supported)

### patchdetails
Detailed patch information and descriptions.

**Key Columns:**
- `patchid`: Foreign key to patch table
- `description`: Human-readable patch description

## Extended Tables

### pmreshealthstatus
Resource health status information.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `health_status`: Health level (1=Healthy, 2=Vulnerable, 3=Highly Vulnerable)

### installpatchstatus
Patch installation status and history.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `patch_id`: Foreign key to patch table
- `installed_time`: Installation timestamp
- `remarks`: Installation remarks/notes
- `remarks_args`: Additional remark arguments

### managedcomputercustomfields
Custom field data for managed computers.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `col1`: Customer Name (custom field)
- `col2`: CI ID (custom field)
- `col3`: Server Description (custom field)
- `col4`: IP Address Local (custom field)
- `col5`: Group 1 (custom field)
- `col6`: Group 2 (custom field)
- `col7`: Group 3 (custom field)
- `col8`: Group 4 (custom field)

## Branch Office Tables

### branchofficedetails
Branch office configuration and information.

**Key Columns:**
- `branch_office_id`: Unique branch office identifier
- `branch_office_name`: Branch office name
- `has_masteragent`: Master agent presence flag

### branchmemberresourcerel
Relationship between resources and branch offices.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `branch_office_id`: Foreign key to branchofficedetails table

### replicationpolicydetails
Replication policy configuration for branch offices.

**Key Columns:**
- `policy_id`: Unique policy identifier
- `policy_name`: Policy name
- `polling_interval`: Polling frequency
- `data_transfer_rate`: WAN transfer rate
- `data_transfer_rate_lan`: LAN transfer rate
- `rep_days_of_week`: Replication schedule days
- `rep_window_start_time`: Replication window start
- `rep_window_end_time`: Replication window end

### policytobranchofficerel
Relationship between policies and branch offices.

**Key Columns:**
- `policy_id`: Foreign key to replicationpolicydetails table
- `branch_office_id`: Foreign key to branchofficedetails table

## Platform and Type Tables

### platform
Platform information for patches and systems.

**Key Columns:**
- `platform_id`: Unique platform identifier
- `platform_name`: Platform name (Windows, Linux, etc.)

### pmpatchtype
Patch type classification.

**Key Columns:**
- `patchid`: Foreign key to patch table
- `platform_id`: Foreign key to platform table

### computer
Additional computer information.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `os_name`: Operating system name
- `os_version`: OS version
- `service_pack`: Service pack information
- `os_platform`: Platform details
- `is_server_os`: Server OS flag
- `db_updated_time`: Last database update

### resourcelivestatus
Real-time status information for resources.

**Key Columns:**
- `resource_id`: Foreign key to resource table
- `status`: Current live status
- `status_update_time`: Last status update timestamp

## Common Status Codes

### Management Status (`managed_status`)
- `61`: Managed and active

### Patch Status (`status_id`)
- `202`: Missing/Not Installed
- Other values: Installed

### Health Status (`health_status`)
- `1`: Healthy
- `2`: Vulnerable  
- `3`: Highly Vulnerable

### Reboot Requirements (`noreboot`)
- `0`: May Require Reboot
- `1`: Reboot Not Required
- `2`: Reboot Required

### Uninstall Support (`uninstall_status`)
- `0`: Uninstallation Not Supported
- `1`: Uninstallation Supported

## Query Optimization Tips

1. **Use Indexes**: Most queries should include `resource_id` in WHERE clauses as it's typically indexed
2. **Filter Early**: Apply `managed_status = 61` filter to reduce result sets
3. **Limit Results**: Use appropriate WHERE clauses to avoid large datasets
4. **Join Efficiency**: Use INNER JOINs where possible for better performance
5. **Date Filtering**: Use date range filters when working with timestamp columns

## Function Reference

### LONG_TO_DATE()
Converts Unix timestamp to readable date format.
```sql
LONG_TO_DATE(timestamp_column, "format_string")
```

### I18N_TRANSLATE()
Translates internationalized strings.
```sql
I18n_translate(text_column, args_column)
```

## Custom Fields Configuration

Custom fields (col1-col8) in `managedcomputercustomfields` can be configured through the Patch Manager Plus web interface:
- **col1**: Typically used for Customer Name
- **col2**: Usually CI ID or Configuration Item identifier
- **col3**: Server Description or Role
- **col4**: Local IP Address
- **col5-col8**: Additional grouping or classification fields

These fields must be configured in PMP before they will contain data in the database.