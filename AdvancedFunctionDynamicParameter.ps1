function gg {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Role
    )
    DynamicParam {
        $DynamicParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $ParameterAttributes = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttributes.Mandatory = $true
        $ParameterCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterCollection.Add($ParameterAttributes)
        if ($Role -in @("Analyst", "Specialist")) {
            $add_role = New-Object System.Management.Automation.RuntimeDefinedParameter (
                "EmployeeCode", [int], $ParameterCollection
            )
            $DynamicParamDictionary.Add("EmployeeCode", $add_role)
        }
        return $DynamicParamDictionary
    }
    begin {
        $EmpCode = $PSBoundParameters["EmployeeCode"]
    }
    
    process {
        if ($Role -in @("Analyst", "Specialist")) {
            Write-Output "Role: $Role, Employee Code: $EmpCode"
        }
        else {
            Write-Output "Role: $Role ---(No employee code required for this role)---"
        }
    }
}