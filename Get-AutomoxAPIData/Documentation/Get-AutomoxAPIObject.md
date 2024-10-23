# Get-AutomoxAPIObject

## SYNOPSIS
Queries the Automox API.

## SYNTAX

### __AllParameterSets (Default)
```
Get-AutomoxAPIObject -OrganizationID <String> -APIKey <String> -Endpoint <String> [-Method <String>]
 [-BaseURI <Uri>] [-SubURI <Uri>] [-RequestParameters <String[]>] [-Page <Int32>] [-Limit <Int32>]
 [-PropertyInclusionList <Object[]>] [-PropertyExclusionList <Object[]>] [-RequestAssociatedData]
 [-ContinueOnError] [<CommonParameters>]
```

### Export
```
Get-AutomoxAPIObject -OrganizationID <String> -APIKey <String> -Endpoint <String> [-Method <String>]
 [-BaseURI <Uri>] [-SubURI <Uri>] [-RequestParameters <String[]>] [-Page <Int32>] [-Limit <Int32>]
 [-PropertyInclusionList <Object[]>] [-PropertyExclusionList <Object[]>] [-RequestAssociatedData] [-Export]
 [-ExportFormat <String>] [-ExportDirectory <DirectoryInfo>] [-FileName <String>] [-AppendDate]
 [-Encoding <Encoding>] [-ContinueOnError] [<CommonParameters>]
```

## DESCRIPTION
Makes querying the Automox API easier and more efficient.

## EXAMPLES

### EXAMPLE 1
```
Get-AutomoxAPIObject -OrganizationID "YourOrganizationID" -APIKey "YourOrganizationID" -Endpoint "servers" -Export -ExportFormat 'JSON'
```

### EXAMPLE 2
```
$GetAutomoxAPIObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'

$GetAutomoxAPIObjectParameters.OrganizationID = "YourOrganizationID"
  $GetAutomoxAPIObjectParameters.APIKey = "YourAPIKey"
  $GetAutomoxAPIObjectParameters.Endpoint = "servers"
 $GetAutomoxAPIObjectParameters.Export = $True
 $GetAutomoxAPIObjectParameters.ExportFormat = 'JSON'
 $GetAutomoxAPIObjectParameters.AppendDate = $True
  $GetAutomoxAPIObjectParameters.ContinueOnError = $False
  $GetAutomoxAPIObjectParameters.Verbose = $True

$GetAutomoxAPIObjectResult = Get-AutomoxAPIObject @GetAutomoxAPIObjectParameters

Write-Output -InputObject ($GetAutomoxAPIObjectResult)
```

### EXAMPLE 3
```
$GetAutomoxAPIObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'


$GetAutomoxAPIObjectParameters.OrganizationID = "YourOrganizationID"
  $GetAutomoxAPIObjectParameters.APIKey = "YourAPIKey"
  $GetAutomoxAPIObjectParameters.Endpoint = "orgs"
 $GetAutomoxAPIObjectParameters.Method = 'Get'
 $GetAutomoxAPIObjectParameters.BaseURI = 'https://console.automox.com/api'
 $GetAutomoxAPIObjectParameters.SubURI = "/YourOrganizationID"
 $GetAutomoxAPIObjectParameters.RequestParameters = New-Object -TypeName 'System.Collections.Generic.List\[System.String\]'
  $GetAutomoxAPIObjectParameters.RequestParameters.Add('YourAdditionalRequestParameter01')
    $GetAutomoxAPIObjectParameters.RequestParameters.Add('YourAdditionalRequestParameter02')
 $GetAutomoxAPIObjectParameters.Page = 0
 $GetAutomoxAPIObjectParameters.Limit = 100
 $GetAutomoxAPIObjectParameters.Export = $True
 $GetAutomoxAPIObjectParameters.ExportFormat = 'JSON'
 $GetAutomoxAPIObjectParameters.AppendDate = $False
 $GetAutomoxAPIObjectParameters.ContinueOnError = $False
 $GetAutomoxAPIObjectParameters.Verbose = $True

$GetAutomoxAPIObjectResult = Get-AutomoxAPIObject @GetAutomoxAPIObjectParameters

Write-Output -InputObject ($GetAutomoxAPIObjectResult)
```

## PARAMETERS

### -APIKey
The Automox API key that was created from within the Automox console.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppendDate
The current date and time will be appended to the file name of the exported API request results.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseURI
The Automox base URI for the API.
By default, the value will be "https://console.automox.com/api".

```yaml
Type: System.Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinueOnError
Ignore function execution errors.
By default, fatal errors will terminate the execution of the function.

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

### -Encoding
A valid file encoding that will be used when exporting the API request results.

```yaml
Type: System.Text.Encoding
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
A valid Automox API endpoint.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
Specifies that the API request results should be exported.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportDirectory
A valid directory path for the exported API request results.

```yaml
Type: System.IO.DirectoryInfo
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportFormat
A valid export format for the exported API request results.

```yaml
Type: System.String
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
A valid file name for the exported API request results.

```yaml
Type: System.String
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of results to return per page request.
By default, the value will be 100.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
A valid web request method.
By default, the value will be "Get".

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationID
The Automox organization ID.
Can take the form of a number or a GUID, depending on the endpoint.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The starting page of API request results to page from.
By default, the value will be 0, which represents the first page.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyExclusionList
A valid object list specifying what properties should be excluded from the API request.
This feature works like the Select-Object cmdlet with the -ExcludeProperty parameter.

```yaml
Type: System.Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyInclusionList
A valid object list specifying what properties should be returned from the API request.
This feature works like the Select-Object cmdlet with the -Property parameter.

```yaml
Type: System.Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestAssociatedData
Specifies whether to request the associated data with a given object based on the API endpoint.
An example would be, when querying device information, this argument would fetch the installed software on each device returned from the API request.

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

### -RequestParameters
Any optional request parameters required for the Automox API request.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubURI
An optional sub URI for the Automox API.
This is useful when wanting to retrieve details about specific object, such as a device.

```yaml
Type: System.Uri
Parameter Sets: (All)
Aliases:

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

[https://learn.microsoft.com/en-us/dotnet/api/system.net.httpstatuscode?view=net-8.0](https://learn.microsoft.com/en-us/dotnet/api/system.net.httpstatuscode?view=net-8.0)

