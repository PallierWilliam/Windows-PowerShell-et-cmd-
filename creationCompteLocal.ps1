$local=[ADSI]"WinNT://."

$nom=Read-Host -Prompt "Saisir un nom"
$nomComplet=Read-Host -Prompt "Saisir un nom complet"
$description=Read-Host -Prompt "Saisir une description"

$compte=[ADSI]"WinNT://./$nom"
if (!$compte.path) {
    $utilisateur=$local.create("user",$nom)
    $utilisateur.InvokeSet("FullName",$nomComplet)
    $utilisateur.InvokeSet("description",$description)
    $utilisateur.CommitChanges()
    Write-Host "$nom ajouté"
}
else {
    Write-Host "$nom existe déjà"
}
