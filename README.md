# powershell2exe
convert an exe into a powershell script to be run remotely


Exe2Powershell.ps1 -- Core File; the actually script to run
Invoke_ReflectivePEInjection.ps1 -- part of powersploit, must be in the same directory as core file to run.

USAGE:
Run powershell script Exe2Powershell.ps1.
Provide exe to be converted
Choose output location.
Add any additional command line args for exe (example, if exe is netcat, args might simply be -lvp 5555)
Enter web address where script would be hosted (not required, but creates and executable line for you)
Enter web port (also not required, but you'll need it for the exe line)

Host file on a web server
Run powershell line given from the script
Profit.

Alternatively, the script can just be run, by whatever means you like, and should still function.

Note:  if your binary is 32bit, you must use the 32bit powershell to execute, which is usually located at c:\windows\syswow64\windowspowershell\v1.0\powershell.exe.
