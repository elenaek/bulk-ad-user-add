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

## Automatically Generating Username based on First/Last Names

If you use excel/google sheets you can insert one of the functions below to automatically format the first/lastnames for the usernames column.

1. Open the csv in excel/sheets 
2. Copy the code block with the format you want 
3. Paste into the cells under the ***username*** column heading which you want to automatically generate the usernames in target format


## Username Format Functions

Example User: Some (FirstName) Guy (LastName)

* `=CONCATENATE(LEFT(A:A,1),B:B)` : FirstInitialLastName = sguy
* `=CONCATENATE(LEFT(B:B,1),A:A)` : LastInitialFirstName = gsome
* `=CONCATENATE(B:B,LEFT(A:A,1))` : LastNameFirstInitial = guys
* `=CONCATENATE(A:A,LEFT(B:B,1))` : FirstNameLastInitial = someg
* `=CONCATENATE(A:A,.,B:B)` : FirstName.LastName = some.guy

## Logging

Results are logged to the specified logname inside the script, defaulting to ***useradd.log***