# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"


$connectionString = $env:connectionString
$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
$query = "EXEC [dbo].[Build_AS_DataMart]" 
$command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $connection)
$connection.Open()
$command.ExecuteNonQuery()
$connection.Close()

