/*
automatisch:
lautsprecher realtek (volume am besten mit)
aufnahmegerät stereomix
am besten entsprechend 48kHz automatisch einstellen
foobar starten -> playback record
plugin laden 
-> vielleicht standard cfg files von foobar abspeichern und atom. einlesen (zumindest wiedergabegerät und DSP chain) vielleicht auch buffersize
strg + u und dann record und enter
foobar minimieren oder hiden (setting)

commands:


*/

#NoEnv
SetBatchLines -1
#SingleInstance, Force
#notrayicon
ListLines Off

#include va.ahk

if (settingsread()) {
	loop 3 {
		VA_SetDefaultEndpoint(standard_audio_device, A_index)
		VA_SetDefaultEndpoint(standard_mic, A_index)
	}
	run, %foobarexe% record://
	WinWaitActive, ahk_exe %foobarexe%
	WinHide, ahk_exe %foobarexe%
} else {
	run, settings.ini
	WinWaitActive, settings
	;MsgBox, 0, , please type in names of your audio loopback devices (shown in sound config, PAY ATTENTION TO CAPITALIZATION) and save . .`n`nwhen you are ready, restart program to test.`n`n(usually generic analog speaker and "stereomix")
	;MsgBox, 64, , please type in names of your audio loopback devices (shown in sound config`, PAY ATTENTION TO CAPITALIZATION) and save.`n`nwhen you are ready`, restart program to test.`n`n(usually generic analog speaker and "stereomix")`n`nMADE BY PETER HOLZ donate:`n<a href="https://www.paypal.me/peterholz1">https://www.paypal.me/peterholz1</a>
	
	
	Gui, Add, Link, x42 y19 w470 h140 , please type in names of your audio loopback devices (shown in sound config`, PAY ATTENTION TO CAPITALIZATION) and save.`n`nwhen you are ready`, restart program to test.`n`n(usually generic analog speaker and "stereomix")`n`nMADE BY PETER HOLZ donate:`n<a href="https://www.paypal.me/peterholz1">https://www.paypal.me/peterholz1</a>
	Gui, Show, w552 h171, 
}
GuiClose:
ExitApp


write_std_settings(n) {
	
	standard_audio_device := "Lautsprecher"
	standard_mic := "Stereomix"
	foobarexe := "C:\Program Files (x86)\foobar2000\foobar2000.exe"

	if (n=1 or n=0)
		iniwrite, %standard_audio_device%, settings.ini, settings, standard_audio_device
	
	if (n=2 or n=0)
		iniwrite, %standard_mic%, settings.ini, settings, standard_mic
	
	if (n=3 or n=0)
		iniwrite, %foobarexe%, settings.ini, settings, foobarexe	
	
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
	if (standard_audio_device = "ERROR")
		write_std_settings(1)

	iniread, standard_mic, settings.ini, settings, standard_miciniread, standard_mic, settings.ini, settings, standard_mic
	if (standard_mic = "ERROR") 
		write_std_settings(2)
	
	return ret

}

check_program_availability() {
	global
	
	boo := true

	if !FileExist(foobarexe) { ;TRY benutzen für fehler in general
		boo := false
		MsgBox, 32, , Please select the fooobar2000.exe path. `n`n(it will show a window after clicking ok)
		FileSelectFile, foobarexe, 1,  %foobarexe% , select your fooobar2000.exe path., Executables (*.exe)
		if (errorlevel)
			throw, Exception("skip foobar path selection")
	}
	foobarexe := SubStr(foobarexe, InStr(foobarexe, "\", false, 0, 1)+1 , strlen(foobarexe))

	return boo
}


/*
~space::
standard_audio_device := p_WinGetActiveTitle()
return

;setting read analog von atom autorum übernehemn
;funktion um audiogerät silent zu ändern? am besten identifizieren am namen!



;1. in liste kommen
;2. alle einträge überprüfen
if name_of_audiodevice()=standard_audio_device
	