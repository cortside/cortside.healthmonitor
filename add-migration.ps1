[cmdletbinding()]
param(
	[parameter(Mandatory=$true)][string]$migration
)

$repo = "cortside.healthmonitor"
$project = "src/$repo.Data"
$startup = "src/$repo.WebApi"
$context = "DatabaseContext"

echo "creating new migration $migration for $context context in project $project"
dotnet tool update --global dotnet-ef

dotnet ef migrations add $migration --project "$project" --startup-project "$startup" --context "$context"

dotnet build ./src

.\generate-sql.ps1
.\generate-sqltriggers.ps1
.\update-database.ps1

echo "done"
