$domain = "YOUR AD DOMAIN HERE"
$importCsv = Import-Csv adusersimport.csv
$logName = "useradd.log"
$logPath = "${pwd}\$logName"

try{
    New-Item -Name $logName -Path "." -Force
}
catch{}

Foreach ($user in $importCsv) {
    $addUserJob = Start-Job -ArgumentList $user, $logPath, $domain -ScriptBlock {
        $user, $logPath, $domain = $args
        $fullName = $user.first_name + " " + $user.last_name
        $formattedName = $user.username + "@$domain"
        try{
            $changePw = [System.Convert]::ToBoolean($user.temp_pw)
        }
        catch{
            Write-Output "Invalid value for temp_pw at user: $formattedName"
        }
        try {
            $groupsArr = $user.groups.split(",")
    
            New-ADUser -name $fullName -GivenName $user.first_name -Surname $user.last_name -UserPrincipalName $formattedName -Enabled $True -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force) -DisplayName $fullName -SamAccountName $user.username -Path $user.ou -ChangePasswordAtLogon $changePw
            Write-Output $user.username"user created!"
            Add-Content -Path $logPath -Value "User: $formattedName added!`r`n"
    
            if($group){
                foreach ($group in $groupsArr) {
                    try {
                        Add-ADGroupMember -Identity $group -Members $user.username
                        Write-Output $user.username"added to"$group"!"
                        Add-Content -Path $logPath -Value "Groups: $group added for $formattedName!`r`n"
                    }
        
                    catch {
                        $ErrorMessage = $_.Exception.Message
                        Write-Output "Issue with adding $user to $group!!! `r`nError: $ErrorMessage"
                        Add-Content -Path $logPath -Value "Groups: $group cannot be added for $formattedName`r`nError: $ErrorMessage"
                    }
                }
            }
        }
        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Output "Issue with creating $user!!! `r`nError: $ErrorMessage"
            Add-Content -Path $logPath -Value "User: $formattedName cannot be added!`r`nError: $ErrorMessage"
        } 
    }
    Receive-Job $addUserJob
}
