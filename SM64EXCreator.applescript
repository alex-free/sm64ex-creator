--SM64EXCreator.app By Alex Free
--V1.0 3/8/2022

global w1
set sdl1 to ""
set sdl2 to ""
set gl1 to ""
set gl2 to ""
set branch to "nightly"
set btest to ""
set build to ""
set region to ""
set japan to "8a20a5c83d6ceb0f0506cfc9fa20d8f438cafe51"
set usa to "9bef1128717f958171a4afac3ed78ee2bb4e86ce"
set xcode to "/Developer"
set portable_app to POSIX path of (path to desktop) & "SM64EX.app"

tell application "System Events"
	if not (exists folder xcode) then
		display dialog "Error: SM64EXCreator Requires Xcode version 2.5 to be installed. Please install Xcode 2.5 and then open SM64EXCreator.app." buttons {"OK"}
		
		set actionChoice to (choose from list {"Yes", "No"} with prompt "Would you like to download Xcode 2.5 with your default web browser now?" OK button name "OK" cancel button name "Cancel" default items "Yes" without multiple selections allowed) as text
		if actionChoice is "Yes" then
			do shell script "open http://macintoshgarden.org/sites/macintoshgarden.org/files/apps/xcode25_8m2558_developerdvd.dmg"
		end if
		error number -128
	end if
end tell

tell application "Finder"
	set btest to POSIX path of ((path to me as text))
end tell

if btest is "/Applications/SM64EXCreator.app/" then
	set rom to POSIX path of (choose file with prompt "Select your USA or Japan Super Mario 64 .z64 ROM file (required to extract game assets):")
	tell me to activate
	
	set rom_sha1 to do shell script "cat \"" & rom & "\" | openssl dgst -sha1 -binary | xxd -p"
	
	if rom_sha1 is equal to japan then
		set region to "jp" as text
		display dialog "Successfully verified that this is a Japan Super Mario 64 .z64 ROM file!"
	else if rom_sha1 is equal to usa then
		set region to "us" as text
		display dialog "Successfully verified that this is a USA Super Mario 64 .z64 ROM file!"
		
	else
		display dialog "This ROM file (SHA1SUM: " & rom_sha1 & ") is not a valid USA or Japan .z64 file and can't be used."
		error number -128
	end if
	
else if btest is not "/Applications/SM64EXCreator.app/" then
	tell me
		activate
		(display dialog "SM64EXCreator.app has to be in the /Applications directory to continue." buttons "OK")
		error number -128
	end tell
end if

set actionChoice to (choose from list {"OpenGL 1", "OpenGL 2"} with prompt "SM64EX supports both an OpenGL 1 and OpenGL 2 renderer. Which would you like to use?" OK button name "OK" cancel button name "Cancel" default items "OpenGL 1" without multiple selections allowed) as text

if actionChoice is "OpenGL 1" then
	set gl1 to "true" as text
	set build to "true" as text
else if actionChoice is "OpenGL 2" then
	set gl2 to "true" as text
	set build to "true" as text
else
	error number -128
end if

if gl1 is "true" then
	set command to "gmake LEGACY_OSX_BUILD=1 WINDOW_API=SDL1 AUDIO_API=SDL1 CONTROLLER_API=SDL1 RENDER_API=GL_LEGACY VERSION=" & region & "" as text
else if gl2 is "true" then
	set command to "gmake LEGACY_OSX_BUILD=1 WINDOW_API=SDL1 AUDIO_API=SDL1 CONTROLLER_API=SDL1 VERSION=" & region & "" as text
end if

if build is "true" then
	tell application "System Events"
		set terminalRunning to count of (every process whose name is "Terminal")
		if terminalRunning is 1 then
			tell application "Terminal"
				activate
			end tell
			tell application "System Events" to keystroke "n" using command down
			tell application "Terminal"
				set background color of first window to "black"
				set cursor color of first window to "white"
				set normal text color of first window to "white"
				set bold text color of first window to "white"
				set w1 to first window
			end tell
		else
			tell application "Terminal"
				activate
			end tell
			tell application "Terminal"
				set background color of first window to "black"
				set cursor color of first window to "white"
				set normal text color of first window to "white"
				set bold text color of first window to "white"
				set w1 to first window
			end tell
		end if
	end tell
	
	tell application "Terminal"
		do script "" & btest & "/compile " & branch & " \"" & rom & "\" \"" & command & "\" " & region & "" in w1
	end tell
end if