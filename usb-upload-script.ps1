$artists = Get-ChildItem F:\Music\ -Directory
$diskRoots = Get-WmiObject -Class Win32_LogicalDisk -Filter "VolumeName like 'PLENUE%'" | Select-Object -ExpandProperty DeviceID

foreach($artist in $artists){

    $albums = Get-ChildItem $artist.FullName

    foreach($album in $albums){
        $primaryDiskPath =  Join-Path -Path $( Join-Path $( Join-Path $diskRoots[0] 'Music\') -ChildPath $artist.Name) -ChildPath $album.Name
        $secondaryDiskPath =  Join-Path -Path $( Join-Path $( Join-Path $diskRoots[1] 'Music\') -ChildPath $artist.Name) -ChildPath $album.Name

        if($(Test-Path $primaryDiskPath) -or $(Test-Path $secondaryDiskPath)){
            Write-Host "$($album.Name) already exists"
        }
        else{
            write-host "copying $($album.Name) to SD card"
            If($album.Name -like 'Hospitality*'){
                write-host "skipping hospitality"
            }
            else{
                Copy-Item -Path $album.FullName -Destination $secondaryDiskPath -Recurse
            }
        }
    }
}
