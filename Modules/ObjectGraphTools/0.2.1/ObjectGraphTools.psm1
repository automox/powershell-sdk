if (-Not ('PSNode' -as [Type])) { . $PSScriptRoot\Source\Classes\ObjectParser.ps1 }
. $PSScriptRoot\Source\Public\ConvertFrom-Expression.ps1
. $PSScriptRoot\Source\Public\ConvertTo-Expression.ps1
. $PSScriptRoot\Source\Public\Import-ObjectGraph.ps1
. $PSScriptRoot\Source\Public\Export-ObjectGraph.ps1
. $PSScriptRoot\Source\Public\Compare-ObjectGraph.ps1
. $PSScriptRoot\Source\Public\Copy-ObjectGraph.ps1
. $PSScriptRoot\Source\Public\Get-ChildNode.ps1
. $PSScriptRoot\Source\Public\Get-Node.ps1
. $PSScriptRoot\Source\Public\Merge-ObjectGraph.ps1
. $PSScriptRoot\Source\Public\Sort-ObjectGraph.ps1

$Parameters = @{
    Function =
        'ConvertFrom-Expression',
        'ConvertTo-Expression',
        'Import-ObjectGraph',
        'Export-ObjectGraph',
        'Compare-ObjectGraph',
        'Copy-ObjectGraph',
        'Get-ChildNode',
        'Get-Node',
        'Merge-ObjectGraph',
        'ConvertTo-SortedObjectGraph'
    Alias    = 'Sort-ObjectGraph'
}
Export-ModuleMember @Parameters
