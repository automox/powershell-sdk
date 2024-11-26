# Automox Cross Zone Report

## SYNOPSIS
This powershell script queries the Automox API for the specified organization, gets a list of the associated zones, and calculates the patching compliance for each zone.
The results are then exported to a CSV. The resulting CSV can then be used as a data source for any business intelligence (BI) tool such as PowerBI or Grafana.

## DESCRIPTION
This script can also be enabled to run as a scheduled task, so that the CSV data is able to stay up to date, and therefore any dashboard built on the exported CSV would be up to date as well.

<img width="1095" alt="Snag_6842e13" src="https://github.com/user-attachments/assets/4851393a-f7c0-4e9f-bbc4-cb4130514f51">

## NOTES
This script is fully compatible with Powershell 7.

## Example CSV Output

```
"ZoneName","ZoneID","ZoneUUID","ZoneDeviceCount","Success","SuccessPercentage","Failed","FailedPercentage"
"Zone001","45746755","f4960637-65b9-4ca8-b282-c3b4e464fa0f","3","0","0","0","0"
"Zone002","56485764","2c495f43-72de-48cc-ab1b-637d8e5d098a","0","0","0","0","0"
"Zone003","23424234","824fc1a8-1d18-4c25-98d9-740f1a8b85ad","13","2","66.67","1","33.33"
"Zone004","68796758","439977ff-497c-45cb-8e56-dd58b879d456","0","0","0","0","0"
"Zone005","43575764","ac36bbe7-13d1-4221-8d29-bbdca343a82d","5","10","41.67","14","58.33"
"Zone006","69845455","444a4f28-a297-427e-abd7-004f502ec63f","7","74","89.16","9","10.84"
```

## Script Usage Examples

### EXAMPLE 1
```

powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey"
```
### EXAMPLE 2
```

powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "CreateScheduledTask"
```

### EXAMPLE 3
```
powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "RemoveScheduledTask"
```

## PARAMETERS

### -OrganizationID (Required)
A valid Automox organization ID.

### -APIKey (Required)
A valid Automox API key that is associated with the specified organization ID.

### -ZoneFilterExpression
A valid powershell script block that allows for the filtering of associated zones.

Example: ```{($_.Name -imatch '(^.*$)') -and ($_.Name -inotmatch '(^.{0,0}$)')}``` = All zones whose name match anything, and no zones whose names are empty.

### -PolicyTypeList
One or more policy types to filter on. By default, only patch policies will be returned and processed.

### -DateRange
A valid value between 1 and 90 days. By default,patching compliance will be calculated over 90 days.

### -Export
Specifies whether or not to export the data returned by this script to CSV. By default, the data will be exported.

### -ExportDirectory
A valid directory where the API request data will be exported. If the specified directory does not exist, it will be automatically created.

### -ExecutionMode
A valid execution mode for script operation. Maybe any one of 'Execute', 'CreateScheduledTask', or 'RemoveScheduledTask'. By default, 'Execute' will be specified value.

### -LogDirectory
A valid directory where the script logs will be located. By default, the logs will be stored under the logs folder within the script directory.

### -ContinueOnError
Specifies whether to ignore fatal errors.

## RELATED LINKS

[https://developer.automox.com/openapi/policy-history/operation/allPolicyExecutions](https://developer.automox.com/openapi/policy-history/operation/allPolicyExecutions)