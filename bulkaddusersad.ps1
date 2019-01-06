$domain = "YOUR AD DOMAIN HERE"
$importCsv = Import-Csv adusersimport.csv

Foreach($user in $importCsv){
    $fullName = $user.first_name + " " + $user.last_name
    $formattedName = $user.username+"@$domain"
    try{
        $groupsArr = $user.groups.split(",")

        New-ADUser -name $fullName -GivenName $user.first_name -Surname $user.last_name -UserPrincipalName $formattedName -Enabled $True -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force) -DisplayName $fullName -SamAccountName $user.username -Path $user.ou
        Write-Host $user.username"user created!"

        foreach ($group in $groupsArr){
            try{
                 Add-ADGroupMember -Identity $group -Members $user.username
                 Write-Host $user.username"added to"$group"!"
            }

            catch{
                    $ErrorMessage = $_.Exception.Message
                    Write-Output "Issue with adding $user to $group!!! `r`n Error: $ErrorMessage"
            }
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Output "Issue with creating $user!!! `r`n Error: $ErrorMessage"
    } 
}
