function call {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Mode,

        [Parameter(Mandatory=$true, Position=1)]
        [int]$Age
    )
    
    DynamicParam {

        # Creating a dictionary to store all dynamic values
        $dynamic_dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        if ($Mode -eq "Intune") {

            # Specifying parameter attributes/behavior
            $I_attribute = New-Object System.Management.Automation.ParameterAttribute
            $I_attribute.Mandatory = $true

            # Adding attributes to collection
            $I_attribute_collection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $I_attribute_collection.Add($I_attribute)

            # New-Object System.Management.Automation.RuntimeDefinedParameter(<Name>, <type>, <attributes>)
            $I_runtime_param = New-Object System.Management.Automation.RuntimeDefinedParameter('Name', [string[]], $I_attribute_collection)

            # <dictionary_name>.Add(<Key>, <Runtime_parameter_metadata>)
            $dynamic_dictionary.Add('Name', $I_runtime_param)
        }

        elseif ($Mode -eq "Azure") {
            
            # Specifying the parameter attributes
            $A_attribute = New-Object System.Management.Automation.ParameterAttribute
            $A_attribute.Mandatory = $true

            # Adding the attributes to collection
            $A_attribute_collection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $A_attribute_collection.Add($A_attribute)

            # New-Object System.Management.Automation.RuntimeDefinedParameter(<Name>, <type>, <attributes>)
            $A_runtime_param = New-Object System.Management.Automation.RuntimeDefinedParameter('peergroup', [int[]], $A_attribute_collection)

            # <dictionary_name>.Add(<Key>, <Runtime_parameter_metadata>)
            $dynamic_dictionary.Add('peergroup', $A_runtime_param)
        }

        return $dynamic_dictionary
    }

    # Storing the value of specified key (parameter) using PSBoundParameters in a variable
    begin {
        if ($PSBoundParameters['Mode'] -eq "Intune") {
            $I_N = $PSBoundParameters['Name']
        }
        elseif ($PSBoundParameters['Mode'] -eq "Azure") {
            $A_N = $PSBoundParameters['peergroup']
        }
    }

    process {
        $table_of_content = [PSCustomObject]@{
            "Mode" = $Mode
            "Age" = $Age
        }

        if ($PSBoundParameters['Mode'] -eq "Intune") {
            $table_of_content | Add-Member -MemberType NoteProperty -Name "Name" -Value $I_N
            $table_of_content
        }
        elseif ($PSBoundParameters['Mode'] -eq "Azure") {
            $table_of_content | Add-Member -MemberType NoteProperty -Name "Peer Group" -Value $A_N
            $table_of_content
        }
        else {
            Write-Output "Please pass 'Intune or 'Azure' value to -Mode parameter"
        }
    }
}