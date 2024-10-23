# Get-AutomoxAPIData

## SYNOPSIS
Queries the Automox API.

## SYNTAX

```
Get-AutomoxAPIData [-OrganizationID] <String> [-APIKey] <String> [[-ExecutionMode] <String>]
 [[-ExportDirectory] <DirectoryInfo>] [[-LogDirectory] <DirectoryInfo>] [-ContinueOnError] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Heavily leverages the "Get-AutomoxAPIObject" function in order to query the Automox API.
The function will be automatically imported for usage during script execution.

## EXAMPLES

### EXAMPLE 1
```
powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "FolderPathContainingScript\Get-AutomoxAPIData.ps1" -OrganizationID 'YourOrganizationID' -APIKey "YourAPIKey"
```

### EXAMPLE 2
```
powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "FolderPathContainingScript\Get-AutomoxAPIData.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "Execute"
```

### EXAMPLE 3
```
powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "FolderPathContainingScript\Get-AutomoxAPIData.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "CreateScheduledTask"
```

### EXAMPLE 4
```
powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "FolderPathContainingScript\Get-AutomoxAPIData.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "RemoveScheduledTask"
```

## PARAMETERS

### -APIKey
A valid Automox API key that is associated with the specified organization ID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: Key

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinueOnError
Specifies whether to ignore fatal errors.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: COE

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutionMode
A valid execution mode for script operation.
Maybe any one of 'Execute', 'CreateScheduledTask', or 'RemoveScheduledTask'.
By default, 'Execute' will be specified value.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: EM

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportDirectory
A valid directory where the API request data will be exported.
If the directory does not exist, it will be automatically created.

```yaml
Type: System.IO.DirectoryInfo
Parameter Sets: (All)
Aliases: ED

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDirectory
A valid directory where the script logs will be located.
By default, "C:\Windows\Logs\Software\Get-AutomoxAPIData".

```yaml
Type: System.IO.DirectoryInfo
Parameter Sets: (All)
Aliases: LogDir, LD

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationID
A valid Automox organization ID.
This might take the form of a number or a GUID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: OID

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Any useful tidbits

## RELATED LINKS

[A useful link]()

