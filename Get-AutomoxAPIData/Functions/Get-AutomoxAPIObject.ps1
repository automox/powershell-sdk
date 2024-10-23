## Microsoft Function Naming Convention: http://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx

#region Function Get-AutomoxAPIObject
Function Get-AutomoxAPIObject
    {
        <#
          .SYNOPSIS
          Queries the Automox API.
          
          .DESCRIPTION
          Makes querying the Automox API easier and more efficient.
          
          .PARAMETER OrganizationID
          The Automox organization ID. Can take the form of a number or a GUID, depending on the endpoint.

          .PARAMETER APIKey
          The Automox API key that was created from within the Automox console.

          .PARAMETER Endpoint
          A valid Automox API endpoint.

          .PARAMETER Method
          A valid web request method. By default, the value will be "Get".

          .PARAMETER BaseURI
          The Automox base URI for the API. By default, the value will be "https://console.automox.com/api".

          .PARAMETER SubURI
          An optional sub URI for the Automox API. This is useful when wanting to retrieve details about specific object, such as a device.

          .PARAMETER RequestParameters
          Any optional request parameters required for the Automox API request.

          .PARAMETER Page
          The starting page of API request results to page from. By default, the value will be 0, which represents the first page.

          .PARAMETER Limit
          The number of results to return per page request. By default, the value will be 100.

          .PARAMETER PropertyInclusionList
          A valid object list specifying what properties should be returned from the API request. This feature works like the Select-Object cmdlet with the -Property parameter.

          .PARAMETER PropertyExclusionList
          A valid object list specifying what properties should be excluded from the API request. This feature works like the Select-Object cmdlet with the -ExcludeProperty parameter.

          .PARAMETER RequestAssociatedData
          Specifies whether to request the associated data with a given object based on the API endpoint.
          An example would be, when querying device information, this argument would fetch the installed software on each device returned from the API request.

          .PARAMETER Export
          Specifies that the API request results should be exported.

          .PARAMETER ExportFormat
          A valid export format for the exported API request results.

          .PARAMETER ExportDirectory
          A valid directory path for the exported API request results.

          .PARAMETER FileName
          A valid file name for the exported API request results.

          .PARAMETER AppendDate
          The current date and time will be appended to the file name of the exported API request results.

          .PARAMETER Encoding
          A valid file encoding that will be used when exporting the API request results.

          .PARAMETER ContinueOnError
          Ignore function execution errors. By default, fatal errors will terminate the execution of the function.
          
          .EXAMPLE
          Get-AutomoxAPIObject -OrganizationID "YourOrganizationID" -APIKey "YourOrganizationID" -Endpoint "servers" -Export -ExportFormat 'JSON'

          .EXAMPLE
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

          .EXAMPLE
          $GetAutomoxAPIObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
            $GetAutomoxAPIObjectParameters.OrganizationID = "YourOrganizationID"
            $GetAutomoxAPIObjectParameters.APIKey = "YourAPIKey"
            $GetAutomoxAPIObjectParameters.Endpoint = "orgs"
	          $GetAutomoxAPIObjectParameters.Method = 'Get'
	          $GetAutomoxAPIObjectParameters.BaseURI = 'https://console.automox.com/api'
	          $GetAutomoxAPIObjectParameters.SubURI = "/YourOrganizationID"
	          $GetAutomoxAPIObjectParameters.RequestParameters = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
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

          .NOTES
          Any useful tidbits
          
          .LINK
          https://learn.microsoft.com/en-us/dotnet/api/system.net.httpstatuscode?view=net-8.0
        #>
        
        [CmdletBinding(ConfirmImpact = 'Low', DefaultParameterSetName = '__AllParameterSets')] 
          Param
            (        
                [Parameter(Mandatory=$True)]
                [ValidateNotNullOrEmpty()]
                [System.String]$OrganizationID,

                [Parameter(Mandatory=$True)]
                [ValidateNotNullOrEmpty()]
                [System.String]$APIKey,
        
                [Parameter(Mandatory=$True)]
                [ValidateNotNullOrEmpty()]
                [ValidateSet('accounts', 'approvals', 'data-extracts', 'events', 'orgs', 'policies', 'policy-history', 'policystats', 'reports', 'servergroups', 'servers', 'users', 'worklet-catalog', 'zones')]
                [System.String]$Endpoint,
              
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [ValidateSet('Get', 'Head', 'Post', 'Put', 'Delete', 'Trace', 'Options', 'Merge', 'Patch')]
                [System.String]$Method,
              
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.URI]$BaseURI,
              
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.URI]$SubURI,
                            
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.String[]]$RequestParameters,
              
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.Int32]$Page,
              
                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.Int32]$Limit,

                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.Object[]]$PropertyInclusionList,

                [Parameter(Mandatory=$False)]
                [ValidateNotNullOrEmpty()]
                [System.Object[]]$PropertyExclusionList,

                [Parameter(Mandatory=$False)]
                [Switch]$RequestAssociatedData,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [ValidateNotNullOrEmpty()]
                [Switch]$Export,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [ValidateNotNullOrEmpty()]
                [ValidateSet('CSV', 'JSON')]
                [System.String]$ExportFormat,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [ValidateNotNullOrEmpty()]
                [System.IO.DirectoryInfo]$ExportDirectory,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [ValidateNotNullOrEmpty()]
                [System.String]$FileName,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [Switch]$AppendDate,
              
                [Parameter(Mandatory=$False, ParameterSetName = 'Export')]
                [System.Text.Encoding]$Encoding,
 
                [Parameter(Mandatory=$False)]
                [Switch]$ContinueOnError        
            )
                           
        Begin
          { 
              Try
                {
                    $DateTimeLogFormat = 'dddd, MMMM dd, yyyy @ hh:mm:ss.FFF tt'  ###Monday, January 01, 2019 @ 10:15:34.000 AM###
                    [ScriptBlock]$GetCurrentDateTimeLogFormat = {(Get-Date).ToString($DateTimeLogFormat)}
                    $DateTimeMessageFormat = 'MM/dd/yyyy HH:mm:ss.FFF'  ###03/23/2022 11:12:48.347###
                    [ScriptBlock]$GetCurrentDateTimeMessageFormat = {(Get-Date).ToString($DateTimeMessageFormat)}
                    $DateFileFormat = 'yyyyMMdd'  ###20190403###
                    [ScriptBlock]$GetCurrentDateFileFormat = {(Get-Date).ToString($DateFileFormat)}
                    $DateTimeFileFormat = 'yyyyMMdd_HHmmss'  ###20190403_115354###
                    [ScriptBlock]$GetCurrentDateTimeFileFormat = {(Get-Date).ToString($DateTimeFileFormat)}
                    $TextInfo = (Get-Culture).TextInfo
                    $LoggingDetails = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'    
                      $LoggingDetails.LogMessage = $Null
                      $LoggingDetails.WarningMessage = $Null
                      $LoggingDetails.ErrorMessage = $Null
                    $CommonParameterList = New-Object -TypeName 'System.Collections.Generic.List[String]'
                      $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::CommonParameters)
                      $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::OptionalCommonParameters)
                    $RegexOptionList = New-Object -TypeName 'System.Collections.Generic.List[System.Text.RegularExpressions.RegexOptions]'
                      $RegexOptionList.Add('IgnoreCase')
                      $RegexOptionList.Add('Multiline')
                    $RegexExpressionDictionary = New-Object -TypeName 'System.Collections.Generic.Dictionary[[String], [System.Text.RegularExpressions.Regex]]'
                      $RegexExpressionDictionary.Base64 = '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$'
                      $RegexExpressionDictionary.GUID = '^[{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?$'
                                            
                    [ScriptBlock]$ErrorHandlingDefinition = {
                                                                Param
                                                                  (
                                                                      [Int16]$Severity,
                                                                      [Boolean]$ContinueOnError
                                                                  )
                                                                                                                
                                                                $ExceptionPropertyDictionary = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                  $ExceptionPropertyDictionary.Message = $_.Exception.Message
                                                                  $ExceptionPropertyDictionary.Category = $_.Exception.ErrorRecord.FullyQualifiedErrorID
                                                                  $ExceptionPropertyDictionary.Script = Try {[System.IO.Path]::GetFileName($_.InvocationInfo.ScriptName)} Catch {$Null}
                                                                  $ExceptionPropertyDictionary.LineNumber = $_.InvocationInfo.ScriptLineNumber
                                                                  $ExceptionPropertyDictionary.LinePosition = $_.InvocationInfo.OffsetInLine
                                                                  $ExceptionPropertyDictionary.Code = $_.InvocationInfo.Line.Trim()

                                                                $ExceptionMessageList = New-Object -TypeName 'System.Collections.Generic.List[System.String]' -ArgumentList @(100)

                                                                ForEach ($ExceptionProperty In $ExceptionPropertyDictionary.GetEnumerator())
                                                                  {
                                                                      Switch ($Null -ine $ExceptionProperty.Value)
                                                                        {
                                                                            {($_ -eq $True)}
                                                                              {
                                                                                  $ExceptionMessageList.Add("[$($ExceptionProperty.Key): $($ExceptionProperty.Value)]")
                                                                              }
                                                                        }   
                                                                  }

                                                                $LogMessageParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                  $LogMessageParameters.Message = "`r`n" + ($ExceptionMessageList -Join "`r`n")
                                                                  $LogMessageParameters.Verbose = $True
                              
                                                                Switch ($Severity)
                                                                  {
                                                                      {($_ -in @(1))} {Write-Verbose @LogMessageParameters}
                                                                      {($_ -in @(2))} {Write-Warning @LogMessageParameters}
                                                                      {($_ -in @(3))} {Write-Error @LogMessageParameters}
                                                                  }

                                                                Switch ($ContinueOnError)
                                                                  {
                                                                      {($_ -eq $False)}
                                                                        {                  
                                                                            Throw
                                                                        }
                                                                  }
                                                            }
                                                            
                        [ScriptBlock]$GetTimeSpanMessage = {
                                                                Param
                                                                  (
                                                                      [System.TimeSpan]$InputObject
                                                                  )

                                                                $InputObjectMessageBuilder = New-Object -TypeName 'System.Text.StringBuilder'

                                                                $InputObjectProperties = $InputObject | Select-Object -Property @('Days', 'Hours', 'Minutes', 'Seconds', 'Milliseconds')
                                        
                                                                $InputObjectPropertyNameList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'

                                                                ($InputObjectProperties.PSObject.Properties | Where-Object {($_.Value -gt 0)}).Name | ForEach-Object {($InputObjectPropertyNameList.Add($_))}

                                                                $InputObjectPropertyNameListUpperBound = $InputObjectPropertyNameList.ToArray().GetUpperBound(0)
                                        
                                                                For ($InputObjectPropertyNameListIndex = 0; $InputObjectPropertyNameListIndex -lt $InputObjectPropertyNameList.Count; $InputObjectPropertyNameListIndex++)
                                                                  {
                                                                      $InputObjectPropertyName = $InputObjectPropertyNameList[$InputObjectPropertyNameListIndex]
                                              
                                                                      $InputObjectPropertyValue = $InputObject.$($InputObjectPropertyName)

                                                                      Switch ($True)
                                                                        {
                                                                            {($InputObjectPropertyNameList.Count -gt 1) -and ($InputObjectPropertyNameListIndex -eq $InputObjectPropertyNameListUpperBound)}
                                                                              {
                                                                                  $Null = $InputObjectMessageBuilder.Append('and ')
                                                                              }
                                                    
                                                                            {($InputObjectPropertyValue -eq 1)}
                                                                              {                                                          
                                                                                  $Null = $InputObjectMessageBuilder.Append("$($InputObjectPropertyValue) $($InputObjectPropertyName.TrimEnd('s').ToLower())")
                                                                              }

                                                                            {($InputObjectPropertyValue -gt 1)}
                                                                              {
                                                                                  $Null = $InputObjectMessageBuilder.Append("$($InputObjectPropertyValue) $($InputObjectPropertyName.ToLower())")
                                                                              }

                                                                            {($InputObjectPropertyNameList.Count -gt 1) -and ($InputObjectPropertyNameListIndex -ne $InputObjectPropertyNameListUpperBound)}
                                                                              {
                                                                                  $Null = $InputObjectMessageBuilder.Append(', ')
                                                                              }
                                                                        }
                                                                  }

                                                                $OutputObject = $InputObjectMessageBuilder.ToString()
                                        
                                                                Switch ($InputObjectMessageBuilder.Length -gt 0)
                                                                  {
                                                                      {($_ -eq $True)}
                                                                        { 
                                                                            $OutputObject = $InputObjectMessageBuilder.ToString()
                                                                        }

                                                                      Default
                                                                        {
                                                                            $OutputObject = 'N/A'
                                                                        }
                                                                  }
                                        
                                                                Write-Output -InputObject ($OutputObject)
                                                            }
                    
                    #Determine the date and time we executed the function
                      $FunctionStartTime = (Get-Date)
                    
                    [String]$FunctionName = $MyInvocation.MyCommand
                    [System.IO.FileInfo]$InvokingScriptPath = $MyInvocation.PSCommandPath
                    [System.IO.DirectoryInfo]$InvokingScriptDirectory = $InvokingScriptPath.Directory.FullName
                    [System.IO.FileInfo]$FunctionPath = "$($InvokingScriptDirectory.FullName)\Functions\$($FunctionName).ps1"
                    [System.IO.DirectoryInfo]$FunctionDirectory = "$($FunctionPath.Directory.FullName)"
                    
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function `'$($FunctionName)`' is beginning. Please Wait..."
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
              
                    #Define Default Action Preferences
                      $ErrorActionPreference = 'Stop'
                      
                    [String[]]$AvailableScriptParameters = (Get-Command -Name ($FunctionName)).Parameters.GetEnumerator() | Where-Object {($_.Value.Name -inotin $CommonParameterList)} | ForEach-Object {"-$($_.Value.Name):$($_.Value.ParameterType.Name)"}
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Available Function Parameter(s) = $($AvailableScriptParameters -Join ', ')"
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                    [String[]]$SuppliedScriptParameters = $PSBoundParameters.GetEnumerator() | ForEach-Object {Try {"-$($_.Key):$($_.Value.GetType().Name)"} Catch {"-$($_.Key):Unknown"}}
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Supplied Function Parameter(s) = $($SuppliedScriptParameters -Join ', ')"
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Execution of $($FunctionName) began on $($FunctionStartTime.ToString($DateTimeLogFormat))"
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                            
                    #region Load the required assemblies
                      $RequiredAssemblyList = New-Object -TypeName 'System.Collections.Generic.List[System.String]' -ArgumentList @(100)
                        $RequiredAssemblyList.Add('Microsoft.PowerShell.Commands.Utility')
                                              
                      $RequiredAssemblyListCounter = 1
                
                      For ($RequiredAssemblyListIndex = 0; $RequiredAssemblyListIndex -lt $RequiredAssemblyList.Count; $RequiredAssemblyListIndex++)
                        {
                            $RequiredAssembly = $RequiredAssemblyList[$RequiredAssemblyListIndex]
                            
                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to load required assembly $($RequiredAssemblyListCounter) of $($RequiredAssemblyList.Count). Please Wait..."
                            Write-Verbose -Message ($LoggingDetails.LogMessage)
                            
                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Assembly Name: $($RequiredAssembly)"
                            Write-Verbose -Message ($LoggingDetails.LogMessage)
                            
                            $Null = Add-Type -AssemblyName ($RequiredAssembly) -IgnoreWarnings -Verbose:$False
                            
                            $RequiredAssemblyListCounter++
                        }
                    #endregion
                    
                    #Define required variable(s)
                      [System.Int32]$PaginationRetryLimit = 15
                                                            
                    #Define default parameter values
                      Switch ($True)
                        {
                            {([String]::IsNullOrEmpty($BaseURI) -eq $True) -or ([String]::IsNullOrWhiteSpace($BaseURI) -eq $True)}
                              {
                                  [System.URI]$BaseURI = 'https://console.automox.com/api'
                              }
                              
                            {([String]::IsNullOrEmpty($Method) -eq $True) -or ([String]::IsNullOrWhiteSpace($Method) -eq $True)}
                              {
                                  [System.String]$Method = 'Get'
                              }
                                                             
                            {($Null -ieq $Page) -or ($Page -eq 0)}
                              {
                                  [System.Int32]$Page = 0
                              }
                              
                            {($Null -ieq $Limit) -or ($Limit -eq 0)}
                              {
                                  [System.Int32]$Limit = 100
                              }
                              
                            {([String]::IsNullOrEmpty($ExportFormat) -eq $True) -or ([String]::IsNullOrWhiteSpace($ExportFormat) -eq $True)}
                              {
                                  [System.String]$ExportFormat = 'JSON'
                              }

                            {([String]::IsNullOrEmpty($ExportDirectory) -eq $True) -or ([String]::IsNullOrWhiteSpace($ExportDirectory) -eq $True)}
                              {
                                  [System.IO.DirectoryInfo]$ExportDirectory = "$($Env:Public)\Documents\$($FunctionName)"
                              }
                              
                            {([String]::IsNullOrEmpty($FileName) -eq $True) -or ([String]::IsNullOrWhiteSpace($FileName) -eq $True)}
                              {
                                  [System.String]$FileName = "$($Endpoint).$($ExportFormat.ToLower())"
                              }
                              
                            {([String]::IsNullOrEmpty($Encoding) -eq $True) -or ([String]::IsNullOrWhiteSpace($Encoding) -eq $True)}
                              {
                                  [System.Text.Encoding]$Encoding = [System.Text.Encoding]::Default
                              }
                        }
                                                            
                    #Perform security action(s)
                      [System.Net.SecurityProtocolType]$DesiredSecurityProtocol = [System.Net.SecurityProtocolType]::TLS12
                      
                      Switch ([System.Net.ServicePointManager]::SecurityProtocol -inotmatch "(^.*$($DesiredSecurityProtocol).*$)")
                        {
                            {($_ -eq $True)}
                              {
                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to set the desired security protocol to `"$($DesiredSecurityProtocol.ToString().ToUpper())`". Please Wait..."
                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
          
                                  $Null = [System.Net.ServicePointManager]::SecurityProtocol = ($DesiredSecurityProtocol)
                              }
                        }  
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    
                }
          }

        Process
          {           
              Try
                {  
                    [ScriptBlock]$ExecuteAPIRequest = {
                                                          Param
                                                            (
                                                                [System.String]$OrganizationID,
                                                                [System.String]$APIKey,
                                                                [System.String]$Endpoint,
                                                                [System.String]$Method,
                                                                [System.URI]$BaseURI,
                                                                [System.URI]$SubURI,            
                                                                [System.String[]]$RequestParameters,
                                                                [System.Int32]$Page,
                                                                [System.Int32]$Limit
                                                            )

                                                          $APIRequestRecordList = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.PSObject]' -ArgumentList @(1000000)
                                                          
                                                          :APIRequestPagingLoop While ($True)
                                                            {
                                                                Try
                                                                  {
                                                                      #Instantiate the API request parameter list
                                                                        $RequestParameterList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
                                                                  
                                                                      #Load the required request parameters
                                                                        $RequiredRequestParameters = New-Object -TypeName 'System.Collections.Generic.List[System.String]'  
                                                                          $RequiredRequestParameters.Add("limit=$($Limit)")
                                                                          $RequiredRequestParameters.Add("page=$($Page)")

                                                                        Switch ($OrganizationID)
                                                                          {
                                                                              {($_ -imatch $RegexExpressionDictionary.GUID)}
                                                                                {
                                                                                    $RequiredRequestParameters.Insert(0, "?org=$($OrganizationID)") 
                                                                                }

                                                                              Default
                                                                                {
                                                                                    $RequiredRequestParameters.Insert(0, "?o=$($OrganizationID)") 
                                                                                }
                                                                          }
                                                                          
                                                                        For ($RequiredRequestParametersIndex = 0; $RequiredRequestParametersIndex -lt $RequiredRequestParameters.Count; $RequiredRequestParametersIndex++)
                                                                          {
                                                                              $RequiredRequestParameter = $RequiredRequestParameters[$RequiredRequestParametersIndex]
                                                                          
                                                                              Switch (([String]::IsNullOrEmpty($RequiredRequestParameter) -eq $False) -and ([String]::IsNullOrWhiteSpace($RequiredRequestParameter) -eq $False))
                                                                                {
                                                                                    {($_ -eq $True)}
                                                                                      {
                                                                                          Switch ($RequestParameterList.Contains($RequiredRequestParameter))
                                                                                            {
                                                                                                {($_ -eq $False)}
                                                                                                  {
                                                                                                      $RequestParameterList.Insert($RequiredRequestParametersIndex, $RequiredRequestParameter)
                                                                                                  }
                                                                                            }
                                                                                      }
                                                                                }
                                                                          }
                                                              
                                                                      #Load the specified request parameters
                                                                        For ($RequestParametersIndex = 0; $RequestParametersIndex -lt $RequestParameters.Count; $RequestParametersIndex++)
                                                                          {
                                                                              $RequestParameter = $RequestParameters[$RequestParametersIndex]
                                                                          
                                                                              Switch (([String]::IsNullOrEmpty($RequestParameter) -eq $False) -and ([String]::IsNullOrWhiteSpace($RequestParameter) -eq $False))
                                                                                {
                                                                                    {($_ -eq $True)}
                                                                                      {
                                                                                          Switch ($RequestParameterList.Contains($RequestParameter))
                                                                                            {
                                                                                                {($_ -eq $False)}
                                                                                                  {
                                                                                                      $RequestParameterList.Add($RequestParameter)
                                                                                                  }
                                                                                            }
                                                                                      }
                                                                                }
                                                                          }
                                                                  
                                                                    #region Dynamically build the API request URI
                                                                      $APIRequestURIList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
                                                                        $APIRequestURIList.Insert(0, "$($BaseURI.Scheme)://")
                                                                        $APIRequestURIList.Insert(1, "$($BaseURI.Host)")
                                                                        $APIRequestURIList.Insert(2, ":$($BaseURI.Port)")
                                                                        $APIRequestURIList.Insert(3, "$($BaseURI.AbsolutePath.TrimEnd('/'))")
                                                                        $APIRequestURIList.Insert(4, "/$($Endpoint)")
                                                                                                                                
                                                                      Switch (([String]::IsNullOrEmpty($SubURI) -eq $False) -and ([String]::IsNullOrWhiteSpace($SubURI) -eq $False))
                                                                        {
                                                                            {($_ -eq $True)}
                                                                              {
                                                                                  $APIRequestURIList.Add("/$($SubURI.OriginalString.TrimStart('/').TrimEnd('/'))")
                                                                              }     
                                                                        }
                                                                          
                                                                      $APIRequestURIList.Add("$($RequestParameterList -Join '&')")
                                                                      
                                                                      [System.URI]$APIRequestURI = $APIRequestURIList -Join ''
                                                                    #endregion
                                                                  
                                                                      $InvokeWebRequestHeaders = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                        $InvokeWebRequestHeaders.Authorization = "Bearer $($APIKey)"
                                                                  
                                                                      $InvokeWebRequestParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                        $InvokeWebRequestParameters.Method = $Method
                                                                        $InvokeWebRequestParameters.UseBasicParsing = $True
                                                                        $InvokeWebRequestParameters.Uri = $APIRequestURI
                                                                        $InvokeWebRequestParameters.UseDefaultCredentials = $True
                                                                        $InvokeWebRequestParameters.UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
                                                                        $InvokeWebRequestParameters.DisableKeepAlive = $False
                                                                        $InvokeWebRequestParameters.TimeoutSec = 60
                                                                        $InvokeWebRequestParameters.Headers = $InvokeWebRequestHeaders
                                                                        $InvokeWebRequestParameters.ContentType = 'application/json'
                                                                        $InvokeWebRequestParameters.Verbose = $False
                                                                        $InvokeWebRequestParameters.ErrorAction = [System.Management.Automation.Actionpreference]::Stop
                                                                        
                                                                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to execute API request. Please Wait..."
                                                                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                      
                                                                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - API Request URI: $($InvokeWebRequestParameters.Uri)"
                                                                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                      
                                                                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Method: $($InvokeWebRequestParameters.Method)"
                                                                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                      
                                                                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Page: $($Page)"
                                                                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                      
                                                                      $InvokeWebRequestStopWatch = New-Object -TypeName 'System.Diagnostics.StopWatch'
                                                                        
                                                                      $Null = $InvokeWebRequestStopWatch.Start()
                                      
                                                                      $InvokeWebRequestResult = Invoke-WebRequest @InvokeWebRequestParameters
                                                                      
                                                                      $Null = $InvokeWebRequestStopWatch.Stop()
                                                                      
                                                                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The API request completed in $($GetTimeSpanMessage.InvokeReturnAsIs($InvokeWebRequestStopWatch.Elapsed))"
                                                                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                                      
                                                                      Switch ($Null -ine $InvokeWebRequestResult)
                                                                        {
                                                                            {($_ -eq $True)}
                                                                              {
                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - API Request Status Code: $($InvokeWebRequestResult.StatusCode)"
                                                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                  
                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - API Request Status Description: $($InvokeWebRequestResult.StatusDescription)"
                                                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                  
                                                                                  Switch ($InvokeWebRequestResult.StatusCode)
                                                                                    {
                                                                                        {($_ -in @(200))}
                                                                                          {
                                                                                              $InvokeWebRequestResponse = $InvokeWebRequestResult.Content
                                                                                                                                          
                                                                                              Switch (([String]::IsNullOrEmpty($InvokeWebRequestResponse) -eq $False) -and ([String]::IsNullOrWhiteSpace($InvokeWebRequestResponse) -eq $False))
                                                                                                {
                                                                                                    {($_ -eq $True)}
                                                                                                      {
                                                                                                          $InvokeWebRequestResponseRecordList = $InvokeWebRequestResponse | ConvertFrom-JSON
                                                                                                          
                                                                                                          $InvokeWebRequestResponseRecordListCount = ($InvokeWebRequestResponseRecordList | Measure-Object).Count
                                                                                                          
                                                                                                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - API Request Record Count: $($InvokeWebRequestResponseRecordListCount)"
                                                                                                          Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                                                                                                  
                                                                                                          Switch ($InvokeWebRequestResponseRecordListCount -gt 0)
                                                                                                            {
                                                                                                                {($_ -eq $True)}
                                                                                                                  {
                                                                                                                      For ($InvokeWebRequestResponseRecordListIndex = 0; $InvokeWebRequestResponseRecordListIndex -lt $InvokeWebRequestResponseRecordListCount; $InvokeWebRequestResponseRecordListIndex++)
                                                                                                                        {
                                                                                                                            $InvokeWebRequestResponseRecord = $InvokeWebRequestResponseRecordList[$InvokeWebRequestResponseRecordListIndex]
                                      
                                                                                                                            $APIRequestRecordList.Add($InvokeWebRequestResponseRecord)
                                                                                                                        }
                                                                                                                      
                                                                                                                      Switch ($InvokeWebRequestResponseRecordListCount -lt $Limit)
                                                                                                                        {
                                                                                                                            {($_ -eq $True)}
                                                                                                                              {
                                                                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - No more API pagination request(s) are required. Exiting loop."
                                                                                                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                                                          
                                                                                                                                  Break APIRequestPagingLoop
                                                                                                                              }
                                                                                                                  
                                                                                                                            Default
                                                                                                                              {
                                                                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - More API pagination request(s) are required. Continuing loop."
                                                                                                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                                                                  
                                                                                                                                  $CurrentAPIRequestPage = $Page
                                                                                                                                  
                                                                                                                                  $Page++
                                                                                                                                  
                                                                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The API pagination request will be incremented from $($CurrentAPIRequestPage) to $($Page)."
                                                                                                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                                                                  
                                                                                                                                  Continue APIRequestPagingLoop
                                                                                                                              }
                                                                                                                        }
                                                                                                                  }
                                                                                                                  
                                                                                                                Default
                                                                                                                  {
                                                                                                                      Break APIRequestPagingLoop
                                                                                                                  }
                                                                                                            }
                                                                                                      }
                                                                                                }
                                                                                          }
                                      
                                                                                        {($_ -in @(429))}
                                                                                          {
                                                                                              [System.TimeSpan]$CountdownDuration = [System.TimeSpan]::FromSeconds(60)
                                                                                      
                                                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The API request rate limit was execeeded. Waiting $($CountdownDuration.TotalSeconds) second(s) before attempting a retry."
                                                                                              Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                                      
                                                                                              For ($SecondsRemaining = $CountdownDuration.TotalSeconds; $SecondsRemaining -gt 0; $SecondsRemaining--)
                                                                                                {
                                                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - $($SecondsRemaining) second(s) remaining. Please Wait..."
                                                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                                                    
                                                                                                    $Null = Start-Sleep -Seconds 1
                                                                                                }
                                                                          
                                                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting API request retry. Please Wait..."
                                                                                              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                                      
                                                                                              Continue APIRequestPagingLoop
                                                                                          }
                                                                                          
                                                                                        Default
                                                                                          {
                                                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The API request status code is unhandled."
                                                                                              Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                                                                                              
                                                                                              Break APIRequestPagingLoop
                                                                                          }
                                                                                    }
                                                                              }
                                                                              
                                                                            Default
                                                                              {
                                                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The API request response is invalid. No further action will be taken."
                                                                                  Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                                                                          
                                                                                  Break APIRequestPagingLoop
                                                                              }
                                                                        }
                                                                  }
                                                                Catch
                                                                  {
                                                                      $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                                                                  }
                                                                Finally
                                                                  {
                                                                      Try {$Null = $InvokeWebRequestStopWatch.Stop()} Catch {}
                                                                      Try {$Null = $InvokeWebRequestStopWatch.Reset()} Catch {}
                                                                  }
                                                            }

                                                          $Null = $APIRequestRecordList.TrimExcess()
                    
                                                          Write-Output -InputObject ($APIRequestRecordList.ToArray())
                                                      }
                    
                    $OutputObjectList = $ExecuteAPIRequest.InvokeReturnAsIs($OrganizationID, $APIKey, $Endpoint, $Method, $BaseURI, $SubURI, $RequestParameters, $Page, $Limit)
                      
                    $OutputObjectListCount = ($OutputObjectList | Measure-Object).Count
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    
                }
          }
        
        End
          {                                        
              Try
                {
                    #region Request associated data from the API based on the specified endpoint
                      Switch ($RequestAssociatedData)
                        {
                            {($_ -eq $True)}
                              {                           
                                  For ($OutputObjectListIndex = 0; $OutputObjectListIndex -lt $OutputObjectListCount; $OutputObjectListIndex++)
                                    {
                                        Try
                                          {
                                              $OutputObject = $OutputObjectList[$OutputObjectListIndex]

                                              Switch ($Endpoint)
                                                {
                                                    {($_ -iin @('servers'))}
                                                      {
                                                          $OutputObject | Add-Member -Name 'SoftwareList' -Value $Null -MemberType NoteProperty -Force
                                                  
                                                          $OutputObject.SoftwareList = $ExecuteAPIRequest.Invoke($OrganizationID, $APIKey, $Endpoint, $Method, $BaseURI, "/$($OutputObject.id)/packages", $RequestParameters, $Page, $Limit)
                                                          
                                                          
                                                      }
                                                }
                                          }
                                        Catch
                                          {
                                              $ErrorHandlingDefinition.Invoke(2, $True)
                                          }
                                        Finally
                                          {
                                              
                                          }
                                    }
                              }
                        }
                    #endregion

                    #region Perform optional subselection of results
                      Switch ($OutputObjectListCount -gt 0)
                        {
                            {($_ -eq $True)}
                              {                                
                                  #region Perform data subselection on the API request results
                                    $SelectObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'

                                    Switch ($True)
                                      {
                                          {($PropertyInclusionList.Count -gt 0)}
                                            {
                                                $SelectObjectParameters.Property = $PropertyInclusionList
                                            }

                                          {($PropertyInclusionList.Count -eq 0)}
                                            {
                                                $SelectObjectParameters.Property = New-Object -TypeName 'System.Collections.Generic.List[System.Object]'
                                                  $SelectObjectParameters.Property.Add('*')
                                            }

                                          {($PropertyExclusionList.Count -gt 0)}
                                            {
                                                $SelectObjectParameters.ExcludeProperty = $PropertyExclusionList
                                            }
                                      }
	
                                    $OutputObjectList = $OutputObjectList | Select-Object @SelectObjectParameters
                                  #endregion
                              }
                        }
                    #endregion

                    #region Optionally export the results to the specified format
                      Switch ($Export.IsPresent)                                                                                                                                                                                                                                                                   {
                          {($_ -eq $True)}
                            {                          
                                Switch ($OutputObjectListCount -gt 0)
                                  {
                                      {($_ -eq $True)}
                                        {
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to export $($OutputObjectListCount) Automox API request results to $($ExportFormat.ToUpper()) format. Please Wait..."
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                                            
                                            Switch ($ExportFormat)
                                              {
                                                  {($_ -iin @('CSV'))}
                                                    {
                                                        [String]$OutputObjectListContent = $OutputObjectList | ConvertTo-CSV -Delimiter ',' -NoTypeInformation
                                                    }
                                          
                                                  {($_ -iin @('JSON'))}
                                                    {
                                                        [String]$OutputObjectListContent = $OutputObjectList | ConvertTo-JSON -Depth 10 -Compress:$True
                                                    }

                                                  {($_ -iin @('XML'))}
                                                    {
                                                        ####ToDo: Will be added at a later time
                                                    }
                                              }

                                            [System.String]$FileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
                                            [System.String]$FileExtension = [System.IO.Path]::GetExtension($FileName)
                                            
                                            Switch ($FileExtension.ToLower() -ine $ExportFormat.ToLower())
                                              {
                                                  {($_ -eq $True)}
                                                    {
                                                        [System.String]$FileExtension = $ExportFormat.ToLower()
                                                    }
                                              }

                                            Switch ($True)
                                              {
                                                  {($AppendDate.IsPresent -eq $True)}
                                                    {                                                        
                                                        [System.IO.FileInfo]$ExportPath = "$($ExportDirectory.FullName)\$($FileBaseName)_$($GetCurrentDateTimeFileFormat.InvokeReturnAsIs()).$($FileExtension)"
                                                    }

                                                  Default
                                                    {
                                                        [System.IO.FileInfo]$ExportPath = "$($ExportDirectory.FullName)\$($FileBaseName).$($FileExtension)"
                                                    }
                                              }
                                              
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Export Path: $($ExportPath.FullName)"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)
                                            
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Encoding: $($Encoding)"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)

                                            Switch ([System.IO.Directory]::Exists($ExportPath.Directory.FullName))
                                              {
                                                  {($_ -eq $False)}
                                                    {
                                                        $Null = [System.IO.Directory]::CreateDirectory($ExportPath.Directory.FullName)
                                                    }
                                              }

                                            $Null = [System.IO.File]::WriteAllText($ExportPath.FullName, $OutputObjectListContent, $Encoding)
                                        }
                              
                                      Default
                                        {
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The Automox API request results will not be exported to $($ExportFormat.ToUpper()) because the object is empty."
                                            Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                                        }
                                  }
                            }
                      }
                    #endregion
                
                    #Determine the date and time the function completed execution
                      $FunctionEndTime = (Get-Date)

                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Execution of $($FunctionName) ended on $($FunctionEndTime.ToString($DateTimeLogFormat))"
                      Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                    #Log the total script execution time  
                      $FunctionExecutionTimespan = New-TimeSpan -Start ($FunctionStartTime) -End ($FunctionEndTime)

                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function execution took $($GetTimeSpanMessage.InvokeReturnAsIs($FunctionExecutionTimespan))"
                      Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                    
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function `'$($FunctionName)`' is completed."
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    Write-Output -InputObject ($OutputObjectList)
                }
          }
    }
#endregion