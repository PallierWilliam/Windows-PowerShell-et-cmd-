# Connect to MySQL Database 
function Connect-MySQL() { 
    # Load MySQL .NET Connector Objects 
    [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 
 
    # Open Connection 
    #uid = nom du compte mysql, pwd = mot de passe
    $connStr = "server=127.0.0.1;port=3306;uid=root;pwd=mdp;database=powershell;Pooling=FALSE" 
    write-host $connStr
    try {
        $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) 
        $conn.Open() 
        
    } catch [System.Management.Automation.PSArgumentException] {
        write-host "Unable to connect to MySQL server, do you have the MySQL connector installed..?"
        write-host $_
        Exit
    } catch {
        write-host "Unable to connect to MySQL server..."
        write-host $_.Exception.GetType().FullName
        write-host $_.Exception.Message
        write-host $connStr
        exit
    }
    write-host "Connected to MySQL database $MySQLHost\$database"

    return $conn 
}

#A utiliser pour les requetes INSERT, UPDATE, DELETE
function Execute-MySQLNonQuery($conn, [string]$query) { 
  $command = $conn.CreateCommand()                  # Create command object
  $command.CommandText = $query                     # Load query into object
  $RowsInserted = $command.ExecuteNonQuery()        # Execute command
  $command.Dispose()                                # Dispose of command object
  if ($RowsInserted) { 
    return $RowInserted 
  } else { 
    return $false 
  } 
} 

#A utilise pour les requetes SELECT
function Execute-MySQLQuery($conn, [string]$query) { 
  # NonQuery - Insert/Update/Delete query where no return data is required
  $cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)    # Create SQL command
  $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)      # Create data adapter from query command
  $dataSet = New-Object System.Data.DataSet                                    # Create dataset
  $dataAdapter.Fill($dataSet, "data")                                          # Fill dataset from data adapter, with name "data"              
  $cmd.Dispose()
  return $dataSet.Tables["data"]                                               # Returns an array of results
}

#$id=Read-Host -Prompt "Saisir un id"
#$nom=Read-Host -Prompt "Saisir un nom"
#$prenom=Read-Host -Prompt "Saisir un prenom"
#$login=Read-Host -Prompt "Saisir un login"
#$mdp=Read-Host -Prompt "Saisir un mdp"
#$adresse=Read-Host -Prompt "Saisir une adresse"
#$cp=Read-Host -Prompt "Saisir un code postal"
#$ville=Read-Host -Prompt "Saisir une ville"
#$dateEmbauche=Read-Host -Prompt "Saisir une date d'embauche"


 $ImportData = Import-Csv "c:\user.csv"
 foreach ( $Data in  $ImportData )
{


$id=$Data.id
$nom=$Data.nom
$prenom=$Data.prenom
$login=$Data.login
$mdp=$Data.mdp
$adresse=$Data.adresse
$cp=$Data.cp
$ville=$Data.ville
$dateEmbauche=$Data.dateEmbauche


#Exemples
$conn = Connect-MySQL
$query = "SELECT * FROM visiteur;"
#$query = "SELECT nom,prenom FROM Visiteur ORDER BY dateEmbauche LIMIT 3;"
#$query = "INSERT INTO visiteur VALUES ('$id','$nom','$prenom','$login','$mdp','$adresse','$cp','$ville','$dateEmbauche');"
$result = Execute-MySQLQuery $conn $query
Write-Host ("Found " + $result.rows.count + " rows...")
$result | Format-Table
}
