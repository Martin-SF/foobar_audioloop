/*
automatisch:
lautsprecher realtek (volume am besten mit)
aufnahmeger�t stereomix
am besten entsprechend 48kHz automatisch einstellen
foobar starten -> playback record
plugin laden 
-> vielleicht standard cfg files von foobar abspeichern und atom. einlesen (zumindest wiedergabeger�t und DSP chain) vielleicht auch buffersize
strg + u und dann record und enter
foobar minimieren oder hiden (setting)

commands:




VOLUMEN VON LAUTSPRECHER AUF 50 SETZEN IMMER

wenn spotiamb ge�ffnet wird:

spini := c:\Users\Martin\AppData\Roaming\Spotiamb\
iniwrite, 0, spini, Main, wave_device

*/
#NoEnv
SetBatchLines -1
#SingleInstance, Force
ListLines Off
#warn
SetWorkingDir, A_ScriptDir

#include va.ahk

if (settingsread()) {
	loop 3 {
		VA_SetDefaultEndpoint(standard_audio_device, A_index)
		VA_SetDefaultEndpoint(standard_mic, A_index)
	}

	run, %foobarexe% record://
	WinWaitActive, ahk_exe %foobarexe%
	if winactive(,"Start foobar2000 in safe mode") {
		;MsgBox, 48, , please solve foobar troubles first then restart me
		exitapp
	}
	if (foohide)
		WinHide, ahk_exe %foobarexe%
} else {
	run, settings.ini ;sound
	WinWaitActive, settings
	Gui, Add, Link, x42 y19 w470 h140 , please type in names of your audio loopback devices (shown in sound config`, PAY ATTENTION TO CAPITALIZATION) and save.`n`nwhen you are ready`, restart program to test.`n`n(usually generic analog speaker and "stereomix")`n`nMADE BY PETER HOLZ donate:`n<a href="https://www.paypal.me/peterholz1">https://www.paypal.me/peterholz1</a>
	Gui, Show, w552 h171, 
	return
}
GuiClose:
ExitApp

*Space::
exitapp

write_std_settings(n) {
	
	standard_audio_device := "Lautsprecher"
	standard_mic := "Stereomix"
	foobarexe := "C:\Program Files (x86)\foobar2000\foobar20000.exe"
	foohide := true


	if (n=1 or n=0)
		iniwrite, %standard_audio_device%, settings.ini, settings, standard_audio_device
	
	if (n=2 or n=0)
		iniwrite, %standard_mic%, settings.ini, settings, standard_mic
	
	if (n=3 or n=0)
		iniwrite, %foobarexe%, settings.ini, settings, foobarexe	
	
	if (n=4 or n=0)
		iniwrite, %foohide%, settings.ini, settings, foohide	
	
	if n=0 
		MsgBox, 262208, , Pleas configure foobar like this:`n`n1. `n	Shell Integration -> set "enqueue" as the default action ->`n	UNTICK`n`n2. (optional because "stereomix" is 48kz restricted so you dont resample twice)`n 	Advanced -> Recording -> 48000 Hz Samplerate `n
}

settingsread() {
	global
	
	ret := true
	
	if !FileExist("settings.ini") {
		write_std_settings(0) 
		ret := false
	}
	
	
	
	iniread, foobarexe, settings.ini, settings, foobarexe
	
	if (check_program_availability()=false) 
		iniwrite, %foobarexe%, settings.ini, settings, foobarexe
	
	iniread, standard_audio_device, settings.ini, settings, standard_audio_device
	if (standard_audio_device = "ERROR" or checkdevice_availability()=false)
		write_std_settings(1)

	iniread, standard_mic, settings.ini, settings, standard_miciniread, standard_mic, settings.ini, settings, standard_mic
	if (standard_mic = "ERROR" or checkdevice_availability()=false) 
		write_std_settings(2)
	
	iniread, foohide, settings.ini, settings, foohide
	if (foohide != false or foohide != true)
		write_std_settings(4)
	
	return ret

}

checkdevice_availability() {
	
	numofdevices := 100
	
	loop numofdevices {
		;if (VA_GetDeviceName(VA_GetDevice("playback")) != standard_audio_device or VA_GetDeviceName(VA_GetDevice("capture")) != standard_mic)
		if (VA_GetDeviceName(A_index) != standard_audio_device 
			msgbox err
	
	}
}
	

check_program_availability() {
	global
	
	boo := true

	if !FileExist(foobarexe) { ;TRY benutzen f�r fehler in general
		boo := false
		MsgBox, 32, , Please select the fooobar2000.exe path. `n`n(it will show a window after clicking ok)
		FileSelectFile, foobarexe, 1,  %foobarexe% , select your fooobar2000.exe path., Executables (*.exe)
		if (errorlevel)
			throw, Exception("skip foobar path selection")
	}
	;foobarexe := SubStr(foobarexe, InStr(foobarexe, "\", false, 0, 1)+1 , strlen(foobarexe))

	return boo
}

check_updates() {
	
	URLDownloadToFile, https://github.com/Martin-SF/foobar_audioloop/blob/master/version.txt , %A_Temp%\version.txt 
	IniRead, v , %A_Temp%\version.txt , 
	
}