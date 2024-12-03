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

## SCRIPT PARAMETERS

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

## REPOSITORY LINK

[Repository Link](https://github.com/automox/powershell-sdk)

## USAGE INSTRUCTIONS

<img width="1288" alt="Snag_ba836cd" src="https://github.com/user-attachments/assets/84ddfd3e-ba4e-40d4-81d7-6978777be173">
<img width="1288" alt="Snag_ba84fb4" src="https://github.com/user-attachments/assets/18db12f9-0116-4674-adc8-e1f374e26521">
<img width="853" alt="Snag_ba85ef6" src="https://github.com/user-attachments/assets/1637e0dd-b85c-4319-82a5-ea9537caa590">
<img width="853" alt="Snag_ba86e29" src="https://github.com/user-attachments/assets/b14f21d1-b075-4281-afc9-4821e7fcb8eb">
<img width="848" alt="Snag_ba87d9a" src="https://github.com/user-attachments/assets/01680400-777f-475c-8bea-f15aecd85a61">
<img width="431" alt="Snag_ba88be2" src="https://github.com/user-attachments/assets/c36a80f4-3220-4164-b665-6b31b372c1ff">
<img width="873" alt="Snag_ba8e433" src="https://github.com/user-attachments/assets/3a94863f-4e13-4dc8-833d-cd25092dc4c0">
<img width="350" alt="Snag_ba8f6d1" src="https://github.com/user-attachments/assets/8b211d6a-56aa-4e64-af86-75abbc88ad59">
<img width="863" alt="Snag_ba9072c" src="https://github.com/user-attachments/assets/74a9064a-9a40-4e2d-85f5-d99181304d3d">
<img width="853" alt="Snag_ba91d74" src="https://github.com/user-attachments/assets/ca735d2e-3d90-4ca0-b7ad-b369b3c48fb3">
<img width="959" alt="Snag_ba92f75" src="https://github.com/user-attachments/assets/0f717aa7-b40c-4375-b43f-b4f716ae4645">
<img width="853" alt="Snag_ba93f92" src="https://github.com/user-attachments/assets/13cb2ff3-dd6b-4410-ba14-d00e63ceb71f">
<img width="853" alt="Snag_ba94e96" src="https://github.com/user-attachments/assets/f8fef081-b443-4bfc-be71-ddadab6d5d4e">
<img width="574" alt="Snag_ba96886" src="https://github.com/user-attachments/assets/aa539532-7b41-4641-9358-d18da87dfd7e">
<img width="1288" alt="Snag_ba97a3a" src="https://github.com/user-attachments/assets/9b6283aa-90ad-488e-944b-ed9b3ec221e7">
<img width="1288" alt="Snag_ba9936f" src="https://github.com/user-attachments/assets/2c18c7b1-49ba-4066-a6d8-4405cd2a91b7">
