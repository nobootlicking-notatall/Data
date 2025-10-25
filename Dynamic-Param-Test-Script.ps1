function call {
param (
    [string]$Name,
    [int32]$Id
)

# $PSBoundParameters | Format-Table

$o = [PSCustomObject]@{
    "Mode" = $Name
#    "$($PSBoundParameters.Keys)" = "$($PSBoundParameters.Values)"
}

if ($PSBoundParameters['Name'] -eq "Intune") {
    Write-Host "Intune is passed"
    if ($Id) {
        $o | Add-Member -MemberType NoteProperty -Name "Id" -Value "$Id"
        $o
    }
}
elseif ($PSBoundParameters['Name'] -eq "Azure") {
    Write-Host "Azure is passed"
}
else {
    Write-Host "lol"
}


#switch ($PSBoundParameters.Values) {
#    'Dhruv' { Write-Output "Name parameter has been passed" }
#    32 { Write-Output "Id parameter has been passed" }
#}

#Write-Output "No. of parameters passed: $($PSBoundParameters['Name'])"

}