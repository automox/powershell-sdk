# Invoke-ScheduledTaskAction

## SYNOPSIS
Grants the ability to create a Windows scheduled task from a XML definition.

## SYNTAX

### Create (Default)
```
Invoke-ScheduledTaskAction [-Create] -ScheduledTaskDefinition <String> [-Force] [-ScheduledTaskFolder <String>]
 -ScheduledTaskName <String> [-Source <DirectoryInfo>] [-Destination <DirectoryInfo>] -ScriptName <String>
 [-ScriptParameters <String[]>] [-Stage] [-Execute] [-Interactive] [-ContinueOnError] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Remove
```
Invoke-ScheduledTaskAction [-Remove] [-ScheduledTaskFolder <String>] -ScheduledTaskName <String>
 [-Source <DirectoryInfo>] [-ContinueOnError] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This functiong greatly reduces the complexity of staging scripts on a device that will be executed as a scheduled task.

## EXAMPLES

### EXAMPLE 1
```
[System.IO.FileInfo]$ScheduledTaskDefinitionPath = 'C:\YourPath\YourExportedScheduledTask.xml'

\[String\]$ScheduledTaskDefinition = \[System.IO.File\]::ReadAllText($ScheduledTaskDefinitionPath.FullName)

$InvokeScheduledTaskActionParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
  $InvokeScheduledTaskActionParameters.Create = $True
  $InvokeScheduledTaskActionParameters.ScheduledTaskDefinition = $ScheduledTaskDefinition
  $InvokeScheduledTaskActionParameters.Force = $True
  $InvokeScheduledTaskActionParameters.ScheduledTaskFolder = "\YourScheduledTaskFolder"
  $InvokeScheduledTaskActionParameters.ScheduledTaskName = "Your Scheduled Task Name"
  $InvokeScheduledTaskActionParameters.Source = "\\\\YourServer\YourShare\YourScriptDirectory"   
  $InvokeScheduledTaskActionParameters.ScriptName = "YourPowershellScript.ps1"
  $InvokeScheduledTaskActionParameters.ScriptParameters = New-Object -TypeName 'System.Collections.Generic.List\[String\]'
    $InvokeScheduledTaskActionParameters.ScriptParameters.Add('-Verbose')
    $InvokeScheduledTaskActionParameters.ScriptParameters = $InvokeScheduledTaskActionParameters.ScriptParameters.ToArray()    
  $InvokeScheduledTaskActionParameters.Destination = "$($Env:ProgramData)\ScheduledTasks\$(\[System.IO.Path\]::GetFileNameWithoutExtension($InvokeScheduledTaskActionParameters.ScriptName))"
  $InvokeScheduledTaskActionParameters.Stage = $True
  $InvokeScheduledTaskActionParameters.Execute = $False
  $InvokeScheduledTaskActionParameters.ContinueOnError = $False
  $InvokeScheduledTaskActionParameters.Verbose = $True

$InvokeScheduledTaskActionResult = Invoke-ScheduledTaskAction @InvokeScheduledTaskActionParameters

Write-Output -InputObject ($InvokeScheduledTaskActionResult)
```

### EXAMPLE 2
```
Invoke-ScheduledTaskAction -Remove -ScheduledTaskFolder '\Custom' -ScheduledTaskName 'Perform Dynamic Software Removal' -Source "$($Env:ProgramData)\ScheduledTasks\Invoke-SoftwareRemoval" -Verbose
```

## PARAMETERS

### -ContinueOnError
Specifies that fatal errors will be ignored.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Create
Specifies that this function will create a scheduled task.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Create
Aliases: C

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Destination
The destination directory where the files/folders will be copied locally.

```yaml
Type: System.IO.DirectoryInfo
Parameter Sets: Create
Aliases: DD

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Execute
Specifies that the scheduled task will be executed at the time of creation.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Create
Aliases: E

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Specifies that the scheduled task will be overwritten if it already exists.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Create
Aliases: F

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interactive
Specifies that vbscript files will be executed with wscript.exe instead of cscript.exe.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Create
Aliases: I

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
Specifies that the scheduled task will be removed.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Remove
Aliases: R

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledTaskDefinition
A valid scheduled task definition.
The scheduled task definition can be defined directly within a powershell script or read from a file external to the powershell script.

```yaml
Type: System.String
Parameter Sets: Create
Aliases: STD

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledTaskFolder
A valid scheduled task folder.
If the scheduled taskfolder does not exist, it will be created.
If the scheduled taskfolder does exist, it will NOT be removed upon removal of the scheduled task.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: STF

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledTaskName
A valid scheduled name.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases: STN

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptName
A valid file name the script that will be executed by the scheduled task.
A proper command line to execute the script will be dynamically generated based on the file extension.

```yaml
Type: System.String
Parameter Sets: Create
Aliases: SN

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptParameters
One or more valid parameters that will be passed to the script that will be executed by the scheduled task.

```yaml
Type: System.String[]
Parameter Sets: Create
Aliases: SP

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
The source directory containing the script or binary, and any associated files that will be copied locally and executed by the scheduled task.

```yaml
Type: System.IO.DirectoryInfo
Parameter Sets: (All)
Aliases: SD

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stage
Specifies that the files/folders will be copied locally to the device that the scheduled task will be executed on.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Create
Aliases: S

Required: False
Position: Named
Default value: False
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
This function uses an older, but more compatible method of creating scheduled tasks.

## RELATED LINKS

[https://learn.microsoft.com/en-us/windows/win32/taskschd/schtasks](https://learn.microsoft.com/en-us/windows/win32/taskschd/schtasks)

[https://ss64.com/nt/schtasks.html](https://ss64.com/nt/schtasks.html)

