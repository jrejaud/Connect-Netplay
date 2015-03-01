#Powershell script to autoconnect netplay games in Dolphin

Function Connect-Netplay 
{
	#hostCode is only parameter, and it is mandatory!
	[CmdletBinding()]
	Param(
  	 [Parameter(Mandatory=$True)]
   	  [string]$hostCode
	)

	#User needs to set path... (Find a way to automate this, I do)
	$dolphinPath = "C:\Users\Jordan\Downloads\dolphin-dc-netplay-4.0-652-x64\Dolphin-x64\Dolphin.exe"

	#First, check if dolphin is running. If it is, kill it. To do: Get an existing Dolphin process and use it inst		ead
	if (Get-Process -ProcessName dolphin  -ErrorAction SilentlyContinue | where {$_.mainWindowTitle}) {
		Get-Process -ProcessName dolphin  -ErrorAction SilentlyContinue | where {$_.mainWindowTitle} | ForEach-Object {$dolphinId = $_.Id}
	} else {
		#Start dolphin process and store its process ID in $dolphinId
		Write-Output "Starting up Dolphin"
		Start-Process -FilePath $dolphinPath -PassThru | ForEach-Object {$dolphinId = $_.Id}
	}	

	# Wait until dolphin process is ready	
	Write-Output "Waiting for Dolphin Process to Load"
	do 
	{
		$dolphinProcessActive = Get-Process -Id $dolphinId -ErrorAction SilentlyContinue
	} Until ($dolphinProcessActive)
	#Seems that I need this for now :(
	Sleep 2 

	#This shell lets you simulate keypresses
	$wshell = New-Object -ComObject wscript.shell;
	
	#Pass it the process id of the process that it will make active
	#Need to check if this is true. If it isn't, then ignore the rest of the script and show an error message
	
	if ($wshell.AppActivate($dolphinId) -eq "True") {
	
	Write-Output "Connecting to $($hostCode)"
	Write-Output "1v1, Final Destination, No Items"

	$wshell.SendKeys("%tn")
	#This works even if the last entered code was invalid :)
	$wshell.SendKeys("{UP}")
	$wshell.SendKeys($hostCode)
	$wshell.SendKeys("{ENTER}")
	
	} else {
	Write-Error "Cannot find Dolphin Process, make sure that $($dolphinPath) is correct!"
	}
	

}
