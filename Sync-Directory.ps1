function Sync-Directory{
param(
[Parameter(Mandatory=$True,Position=1)][string]$source,
[Parameter(Mandatory=$True,Position=2)][string]$target,
[Parameter(Mandatory=$False,Position=3)][boolean]$twoWay=$False
)

    $sourceFiles=Get-ChildItem -Path $source -Recurse
    $targetFiles=Get-ChildItem -Path $target -Recurse


try{
    $diff=Compare-Object -ReferenceObject $sourceFiles -DifferenceObject $targetFiles

    foreach($file in $diff) {
        if($file.SideIndicator -eq "<=") {
            $fullSourceObject=$file.InputObject.FullName
            $fullTargetObject=$file.InputObject.FullName.Replace($source, $target)

            Write-Host "Attemp to copy the following: " $fullSourceObject
            Copy-Item -Path $fullSourceObject -Destination $fullTargetObject
        }

        if($twoWay -eq $True) {
            if($file.SideIndicator -eq "=>") { 
                $fullSourceObject=$file.InputObject.FullName
                $fullTargetObject=$file.InputObject.FullName.Replace($target,$source)

                Write-Host "Attemp to copy the following: " $fullSourceObject
                Copy-Item -Path $fullSourceObject -Destination $fullTargetObject
            }
            if($file.SideIndicator -eq "==") {
                #TODO
            }
        }

    }
}      
catch {
  Write-Error -Message "something bad happened!" -ErrorAction Stop
}

#Source:               https://stackoverflow.com/questions/25869806/how-to-keep-2-folders-in-sync-using-powershell-script
#Suspiciously similar: https://www.business.com/articles/powershell-sync-folders/
}

$src = "E:\Pierdoły\Pulpit\Tekstowe"
$dst = "E:\Pierdoły\Pulpit\Tekstowe_tst"

Sync-Directory $src $dst $false

$files = Get-ChildItem
$files[1].LastWriteTime

$sourceFiles=Get-ChildItem -Path "E:\Pierdoły\Pulpit\Tekstowe" -Recurse
    $targetFiles=Get-ChildItem -Path "E:\Pierdoły\Pulpit\Tekstowe_tst" -Recurse

    $diff=Compare-Object -IncludeEqual -ReferenceObject $sourceFiles -DifferenceObject $targetFiles
    $diff 