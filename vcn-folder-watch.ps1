### Set vcn binary path - please download vcn here: https://github.com/vchain-us/vcn/releases/latest
   $vcnpath = """$env:programfiles\codenotary\vcn.exe"""

### Set target directory and file types to watch for changes and if you want to include subdirectories
   $watcher = New-Object System.IO.FileSystemWatcher
	 $watcher.Path = "C:\Users\user\Documents\Notarize"
   $watcher.IncludeSubdirectories = $true
   $watcher.EnableRaisingEvents = $true  

### Define notarization when files are detected
   $action = { $path = $Event.SourceEventArgs.FullPath
             $changeType = $Event.SourceEventArgs.ChangeType
	 $param = " n " + """$Path""" + " --attr PSEvent=True"
	 $command = $vcnpath + "$param"
			iex "& $command"
           $logline = "Notarized $(Get-Date), $changeType, $path"
           write-host $logline
		  Add-content ($watcher.Path + "\codenotary.log") -value $logline
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
   Register-ObjectEvent $watcher "Created" -Action $action
	 # Register-ObjectEvent $watcher "Renamed" -Action $action
	
   while ($true) {sleep 5}
