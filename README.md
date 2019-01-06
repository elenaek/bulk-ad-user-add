# Getting Started

## Prerequisites
* Windows Remote Server Administration Tools installed : [Win10 RSAT](https://www.microsoft.com/en-us/download/details.aspx?id=45520)
* Logged in user has permissions to create users within AD @ the specificed OUs

## First time usage
1. Clone the repo down to your local directory
2. In the powershell script (bulkaddusersad.ps1) change the `$domain = "YOUR AD DOMAIN HERE"` value to your AD domain name
3. Fill out the spreadsheet with info
4. Run the bulkaddusersad.ps1 script
5. Profit!

## Spreadsheet format and what each column means
| first_name | last_name | username | password | ou | groups |
| ------ | ------ | ------ | ------ | ------ | ------ |
| User's first name | User's last name | user's intended username | user's password | the DN of the OU to create the user on | group names separated by commas, to add the user to |
