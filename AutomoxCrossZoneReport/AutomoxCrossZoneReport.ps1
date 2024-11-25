#Requires -Version 3

<#
    .SYNOPSIS
    Queries the Automox API for the specified organization, gets a list of the associated zones, and calculates the patching compliance for each zone. The results are then exported to a CSV.
          
    .DESCRIPTION
    This script can also be enabled to run as a scheduled task, so that the data stays updated, and therefore any dashboard built on the exported CSV would be as well.
          
    .PARAMETER OrganizationID
    A valid Automox organization ID. This might take the form of a number or a GUID.

    .PARAMETER APIKey
    A valid Automox API key that is associated with the specified organization ID.

    .PARAMETER ZoneFilterExpression
    A valid powershell script block that allows for the filtering of associated zones.

    Example: {($_.Name -imatch '(^.*$)') -and ($_.Name -inotmatch '(^.{0,0}$)')} = All zones whose name match anything, and no zones whose names are empty.

    .PARAMETER PolicyTypeList
    One or more policy types to filter on. By default, only patch policies are returned

    .PARAMETER DateRange
    A valid value between 1 and 90 days. By default. patching compliance will be calculated over 90 days.

    .PARAMETER Export
    Specifies whether or not to export the data returned by this script to CSV. By default, the data will be exported.

    .PARAMETER ExportDirectory
    A valid directory where the API request data will be exported. If the specified directory does not exist, it will be automatically created.

    .PARAMETER ExecutionMode
    A valid execution mode for script operation. Maybe any one of 'Execute', 'CreateScheduledTask', or 'RemoveScheduledTask'. By default, 'Execute' will be specified value.

    .PARAMETER LogDirectory
    A valid directory where the script logs will be located. By default, the logs will be stored under the logs folder within the script directory.

    .PARAMETER ContinueOnError
    Specifies whether to ignore fatal errors.

    .PARAMETER LogDir
    A valid folder path. If the folder does not exist, it will be created. This parameter can also be specified by the alias "LogPath".

    .PARAMETER ContinueOnError
    Ignore failures.
          
    .EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID 'YourOrganizationID' -APIKey "YourAPIKey"

    .EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "Execute"
    
    .EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "CreateScheduledTask"
  
    .EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -File "C:\FolderPathContainingScript\AutomoxCrossZoneReport.ps1" -OrganizationID "YourOrganizationID" -APIKey "YourAPIKey" -ExecutionMode "RemoveScheduledTask"
    
    .NOTES
    The exported CSV(s) can then be used as a data source with any BI software such as Grafana or PowerBI in order to create a bar graph to show the results.

    Fully compatible with Powershell 7.

    Example CSV Output

    "ZoneName","ZoneID","ZoneUUID","ZoneDeviceCount","Success","SuccessPercentage","Failed","FailedPercentage"
    "Zone001","45746755","f4960637-65b9-4ca8-b282-c3b4e464fa0f","3","0","0","0","0"
    "Zone002","56485764","2c495f43-72de-48cc-ab1b-637d8e5d098a","0","0","0","0","0"
    "Zone003","23424234","824fc1a8-1d18-4c25-98d9-740f1a8b85ad","13","2","66.67","1","33.33"
    "Zone004","68796758","439977ff-497c-45cb-8e56-dd58b879d456","0","0","0","0","0"
    "Zone005","43575764","ac36bbe7-13d1-4221-8d29-bbdca343a82d","5","10","41.67","14","58.33"
    "Zone006","69845455","444a4f28-a297-427e-abd7-004f502ec63f","7","74","89.16","9","10.84"

    Heavily leverages the included "Get-AutomoxAPIObject" function in order to query the Automox API. The function will be automatically imported for usage during script execution.
          
    .LINK
    https://developer.automox.com/openapi/policy-history/operation/allPolicyExecutions
#>

[CmdletBinding(SupportsShouldProcess=$True, DefaultParameterSetName = '__DefaultParameterSetName')]
  Param
    (        	                 
        [Parameter(Mandatory=$True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('OID')]
        [System.String]$OrganizationID,

        [Parameter(Mandatory=$True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [Alias('Key')]
        [System.String]$APIKey,
        
        [Parameter(Mandatory=$False, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [Alias('OFE')]
        [System.Management.Automation.ScriptBlock]$ZoneFilterExpression,
                
        [Parameter(Mandatory=$False, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [Alias('PTL')]
        [ValidateSet('custom', 'patch', 'required_software')]
        [System.String[]]$PolicyTypeList,
        
        [Parameter(Mandatory=$False, Position = 4)]
        [ValidateNotNullOrEmpty()]
        [Alias('DR')]
        [ValidateRange(1, 90)]
        [System.Int16]$DateRange,

        [Parameter(Mandatory=$False, Position = 5, ParameterSetName = 'Export')]
        [Alias('E')]
        [Switch]$Export = $True,
  
        [Parameter(Mandatory=$False, Position = 6, ParameterSetName = 'Export')]
        [ValidateNotNullOrEmpty()]
        [Alias('ED')]
        [System.IO.DirectoryInfo]$ExportDirectory,

        [Parameter(Mandatory=$False, Position = 7)]
        [ValidateNotNullOrEmpty()]
        [Alias('EM')]
        [ValidateSet('Execute', 'CreateScheduledTask', 'RemoveScheduledTask')]
        [System.String]$ExecutionMode,
                        
        [Parameter(Mandatory=$False, Position = 8)]
        [ValidateNotNullOrEmpty()]
        [Alias('LogDir', 'LD')]
        [System.IO.DirectoryInfo]$LogDirectory,
            
        [Parameter(Mandatory=$False, Position = 9)]
        [Alias('COE')]
        [Switch]$ContinueOnError
    )
        
Function Test-ProcessElevationStatus
  {
      $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
      $Principal = New-Object -TypeName 'System.Security.Principal.WindowsPrincipal' -ArgumentList ($Identity)
      $Result = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

      Write-Output -InputObject ($Result)
  }

Switch (Test-ProcessElevationStatus)
  {
      Default
        {
            #Determine the date and time we executed the function
              $ScriptStartTime = (Get-Date)
  
            #Define Default Action Preferences
                $Script:DebugPreference = 'SilentlyContinue'
                $Script:ErrorActionPreference = 'Stop'
                $Script:VerbosePreference = 'SilentlyContinue'
                $Script:WarningPreference = 'Continue'
                $Script:ConfirmPreference = 'None'
                $Script:WhatIfPreference = $False
    
            #Load WMI Classes
              $OperatingSystem = Get-CIMInstance -Namespace "root\CIMv2" -ClassName "Win32_OperatingSystem" -Property *

            #Retrieve property values
              $OSArchitecture = $($OperatingSystem.OSArchitecture).Replace("-bit", "").Replace("32", "86").Insert(0,"x").ToUpper()

            #Define variable(s)
              $DateTimeLogFormat = 'dddd, MMMM dd, yyyy @ hh:mm:ss tt (UTC)'  ###Monday, January 01, 2019 @ 10:15:34.000 AM###
              [ScriptBlock]$GetCurrentDateTimeLogFormat = {(Get-Date).ToString($DateTimeLogFormat)}
              $DateTimeMessageFormat = 'MM/dd/yyyy HH:mm:ss.FFF'  ###03/23/2022 11:12:48.347###
              [ScriptBlock]$GetCurrentDateTimeMessageFormat = {(Get-Date).ToString($DateTimeMessageFormat)}
              $DateFileFormat = 'yyyyMMdd'  ###20190403###
              [ScriptBlock]$GetCurrentDateFileFormat = {(Get-Date).ToString($DateFileFormat)}
              $DateTimeFileFormat = 'yyyyMMdd_HHmmss'  ###20190403_115354###
              [ScriptBlock]$GetCurrentDateTimeFileFormat = {(Get-Date).ToString($DateTimeFileFormat)}
              [System.IO.FileInfo]$ScriptPath = "$($MyInvocation.MyCommand.Definition)"
              [System.IO.DirectoryInfo]$ScriptDirectory = "$($ScriptPath.Directory.FullName)"
              [System.IO.DirectoryInfo]$ModulesDirectory = "$($ScriptDirectory.FullName)\Modules"
              [System.IO.DirectoryInfo]$FunctionsDirectory = "$($ScriptDirectory.FullName)\Functions"
              [System.IO.DirectoryInfo]$System32Directory = "$([System.Environment]::SystemDirectory)"
              [ScriptBlock]$GetRandomGUID = {[System.GUID]::NewGUID().GUID.ToString().ToUpper()}
              [String]$ParameterSetName = "$($PSCmdlet.ParameterSetName)"
              $TextInfo = (Get-Culture).TextInfo
              $Script:LASTEXITCODE = 0
              $TerminationCodes = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                $TerminationCodes.Add('Success', @(0))
                $TerminationCodes.Add('Warning', @(5000..5999))
                $TerminationCodes.Add('Error', @(6000..6999))
              $LoggingDetails = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'    
                $LoggingDetails.Add('LogMessage', $Null)
                $LoggingDetails.Add('WarningMessage', $Null)
                $LoggingDetails.Add('ErrorMessage', $Null)
              $RegexOptionList = New-Object -TypeName 'System.Collections.Generic.List[System.Text.RegularExpressions.RegexOptions]'
                $RegexOptionList.Add('IgnoreCase')
                $RegexOptionList.Add('Multiline')
              $RegularExpressionTable = New-Object -TypeName 'System.Collections.Generic.Dictionary[[String], [System.Text.RegularExpressions.Regex]]'
                $RegularExpressionTable.Base64 = New-Object -TypeName 'System.Text.RegularExpressions.Regex' -ArgumentList @('^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$', $RegexOptionList.ToArray())
              $CommonParameterList = New-Object -TypeName 'System.Collections.Generic.List[String]'
                $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::CommonParameters)
                $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::OptionalCommonParameters)
              $TextEncoder = [System.Text.Encoding]::Default

              #Define the error handling definition
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
                                                              $ExceptionPropertyDictionary.Code = Try {$_.InvocationInfo.Line.Trim()} Catch {$Null}

                                                            $ExceptionMessageList = New-Object -TypeName 'System.Collections.Generic.List[String]'

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
                                                              $LogMessageParameters.Message = $ExceptionMessageList -Join ' '
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
                                                                        If (($Null -ieq $Script:LASTEXITCODE) -or ($Script:LASTEXITCODE -eq 0))
                                                                          {
                                                                              [Int]$Script:LASTEXITCODE = 6000

                                                                              [System.Environment]::ExitCode = $Script:LASTEXITCODE
                                                                          }
                                                                    
                                                                        Throw
                                                                    }
                                                              }
                                                        }
	            
            #Determine default parameter value(s)       
              Switch ($True)
                {
                    {([String]::IsNullOrEmpty($ExecutionMode) -eq $True) -or ([String]::IsNullOrWhiteSpace($ExecutionMode) -eq $True)}
                      {
                          [System.String]$ExecutionMode = 'Execute'
                      }

                    {([String]::IsNullOrEmpty($ExportDirectory) -eq $True) -or ([String]::IsNullOrWhiteSpace($ExportDirectory) -eq $True)}
                      {
                          [System.IO.DirectoryInfo]$ExportDirectory = "$($ScriptDirectory.FullName)\APIData"
                      }
    
                    {([String]::IsNullOrEmpty($LogDirectory) -eq $True) -or ([String]::IsNullOrWhiteSpace($LogDirectory) -eq $True)}
                      {
                          [System.IO.DirectoryInfo]$LogDirectory = "$($ScriptDirectory.FullName)\Logs"
                      }
                      
                    {($Null -ieq $PolicyTypeList) -or ($PolicyTypeList.Count -eq 0)}
                      {
                          [System.String[]]$PolicyTypeList = @('patch')
                      }
                      
                    {($Null -ieq $DateRange) -or ($DateRange -eq 0)}
                      {
                          [System.Int16]$DateRange = 90
                      }

                    {($Null -ieq $ZoneFilterExpression)}
                      {
                          [System.Management.Automation.ScriptBlock]$ZoneFilterExpression = {($_.Name -imatch '(^.*$)') -and ($_.Name -inotmatch '(^.{0,0}$)')}
                      }      
                }

            #Start transcripting (Logging)
              [System.IO.FileInfo]$ScriptLogPath = "$($LogDirectory.FullName)\$($ScriptPath.BaseName)_$($ExecutionMode)_$($GetCurrentDateTimeFileFormat.Invoke()).log"
              If ($ScriptLogPath.Directory.Exists -eq $False) {$Null = [System.IO.Directory]::CreateDirectory($ScriptLogPath.Directory.FullName)}
              Start-Transcript -Path "$($ScriptLogPath.FullName)" -Force -WhatIf:$False
	
            #Log any useful information                                     
              [String]$CmdletName = $MyInvocation.MyCommand.Name
                                                   
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Execution of script `"$($CmdletName)`" began on $($ScriptStartTime.ToString($DateTimeLogFormat))"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Script Path = $($ScriptPath.FullName)"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

              $AvailableScriptParameterList = (Get-Command -Name ($ScriptPath.FullName)).Parameters.GetEnumerator() | Where-Object {($_.Value.Name -inotin $CommonParameterList)}

              [String[]]$AvailableScriptParameters = $AvailableScriptParameterList | ForEach-Object {"-$($_.Value.Name):$($_.Value.ParameterType.Name)"}
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Available Script Parameter(s) = $($AvailableScriptParameters -Join ', ')"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

              [String[]]$SuppliedScriptParameters = $PSBoundParameters.GetEnumerator() | ForEach-Object {Try {"-$($_.Key):$($_.Value.GetType().Name)"} Catch {"-$($_.Key):Unknown"}}
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Supplied Script Parameter(s) = $($SuppliedScriptParameters -Join ', ')"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
              
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Process Command Line: $([System.Environment]::CommandLine)"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
          
              Switch ($True)
                {
                    {([String]::IsNullOrEmpty($ParameterSetName) -eq $False) -and ([String]::IsNullOrWhiteSpace($ParameterSetName) -eq $False)}
                      {
                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Parameter Set Name = $($ParameterSetName)"
                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                      }
                }
                
              $ExecutionPolicyList = Get-ExecutionPolicy -List
  
              For ($ExecutionPolicyListIndex = 0; $ExecutionPolicyListIndex -lt $ExecutionPolicyList.Count; $ExecutionPolicyListIndex++)
                {
                    $ExecutionPolicy = $ExecutionPolicyList[$ExecutionPolicyListIndex]

                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The powershell execution policy is currently set to `"$($ExecutionPolicy.ExecutionPolicy.ToString())`" for the `"$($ExecutionPolicy.Scope.ToString())`" scope."
                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                }

            #region Ensure that the version of Powershell is adequate for proper execution
              [System.Version]$MinimumPowershellVersion = '3.0.0.0'
              [System.Version]$CurrentPowershellVersion = $PSVersionTable.PSVersion
                      
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Minimum Powershell Version: $($MinimumPowershellVersion)"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose:$False
                    
              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Current Powershell Version: $($CurrentPowershellVersion)"
              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose:$False
                    
              Switch (($CurrentPowershellVersion.Major -lt $MinimumPowershellVersion.Major) -and ($CurrentPowershellVersion.Minor -lt $MinimumPowershellVersion.Minor) -and ($CurrentPowershellVersion.Build -ge $MinimumPowershellVersion.Build) -and ($CurrentPowershellVersion.Revision -ge $MinimumPowershellVersion.Revision))
                {
                    {($_ -eq $True)}
                      {
                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Minimum Powershell version has not been met. No further action will be taken."
                          Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                          
                          $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                      }
                              
                    Default
                      {
                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The minimum Powershell version requirement has been met."
                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose:$False
                      }
                }
            #endregion
    
            #region Log Cleanup
              [Int]$MaximumLogHistory = 3
          
              $LogList = Get-ChildItem -Path ($LogDirectory.FullName) -Filter "$($ScriptPath.BaseName)_*" -Recurse -Force | Where-Object {($_ -is [System.IO.FileInfo])}

              $SortedLogList = $LogList | Sort-Object -Property @('LastWriteTime') -Descending | Select-Object -Skip ($MaximumLogHistory)

              Switch ($SortedLogList.Count -gt 0)
                {
                    {($_ -eq $True)}
                      {
                          $LoggingDetails.WarningMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - There are $($SortedLogList.Count) log file(s) requiring cleanup."
                          Write-Warning -Message ($LoggingDetails.WarningMessage) -Verbose
                      
                          For ($SortedLogListIndex = 0; $SortedLogListIndex -lt $SortedLogList.Count; $SortedLogListIndex++)
                            {
                                Try
                                  {
                                      $Log = $SortedLogList[$SortedLogListIndex]

                                      $LogAge = New-TimeSpan -Start ($Log.LastWriteTime) -End (Get-Date)

                                      $LoggingDetails.WarningMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to cleanup log file `"$($Log.FullName)`". Please Wait... [Last Modified: $($Log.LastWriteTime.ToString($DateTimeMessageFormat))] [Age: $($LogAge.Days.ToString()) day(s); $($LogAge.Hours.ToString()) hours(s); $($LogAge.Minutes.ToString()) minute(s); $($LogAge.Seconds.ToString()) second(s)]."
                                      Write-Warning -Message ($LoggingDetails.WarningMessage) -Verbose
                  
                                      $Null = [System.IO.File]::Delete($Log.FullName)
                                  }
                                Catch
                                  {
                  
                                  }   
                            }
                      }

                    Default
                      {
                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - There are $($SortedLogList.Count) log file(s) requiring cleanup."
                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                      }
                }
            #endregion

            #region Import Dependency Modules
              If (($ModulesDirectory.Exists -eq $True) -and ($ModulesDirectory.GetDirectories().Count -gt 0))
                {
                    Switch ($ModulesDirectory.FullName.StartsWith('\\'))
                      {
                          {($_ -eq $True)}
                            {
                                [System.IO.DirectoryInfo]$ModuleCacheRootDirectory = "$($Env:Windir)\Temp\PSMCache"
                            
                                $ModuleDirectoryList = $ModulesDirectory.GetDirectories()

                                $ModuleDirectoryListCount = ($ModuleDirectoryList | Measure-Object).Count

                                For ($ModuleDirectoryListIndex = 0; $ModuleDirectoryListIndex -lt $ModuleDirectoryListCount; $ModuleDirectoryListIndex++)
                                  {
                                      $ModuleDirectoryListItem = $ModuleDirectoryList[$ModuleDirectoryListIndex]

                                      $ModuleCacheDirectory = New-Object -TypeName 'System.IO.DirectoryInfo' -ArgumentList "$($ModuleCacheRootDirectory.FullName)\$($ModuleDirectoryListItem.Name)"

                                      Switch ([System.IO.Directory]::Exists($ModuleCacheDirectory.FullName))
                                        {
                                            {($_ -eq $True)}
                                              {
                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Skipping the local cache of the powershell module `"$($ModuleDirectoryListItem.Name)`". [Reason: The powershell module has already been cached.]"
                                                  Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                              }
                                        
                                            {($_ -eq $False)}
                                              {
                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to locally cache the powershell module `"$($ModuleDirectoryListItem.Name)`". Please Wait..."
                                                  Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                                  If ([System.IO.Directory]::Exists($ModuleCacheDirectory.FullName) -eq $False) {$Null = [System.IO.Directory]::CreateDirectory($ModuleCacheDirectory.FullName)}

                                                  $Null = Start-Sleep -Milliseconds 500
                                              
                                                  $NUll = Copy-Item -Path "$($ModuleDirectoryListItem.FullName)\*" -Destination "$($ModuleCacheDirectory.FullName)\" -Recurse -Force -Verbose:$False  
                                              }
                                        }
                                  }

                                [System.IO.DirectoryInfo]$ModulesDirectory = $ModuleCacheRootDirectory.FullName
                            }
                      }
                
                    $AvailableModules = Get-Module -Name "$($ModulesDirectory.FullName)\*" -ListAvailable -ErrorAction Stop 

                    $AvailableModuleGroups = $AvailableModules | Group-Object -Property @('Name')

                    ForEach ($AvailableModuleGroup In $AvailableModuleGroups)
                      {
                          $LatestAvailableModuleVersion = $AvailableModuleGroup.Group | Sort-Object -Property @('Version') -Descending | Select-Object -First 1
      
                          If ($Null -ine $LatestAvailableModuleVersion)
                            {
                                Switch ($LatestAvailableModuleVersion.RequiredModules.Count -gt 0)
                                  {
                                      {($_ -eq $True)}
                                        {
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - $($LatestAvailableModuleVersion.RequiredModules.Count) prerequisite powershell module(s) need to be imported before the powershell of `"$($LatestAvailableModuleVersion.Name)`" can be imported."
                                            Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Prequisite Module List: $($LatestAvailableModuleVersion.RequiredModules.Name -Join '; ')"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                        
                                            ForEach ($RequiredModule In $LatestAvailableModuleVersion.RequiredModules)
                                              {
                                                  Switch ($RequiredModule.Name -iin $AvailableModules.Name)
                                                    {
                                                        {($_ -eq $True)}
                                                          {
                                                              Switch ($Null -ine (Get-Module -Name $RequiredModule.Name -ErrorAction SilentlyContinue))
                                                                {
                                                                    {($_ -eq $True)}
                                                                      {
                                                                          $RequiredModuleDetails = $AvailableModules | Where-Object {($_.Name -ieq $RequiredModule.Name)}
                                                                      
                                                                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import prerequisite powershell module `"$($RequiredModuleDetails.Name)`" [Version: $($RequiredModuleDetails.Version.ToString())]. Please Wait..."
                                                                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                                                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Prerequisite Module Path: $($RequiredModuleDetails.ModuleBase)"
                                                                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                      
                                                                          $Null = Import-Module -Name "$($RequiredModuleDetails.Path)" -Global -DisableNameChecking -Force -ErrorAction Stop 
                                                                      }
                                                                }     
                                                          }
                                                    }
                                              }
                                        }
                                  }
 
                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import dependency powershell module `"$($LatestAvailableModuleVersion.Name)`" [Version: $($LatestAvailableModuleVersion.Version.ToString())]. Please Wait..."
                                Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Module Path: $($LatestAvailableModuleVersion.Path)"
                                Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                $Null = Import-Module -Name "$($LatestAvailableModuleVersion.Path)" -Global -DisableNameChecking -Force -ErrorAction Stop
                            }
                      }
                }
            #endregion
        
            #region Dot Source Dependency Scripts
              #Dot source any additional script(s) from the functions directory. This will provide flexibility to add additional functions without adding complexity to the main script and to maintain function consistency.
                Try
                  {
                      If ($FunctionsDirectory.Exists -eq $True)
                        {
                            $AdditionalFunctionsFilter = New-Object -TypeName 'System.Collections.Generic.List[String]'
                              $AdditionalFunctionsFilter.Add('*.ps1')
        
                            $AdditionalFunctionsToImport = Get-ChildItem -Path "$($FunctionsDirectory.FullName)" -Include ($AdditionalFunctionsFilter) -Recurse -Force | Where-Object {($_ -is [System.IO.FileInfo])}
        
                            $AdditionalFunctionsToImportCount = $AdditionalFunctionsToImport | Measure-Object | Select-Object -ExpandProperty Count
        
                            If ($AdditionalFunctionsToImportCount -gt 0)
                              {                    
                                  ForEach ($AdditionalFunctionToImport In $AdditionalFunctionsToImport)
                                    {
                                        Try
                                          {
                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to dot source the functions contained within the dependency script `"$($AdditionalFunctionToImport.Name)`". Please Wait... [Script Path: `"$($AdditionalFunctionToImport.FullName)`"]"
                                              Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                          
                                              . "$($AdditionalFunctionToImport.FullName)"
                                          }
                                        Catch
                                          {
                                              $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                                          }
                                    }
                              }
                        }
                  }
                Catch
                  {
                      $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                  }
            #endregion

            #Perform script action(s)
              Try
                {                                      
                    $ScheduledTaskSettings = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                      $ScheduledTaskSettings.Folder = "\Automox"
                      $ScheduledTaskSettings.Name = $ScriptPath.BaseName
                      $ScheduledTaskSettings.ScriptName = $ScriptPath.Name
                      $ScheduledTaskSettings.Source = $ScriptDirectory.FullName
                      $ScheduledTaskSettings.Destination = "$($Env:ProgramData)\ScheduledTasks\Automox\$([System.IO.Path]::GetFileNameWithoutExtension($ScheduledTaskSettings.ScriptName))\APIData"
                
                    Switch ($ExecutionMode)
                      {    
                          Default
                            {                                                                                                                  
                                $OutputObjectProperties = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $OutputObjectProperties.PolicySuccessRatePerZone = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.PSObject]'
                        
                                [String]$APIDateFormat = 'yyyy-MM-ddThh:mm:ssZ'
                                [DateTime]$CurrentDate = (Get-Date).Date.ToUniversalTime()
                                [DateTime]$StartTime = $CurrentDate.AddDays(-($DateRange)).AddDays(1).AddTicks(-1)
                                [DateTime]$EndTime = $CurrentDate.AddDays(1).AddTicks(-1)
                        
                                $GetAutomoxAPIObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $GetAutomoxAPIObjectParameters.OrganizationID = $OrganizationID
                                  $GetAutomoxAPIObjectParameters.APIKey = $APIKey
                                  $GetAutomoxAPIObjectParameters.Endpoint = 'orgs'
                                  $GetAutomoxAPIObjectParameters.ContinueOnError = $False
                                  $GetAutomoxAPIObjectParameters.Verbose = $True
                              
                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to retrieve the list of Automox zone(s) associated with organization ID $($OrganizationID). Please Wait..."
                                Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                           
                                $AutomoxZoneList = Get-AutomoxAPIObject @GetAutomoxAPIObjectParameters 
                
                                $AutomoxZoneListCount = ($AutomoxZoneList | Measure-Object).Count
                  
                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The Automox zone API request returned $($AutomoxZoneListCount) result(s)."
                                Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                      
                                Switch ($AutomoxZoneListCount -gt 0)                                                                                                                                                                                                                                                                                                                                                                                                                 
                                  {
                                      {($_ -eq $True)}
                                        {
                                            $AutomoxZoneListCounter = 1
                
                                            For ($AutomoxZoneListIndex = 0; $AutomoxZoneListIndex -lt $AutomoxZoneListCount; $AutomoxZoneListIndex++)
                                              {  
                                                  Try
                                                    {
                                                        $AutomoxZone = $AutomoxZoneList[$AutomoxZoneListIndex]
                                                        
                                                        Switch ([Boolean]($AutomoxZone | Where-Object -FilterScript $ZoneFilterExpression))
                                                          {
                                                              {($_ -eq $True)}
                                                                {
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to process Automox zone $($AutomoxZoneListCounter) of $($AutomoxZoneListCount). Please Wait..."
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                        
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Zone Name: $($AutomoxZone.Name)"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                        
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Zone ID: $($AutomoxZone.ID)"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                        
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Zone UUID: $($AutomoxZone.UUID)"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                    
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Zone Device Count: $($AutomoxZone.device_count)"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                    
                                                                    [Int]$ProgressID = 1
                                                                    [String]$ActivityMessage = "$($AutomoxZoneListCounter) of $($AutomoxZoneListCount) - $($AutomoxZone.Name) [ID: $($AutomoxZone.ID)] [Device Count: $($AutomoxZone.device_count)]"
                                                                    [String]$StatusMessage = "Processing policy execution history. Please Wait..."
                                                                    [Int]$PercentComplete = (($AutomoxZoneListCounter / $AutomoxZoneListCount) * 100)
                              
                                                                    Write-Progress -ID ($ProgressID) -Activity ($ActivityMessage) -Status ($StatusMessage) -PercentComplete ($PercentComplete)
                                                                    
                                                                    $PolicySuccessRatePerZoneObjectProperties = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                      $PolicySuccessRatePerZoneObjectProperties.ZoneName = $AutomoxZone.Name
                                                                      $PolicySuccessRatePerZoneObjectProperties.ZoneID = $AutomoxZone.ID
                                                                      $PolicySuccessRatePerZoneObjectProperties.ZoneUUID = $AutomoxZone.UUID
                                                                      $PolicySuccessRatePerZoneObjectProperties.ZoneDeviceCount = $AutomoxZone.device_count
                                                                                                                                                                                                                                                                   
                                                                    $GetAutomoxAPIObjectParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                      $GetAutomoxAPIObjectParameters.OrganizationID = $AutomoxZone.UUID
                                                                      $GetAutomoxAPIObjectParameters.APIKey = $APIKey
                                                                      $GetAutomoxAPIObjectParameters.Endpoint = 'policy-history'
                                                                      $GetAutomoxAPIObjectParameters.SubURI = 'policy-runs'
                                                                      $GetAutomoxAPIObjectParameters.RequestParameters = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
                                                                        $GetAutomoxAPIObjectParameters.RequestParameters.Add("start_time=$($StartTime.ToString($APIDateFormat))")
                                                                        $GetAutomoxAPIObjectParameters.RequestParameters.Add("end_time=$($EndTime.ToString($APIDateFormat))")
                                                                        $GetAutomoxAPIObjectParameters.RequestParameters.Add("policy_type:in=$($PolicyTypeList -Join ',')")
                                                                      $GetAutomoxAPIObjectParameters.ContinueOnError = $False
                                                                      $GetAutomoxAPIObjectParameters.Verbose = $True
                                                                      
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to retrieve policy execution data for the last $($DateRange) day(s). Please Wait..."
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Policy Type(s) Included: $($PolicyTypeList -Join ',')"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                    
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Start Time: $($StartTime.ToString($DateTimeLogFormat))"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                    
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - End Time: $($EndTime.ToString($DateTimeLogFormat))"
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                                    
                                                                    $ZonePolicyExecutionsRequestResult = Get-AutomoxAPIObject @GetAutomoxAPIObjectParameters
                                                        
                                                                    $ZonePolicyExecutionsRequestResultCount = ($ZonePolicyExecutionsRequestResult | Measure-Object).Count
                                                        
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The policy execution API request returned $($ZonePolicyExecutionsRequestResultCount) result(s)."
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                        
                                                                    $ZonePolicyExecutionsPropertyList = New-Object -TypeName 'System.Collections.Generic.List[System.Object]'
                                                                      $ZonePolicyExecutionsPropertyList.Add('*')
                                                        
                                                                    $ZonePolicyExecutionsRequestData = $ZonePolicyExecutionsRequestResult.Data | Select-Object -Property ($ZonePolicyExecutionsPropertyList)
                                                        
                                                                    $ZonePolicyExecutionMetricPropertyNameList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
                                                                      $ZonePolicyExecutionMetricPropertyNameList.Add('Success')
                                                                      $ZonePolicyExecutionMetricPropertyNameList.Add('Failed')
                                                                      #$ZonePolicyExecutionMetricPropertyNameList.Add('Not_Included')
                                                                      #$ZonePolicyExecutionMetricPropertyNameList.Add('Pending')
                                                                      #$ZonePolicyExecutionMetricPropertyNameList.Add('remediation_not_applicable')
                                                                      
                                                                    $ZonePolicyExecutionMetricPropertyNameListCount = ($ZonePolicyExecutionMetricPropertyNameList | Measure-Object).Count
                                                            
                                                                    [System.Int64]$PolicySuccessRatePerZoneTotal = 0
                                                            
                                                                    ForEach ($ZonePolicyExecutionMetricPropertyName In $ZonePolicyExecutionMetricPropertyNameList)
                                                                      {
                                                                          $ZonePolicyExecutionMetricPropertyNameTotal = ($ZonePolicyExecutionsRequestData | Measure-Object -Property ($ZonePolicyExecutionMetricPropertyName) -Sum).Sum
                                                                      
                                                                          $PolicySuccessRatePerZoneTotal += $ZonePolicyExecutionMetricPropertyNameTotal
                                                                      }
                                                                       
                                                                    ForEach ($ZonePolicyExecutionMetricPropertyName In $ZonePolicyExecutionMetricPropertyNameList)
                                                                      {
                                                                          $ZonePolicyExecutionMetricPropertyNameHeader = $TextInfo.ToTitleCase($ZonePolicyExecutionMetricPropertyName) -ireplace '[^a-z0-9]'
                                                                      
                                                                          $ZonePolicyExecutionMetricPropertyValue = ($ZonePolicyExecutionsRequestData | Measure-Object -Property ($ZonePolicyExecutionMetricPropertyName) -Sum).Sum
                                                                      
                                                                          $PolicySuccessRatePerZoneObjectProperties."$($ZonePolicyExecutionMetricPropertyNameHeader)" = 0
                                                                          
                                                                          Switch ($True)
                                                                            {
                                                                                {($Null -ine $ZonePolicyExecutionMetricPropertyValue)}
                                                                                  {
                                                                                      $PolicySuccessRatePerZoneObjectProperties."$($ZonePolicyExecutionMetricPropertyNameHeader)" = $ZonePolicyExecutionMetricPropertyValue
                                                                                  }
                                                                            }

                                                                          $ZonePolicyExecutionMetricPropertyPercentage = Try {($ZonePolicyExecutionMetricPropertyValue / $PolicySuccessRatePerZoneTotal) * 100} Catch {0}
                                                                      
                                                                          $PolicySuccessRatePerZoneObjectProperties."$($ZonePolicyExecutionMetricPropertyNameHeader)Percentage" = [System.Math]::Round($ZonePolicyExecutionMetricPropertyPercentage, 2)
                                                                      }  
                                                        
                                                                    $PolicySuccessRatePerZoneObject = New-Object -TypeName 'System.Management.Automation.PSObject' -Property ($PolicySuccessRatePerZoneObjectProperties)
                                                                    
                                                                    $OutputObjectProperties.PolicySuccessRatePerZone.Add($PolicySuccessRatePerZoneObject)
                                                                }
                                                                
                                                              Default
                                                                {
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Skipping Automox zone $($AutomoxZoneListCounter) of $($AutomoxZoneListCount) because it does NOT meet the zone filter expression."
                                                                    Write-Warning -Message ($LoggingDetails.LogMessage) -Verbose
                                                                }
                                                          }
                                                    }   
                                                  Catch
                                                    {
                                                        $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                                                    } 
                                                  Finally
                                                    { 
                                                        Switch ($ExecutionMode)
                                                          {
                                                              {($_ -inotin @('CreateScheduledTask'))}
                                                                {
                                                                    $Null = Start-Sleep -Seconds 2
                                                                }
                                                          }

                                                        $AutomoxZoneListCounter++  
                                                    }                                                                               
                                              }
                                              
                                            $OutputObject = New-Object -TypeName 'System.Management.Automation.PSObject' -Property ($OutputObjectProperties)
                                        }
                                  }
                               
                                Switch ($Export.IsPresent)
                                  {
                                      {($_ -eq $True)}
                                        {
                                            [System.Text.Encoding]$CSVEncoding = [System.Text.Encoding]::Default
                                    
                                            ForEach ($Entry In $OutputObjectProperties.GetEnumerator())
                                              {
                                                  [System.IO.FileInfo]$CSVExportPath = "$($ExportDirectory.FullName)\$($Entry.Key).csv"
                                                  
                                                  $EntryValue = $Entry.Value
                                      
                                                  Switch (($Null -ine $EntryValue) -and ($EntryValue.Count -ne 0))
                                                    {
                                                        {($_ -eq $True)}
                                                          {
                                                              [System.String[]]$EntryCSVRowList = $EntryValue | ConvertTo-CSV -Delimiter ',' -NoTypeInformation
                                                              
                                                              [System.Int64]$EntryCSVFirstRow = $EntryCSVRowList.GetLowerBound(0)
                                                      
                                                              [System.Int64]$EntryCSVLastRow = $EntryCSVRowList.GetUpperBound(0)
                                                              
                                                              [System.String[]]$EntryCSVFinalRowList = $EntryCSVRowList[$($EntryCSVFirstRow)..$($EntryCSVLastRow - 1)]
                                                          }
                                              
                                                        Default
                                                          {
                                                              [System.String[]]$EntryCSVFinalRowList = @()
                                                          }
                                                    }
                                                    
                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to export $($EntryCSVFinalRowList.Count) row(s) to a CSV for the `"$($Entry.Key)`" report. Please Wait..."
                                                  Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                              
                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Export Path: $($CSVExportPath.FullName)"
                                                  Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
                                                              
                                                  Switch ([System.IO.Directory]::Exists($CSVExportPath.Directory.FullName))
                                                    {
                                                        {($_ -eq $False)}
                                                          {
                                                              $Null = [System.IO.Directory]::CreateDirectory($CSVExportPath.Directory.FullName)
                                                          }
                                                    }
                                                                
                                                  $Null = [System.IO.File]::WriteAllLines($CSVExportPath.FullName, $EntryCSVFinalRowList, $CSVEncoding)
                                              }
                                        }
                                  }
 
                                Write-Output -InputObject ($OutputObject)
                            }

                          {($_ -iin @('CreateScheduledTask'))}
                            {
                                [System.IO.FileInfo]$ScheduledTaskTemplatePath = "$($ScriptDirectory.FullName)\ScheduledTasks\$($ScriptPath.BaseName).xml"

                                Switch ([System.IO.File]::Exists($ScheduledTaskTemplatePath.FullName))
                                  {
                                      {($_ -eq $True)}
                                        {
                                            $ScheduledTaskTemplateContent = [System.IO.File]::ReadAllText($ScheduledTaskTemplatePath.FullName)
                            
                                            $InvokeScheduledTaskActionParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                              $InvokeScheduledTaskActionParameters.Create = $True
                                              $InvokeScheduledTaskActionParameters.ScheduledTaskDefinition = $ScheduledTaskTemplateContent
                                              $InvokeScheduledTaskActionParameters.Force = $True
                                              $InvokeScheduledTaskActionParameters.ScheduledTaskFolder = $ScheduledTaskSettings.Folder
                                              $InvokeScheduledTaskActionParameters.ScheduledTaskName = $ScheduledTaskSettings.Name
                                              $InvokeScheduledTaskActionParameters.Source = $ScheduledTaskSettings.Source
                                              $InvokeScheduledTaskActionParameters.Destination = $ScheduledTaskSettings.Destination
                                              $InvokeScheduledTaskActionParameters.ScriptName = $ScriptPath.Name
                                              $InvokeScheduledTaskActionParameters.ScriptParameters = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-OrganizationID '$($OrganizationID)'")
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-APIKey '$($APIKey)'")
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-DateRange '$($DateRange)'")
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-Export")
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-ExportDirectory '$($ScheduledTaskSettings.Destination)'")
                                                $InvokeScheduledTaskActionParameters.ScriptParameters.Add("-ExecutionMode 'Execute'")
                                              $InvokeScheduledTaskActionParameters.Stage = $True
                                              $InvokeScheduledTaskActionParameters.Execute = $True
                                              $InvokeScheduledTaskActionParameters.ContinueOnError = $False
                                              $InvokeScheduledTaskActionParameters.Verbose = $True

                                            $InvokeScheduledTaskActionResult = Invoke-ScheduledTaskAction @InvokeScheduledTaskActionParameters
                                        }
                                  }
                            }

                          {($_ -iin @('RemoveScheduledTask'))}
                            {
                                $InvokeScheduledTaskActionParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $InvokeScheduledTaskActionParameters.Remove = $True
                                  $InvokeScheduledTaskActionParameters.ScheduledTaskFolder = $ScheduledTaskSettings.Folder
                                  $InvokeScheduledTaskActionParameters.ScheduledTaskName = $ScheduledTaskSettings.Name
                                  $InvokeScheduledTaskActionParameters.Source = $ScheduledTaskSettings.Destination
                                  $InvokeScheduledTaskActionParameters.ContinueOnError = $False
                                  $InvokeScheduledTaskActionParameters.Verbose = $True

                                $InvokeScheduledTaskActionResult = Invoke-ScheduledTaskAction @InvokeScheduledTaskActionParameters
                            }
                      }
                                        
                    $Script:LASTEXITCODE = $TerminationCodes.Success[0]
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {                
                    Try
                      {
                          #Determine the date and time the function completed execution
                            $ScriptEndTime = (Get-Date)

                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Script execution of `"$($CmdletName)`" ended on $($ScriptEndTime.ToString($DateTimeLogFormat))"
                            Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose

                          #Log the total script execution time  
                            $ScriptExecutionTimespan = New-TimeSpan -Start ($ScriptStartTime) -End ($ScriptEndTime)

                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Script execution took $($ScriptExecutionTimespan.Hours.ToString()) hour(s), $($ScriptExecutionTimespan.Minutes.ToString()) minute(s), $($ScriptExecutionTimespan.Seconds.ToString()) second(s), and $($ScriptExecutionTimespan.Milliseconds.ToString()) millisecond(s)."
                            Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
            
                          $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Exiting script `"$($ScriptPath.FullName)`" with exit code $($Script:LASTEXITCODE)."
                          Write-Verbose -Message ($LoggingDetails.LogMessage) -Verbose
            
                          Stop-Transcript
                      }
                    Catch
                      {
            
                      }
                }
        }

      {($_ -eq $False)}
        {
            [System.IO.FileInfo]$ScriptPath = "$($MyInvocation.MyCommand.Path)"

            #$CurrentExecutionPolicy = Get-ExecutionPolicy -Scope Process
            
            $CurrentExecutionPolicy = 'Bypass'

            $ArgumentList = New-Object -TypeName 'System.Collections.Generic.List[String]'
              $ArgumentList.Add("-ExecutionPolicy $($CurrentExecutionPolicy)")
              $ArgumentList.Add('-NoProfile')
              $ArgumentList.Add('-NoExit')
              $ArgumentList.Add('-NoLogo')
              $ArgumentList.Add("-File `"$($ScriptPath.FullName)`"")
              
            $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object {$ArgumentList.Add("-$($_.Key) $($_.Value)")}           
            
            $MyInvocation.UnboundArguments.GetEnumerator()  | ForEach-Object {$ArgumentList.Add("$($_.Value)")}

            $ScriptInterpreterList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
              $ScriptInterpreterList.Add('powershell.exe')
              #$ScriptInterpreterList.Add('pwsh.exe')
              
            :ScriptInterpreterListLoop ForEach ($ScriptInterpreter In $ScriptInterpreterList)
              {
                  $ScriptInterpreterObject = Try {Get-Command -Name ($ScriptInterpreter) -ErrorAction SilentlyContinue} Catch {$Null}
                  
                  Switch ($Null -ine $ScriptInterpreterObject)
                    {
                        {($_ -eq $True)}
                          {
                              $Null = Start-Process -FilePath ($ScriptInterpreterObject.Path) -WorkingDirectory "$($Env:Temp.TrimEnd('\'))" -ArgumentList ($ArgumentList.ToArray()) -WindowStyle Normal -Verb RunAs -PassThru

                              Break ScriptInterpreterListLoop
                          }
                    }
              }  
        }
  }