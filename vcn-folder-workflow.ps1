# Set vcn binary path - please download vcn here: https://github.com/vchain-us/vcn/releases/latest
   $vcnpath = """$env:programfiles\codenotary\vcn.exe"""

## Define all environments

### Set Production environment
   $watchertrusted = New-Object System.IO.FileSystemWatcher
   $watchertrusted.Path = "C:\CodeNotary\Production"
   $watchertrusted.IncludeSubdirectories = $true
   $watchertrusted.EnableRaisingEvents = $true  

### Set Old environment
   $watcherunsupported = New-Object System.IO.FileSystemWatcher
   $watcherunsupported.Path = "C:\CodeNotary\Old"
   $watcherunsupported.IncludeSubdirectories = $true
   $watcherunsupported.EnableRaisingEvents = $true  

### Set Unwanted environment
   $watcheruntrusted = New-Object System.IO.FileSystemWatcher
   $watcheruntrusted.Path = "C:\CodeNotary\Unwanted"
   $watcheruntrusted.IncludeSubdirectories = $true
   $watcheruntrusted.EnableRaisingEvents = $true  



## Define notarization when files are detected
   $actiontrusted = { $path = $Event.SourceEventArgs.FullPath
             $changeType = $Event.SourceEventArgs.ChangeType
			 $param = " n " + """$Path""" + " --attr PSEvent=True"
			 $command = $vcnpath + "$param"
			 iex "& $command"
             $logline = "Trust $(Get-Date), $changeType, $path"
             write-host $logline
		     Add-content ($watchertrusted.Path + "\codenotary.log") -value $logline
             }    

   $actionunsupported = { $path = $Event.SourceEventArgs.FullPath
             $changeType = $Event.SourceEventArgs.ChangeType
			 $param = " n " + """$Path""" + " --attr PSEvent=True"
			 $command = $vcnpath + "$param"
			 iex "& $command"
             $logline = "Unsupport $(Get-Date), $changeType, $path"
             write-host $logline
		     Add-content ($watcherunsupported.Path + "\codenotary.log") -value $logline
             }    
   
   $actionuntrusted = { $path = $Event.SourceEventArgs.FullPath
             $changeType = $Event.SourceEventArgs.ChangeType
			 $param = " n " + """$Path""" + " --attr PSEvent=True"
			 $command = $vcnpath + "$param"
			 iex "& $command"
             $logline = "Untrust $(Get-Date), $changeType, $path"
             write-host $logline
		     Add-content ($watcheruntrusted.Path + "\codenotary.log") -value $logline
             }    

# Register all Watcher
   Register-ObjectEvent $watchertrusted "Created" -Action $actiontrusted
   Register-ObjectEvent $watcherunsupported "Created" -Action $actionunsupported
   Register-ObjectEvent $watcheruntrusted "Created" -Action $actionuntrusted

	
   while ($true) {sleep 5}
