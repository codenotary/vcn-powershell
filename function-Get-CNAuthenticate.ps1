function Get-CNAuthenticate {
<#
.Description
Get-Function to authenticate an existing file with CodeNotary.io and return the result as json
Verification Status can be:

0	TRUSTED
2	UNKNOWN
1	UNTRUSTED
3	UNSUPPORTED

https://docs.codenotary.io/vcn/user-guide/notarization.html#statuses

.EXAMPLE
get-item .\codenotary-watcher.ps1 | Get-CNAuthenticate
kind              :
name              :
hash              : 7a4e8b6727046825fdf68728302ffce33f372286bdd2ac4130dadf4ceb6ff7ea
size              : 0
contentType       :
url               :
metadata          :
visibility        : PRIVATE
createdAt         : 2019-10-25T08:28:57.290696
verificationCount : 10
signerCount       : 1
signer            : dzi****@opv****.com
company           :
website           :
verification      : @{level=1; owner=0x5a1917dec5f2128ad8a6928f488a353aa5e606ab; status=0;
                    timestamp=2019-10-25T08:28:55Z}
.EXAMPLE
Get-CNAuthenticate -Path .\codenotary-watcher.ps1 -Org codenotary.io
kind              :
name              :
hash              :
size              : 0
contentType       :
url               :
metadata          :
visibility        :
createdAt         :
verificationCount : 0
signerCount       : 0
signer            :
company           :
website           :
verification      : @{level=0; owner=; status=2; timestamp=}

.EXAMPLE
Get-CNAuthenticate -Path .\codenotary-watcher.ps1 | select -ExpandProperty verification
level owner                                      status timestamp
----- -----                                      ------ ---------
    1 0x5a1917dec5f2128ad8a6928f488a353aa5e606ab      0 2019-10-25T08:28:55Z

#>
    [CmdletBinding()]
    Param(
		[ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true
        })]
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.IO.FileInfo]$Path,
		[Parameter(Mandatory=$false)]
		[string]$org
    )
   
   # avoid case-sensitive errors
   $hash=(Get-FileHash $Path).Hash.tolower()
   
   # structure URL
   $url="https://api.codenotary.io/authenticate/$hash"
   # add org check if required
   if ($org) {
		$url=$url +"?org=$org"
   }
   
   try
   {
     $result=Invoke-RestMethod -Method Get -Uri $url -ErrorAction 1
   }
   catch
   {
       return $_
   }
   return $result
}


