# Replace servername with the name of the server where the databases are located.
$server_name = "localhost"

# Replace folder_path with the path to the directory containing the SQL files.
$folder_path = "C:\Users\akavr\Desktop\sqlScripts"

# Get a list of all the SQL files in the directory.
$sql_files = Get-ChildItem -Path $folder_path -Filter *.sql -Recurse | % { $_.FullName }

# Get a list of databases names.
$databasesTable = Invoke-Sqlcmd -ServerInstance @server_name -Query "SELECT name from sys.databases"  -As DataTables
$databases = $databasesTable[0].name

# Loop through each database and execute all SQL scripts.
foreach ($database in $databases) {
    foreach ($sql_file in $sql_files) {
        $sql_script = Get-Content $sql_file;
        Write-Host "Runs" $sql_file  "at" $database;
        Invoke-Sqlcmd -ServerInstance $server_name -Database $database -InputFile $sql_file -verbose
    }
}