#
#	wolenable.ps1
#	by:  van Gennip Brett 
#	Date: Dec 15, 2015
#
##############################

$model=$(gwmi win32_computersystem).model
$compname=$env:COMPUTERNAME

#########################
#
#      Dell Laptops
#########################

#Added 7470 to the list 11/10/2016 bvg

if($model -like "*E7470*"){
    if(-not(test-path wol-7470.exe)){
        cp wol-7470.exe 
		if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
    }
    if(-not(test-path wol-7470.txt)){
        start wol-7470.exe
		sleep 120
			if($?){
				cat wol-7470.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
    }
}



if($model -like "*E7450*"){
    if(-not(test-path wol-7450.exe)){
        cp wol-7450.exe 
		if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
    }
    if(-not(test-path wol-7450.txt)){
        start wol-7450.exe
		sleep 120
			if($?){
				cat wol-7450.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
    }
}

if($model -like "*E7440*"){
    if(-not(test-path wol-7440.exe)){
        cp wol-7440.exe 
		if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
    }
    if(-not(test-path wol-7440.txt)){
        start wol-7440.exe
		sleep 120
		if($?){
				cat wol-7440.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
    }
}

if($model -like "*E6430*"){
    if(-not(test-path wol-6430.exe)){
        cp wol-6430.exe 
    	if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
		}
    if(-not(test-path wol-6430.txt)){
        start wol-6430.exe
		sleep 120
		if($?){
				cat wol-6430.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
    }
}

#########################
#
#      Dell Desktops
#########################

#Optiplex 9020


if($model -like "*9020*"){
	if($model -like "*9020M"){
		if(-not(test-path wol-9020M.exe)){
        cp wol-9020M.exe 
    	if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
	}
    if(-not(test-path wol-9020M.txt)){
        start wol-9020M.exe
		sleep 120
   		 if($?){
				cat wol-9020M.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
	}
}else{

    if(-not(test-path wol-9020.exe)){
        cp wol-9020.exe 
    	if($?){
				write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
			}
	}
    if(-not(test-path wol-9020.txt)){
        start wol-9020.exe
		sleep 120
   		 if($?){
				cat wol-9020.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
	}
}
}

#Optiplex 9010

if($model -like "*9010*"){
    if(-not(test-path wol-9010.exe)){
        cp wol-9010.exe 
	if($?){
			write-output "INFO: Copied to Desktop" | Out-File -Append $compname.txt
		}else{
			write-output "ERROR:  Failed to Desktop" | Out-File -Append $compname.txt
		}
    }
    if(-not(test-path wol-9010.txt)){
        start wol-9010.exe
		sleep 120
		 if($?){
				cat wol-9010.txt | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Failed to run bios modification." | Out-File -Append $compname.txt
			}
    }
}

#############################
#
#   Enable the NIC for WOL
#############################


#Finds the appropriate NIC
$nic= gwmi win32_networkadapter -filter "netenabled = 'true'" | where {$_.name -like "*ethernet*" -or $_.name -like "*gigabit*"}
 		if($?){
				write-output "Info: network adapter detected" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR: network adapter not detected" | Out-File -Append $compname.txt
			}


#Permits the NIC to turn on the computer
$nicPower = gwmi MSPower_DeviceWakeEnable -Namespace root\wmi | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID)}
$nicPower.Enable = $true
$nicPower.psbase.Put()
		if($?){
				write-output "Info: network adapter enabled for DeviceWakeEnable" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Device Wake Enable Failed to apply DeviceWakeEnable" | Out-File -Append $compname.txt
			}

#enables the Wake on lan for magic packet only to wake the device
$nicPower2 = gwmi MSNdis_DeviceWakeOnMagicPacketOnly -Namespace root\wmi | where {$_.instancename -match [regex]::escape($nic.PNPDeviceID)}
$nicPower2.EnableWakeOnMagicPacketOnly = $true
$nicPower2.psbase.Put()

		if($?){
				write-output "Info: network adapter enabled for DeviceWakeOnMagicPacketOnly" | Out-File -Append $compname.txt
			}else{
				write-output "ERROR:  Device Wake Enable Failed to apply DeviceWakeOnMagicPacketOnly" | Out-File -Append $compname.txt
			}
