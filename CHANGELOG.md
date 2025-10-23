# Changelog

All notable changes to the Patch Manager Plus Custom Query Reports repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Moved problematic queries to examples**: `extended_pmp_report.sql` and `managed_devices_details.sql`
  - These queries have PM+ compatibility issues and are now marked as EXPERIMENTAL
  - Recommend using `short_pmp_report.sql` for production patch reporting
- Moved `examples/` folder under `queries/` directory for better organization
- Moved `QUERY_INDEX.md` to `docs/` folder for better documentation organization
- Moved `SQL Query Reports.sql` to `queries/archive/` subfolder as legacy file
- Removed `ORDER BY` clauses from all queries for PM+ compatibility
- Removed `GROUP BY` clauses where not required by PM+ query reports
- Updated all documentation references to reflect new folder structure

### Fixed
- Fixed smart quotes issue causing "invalid parameter format" errors in PM+ query reports
- All queries now use standard ASCII quotes for proper PM+ compatibility
- Removed trailing semicolons and unnecessary sorting for better query execution
- Restored original query structure from archive to fix type casting errors
- Removed CASE statements causing "boolean = integer" type errors

### Added
- Initial repository setup with documentation
- Mitel Networks Corporation proprietary license
- Comprehensive README documentation
- Warning labels for experimental/problematic queries

### Deprecated
- `extended_pmp_report.sql` - Moved to examples, use `short_pmp_report.sql` instead
- `managed_devices_details.sql` - Moved to examples due to PM+ compatibility issues

## [1.0.0] - 2025-01-14

### Added
- Extended PPM Report query with comprehensive patch management data
- Short PPM Report query for condensed patch information
- Branch Office Details queries for distributed environment management
- Managed Devices Details query for complete device inventory
- SQL query collection in `SQL Query Reports.sql`

### Features
- Customer information and CI tracking
- Patch status monitoring (Missing/Installed)
- Health status assessment (Highly Vulnerable/Vulnerable/Healthy)
- Operating system and service pack reporting
- Reboot requirement analysis
- Branch office management and agent deployment status
- Device inventory with installation timestamps
- Live status monitoring capabilities

### Documentation
- Complete usage instructions
- Database table reference
- Customization guidelines
- Security and compliance considerations
- Export and integration options

### Database Schema Support
- Compatible with ManageEngine Patch Manager Plus database
- Supports standard PMP table structure
- Includes custom fields integration
- Branch office and replication policy support

### Notes
- Query Reports feature is not available for PMP Cloud deployments
- Requires on-premises Patch Manager Plus installation
- Database access permissions required for query execution

---

## Version History

- **v1.0.0**: Initial release with core query collection and documentation
- **Future releases**: Will include additional queries, performance optimizations, and enhanced reporting capabilities

## Migration Notes

When upgrading Patch Manager Plus versions:
1. Test all queries against the new database schema
2. Review any deprecated tables or columns
3. Update queries as needed for compatibility
4. Validate report output accuracy

## Support Matrix

| PMP Version | Compatibility | Notes |
|-------------|---------------|-------|
| 10.x        | ✅ Supported  | Full compatibility |
| 11.x        | ✅ Supported  | Full compatibility |
| 12.x        | ⚠️ Testing    | Under validation |

For version-specific compatibility information, consult the ManageEngine Patch Manager Plus documentation or contact support.