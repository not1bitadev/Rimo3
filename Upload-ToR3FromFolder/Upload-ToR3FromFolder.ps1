
Function Register-Watcher {
    param ($folder)
    $filter = "*.*" #all files
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    $changeAction = [scriptblock]::Create('
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $location = $path.replace($name,"")
        $changeType = $Event.SourceEventArgs.ChangeType
        $timeStamp = $Event.TimeGenerated
        Write-Host `n
        Write-Host "The file $name in $location was $changeType at $timeStamp"
        $i = 1
        While ($True)
         {
           Try { 
                 [IO.File]::OpenWrite($path).Close() 
                 Break
               }
           Catch { 
                    Write-Host "`rWaiting for file to copy... [ $("." * ($i % 9)) $(" " * (8 - ($i % 9)))]"
                    Start-Sleep -Seconds 1
                    $i++
                 }
         }
        Write-Host "`rWaiting for file to copy... [ COMPLETE ]"
        Add-Type -assembly "system.io.compression.filesystem"
        Try { 
                $archive = [io.compression.zipfile]::OpenRead($path)
                $archive.Dispose()
                Write-host "$name is a valid zip archive" -ForegroundColor Green
                start-Sleep 10
                Write-host "Moving $name to $(Join-Path -Path $location -ChildPath "Uploaded")..."
                Move-Item -Path $path -Destination $(Join-Path -Path $location -ChildPath "Uploaded") -force
            }
        Catch { 
                Write-host "$name does not appear to be a valid zip archive" -ForegroundColor Red
                Start-Sleep 10
                Write-host "Moving $name to $(Join-Path -Path $location -ChildPath "invalid")..."
                Move-Item -Path $path -Destination $(Join-Path -Path $location -ChildPath "invalid") -force
              }

    ')

    Register-ObjectEvent $Watcher -EventName "Created" -Action $changeAction
}

 Register-Watcher "C:\root\temp\upload"

 <#

 (Get-Item "C:\root\temp\upload\test.txt").Extension

 $Path = "C:\root\temp\upload\test.txt"
 $Child = "test.txt"
 $location = $path.replace($child,"")
 Write-Output $location

 
 get-content "C:\root\temp\upload\New Text Document (3).zip"
 
 Expand-Archive -Path "C:\root\temp\upload\New Text Document (2).zip" -DestinationPath "C:\root\temp\upload"

 Add-Type -assembly "system.io.compression.filesystem"

Try { [io.compression.zipfile]::OpenRead("C:\root\temp\upload\New Text Document (2).zip") }
Catch { Write-Output "could not open zip archive" }




 write-host "$(1 % 4)"
 write-host "$(2 % 4)"
 write-host "$(3 % 4)"
 write-host "$(4 % 4)"
 write-host "$(5 % 4)"
 write-host "$(6 % 6)"

 $i = 1
 while ($i -le 11) {
                    Write-Progress -Activity "ActivityString" -Status "StatusString" -PercentComplete $(($i % 6) * 20)
                    #Write-host "`r percentage: $(($i % 6) * 20)%" -NoNewline
                    Start-Sleep -Seconds 1
                    $i++

    }


  $i = 1
 while ($i -le 11) {
                    Write-Host "`r[ $("." * ($i % 9)) $(" " * (8 - ($i % 9)))]" -NoNewline
                    Start-Sleep -Seconds 1
                    $i++

    }
    Write-Host "`r[ COMPLETE ]"

#>
