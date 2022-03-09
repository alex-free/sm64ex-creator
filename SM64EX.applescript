-- SM64EX Launcher by Alex Free V1.0 - 3/8/2022
set actionChoice to (choose from list {"Start Game", "Edit Config File", "Open Preferences Folder"} with prompt "SM64EX Launcher" OK button name "OK" cancel button name "Cancel" default items "Start Game" without multiple selections allowed) as text

set btest to POSIX path of ((path to me as text))

if actionChoice is "Start Game" then
	do shell script "cd " & btest & "; ./sm64.* --savepath . --configfile sm64config.txt"
else if actionChoice is "Edit Config File" then
	do shell script "open -e \"" & btest & "/sm64config.txt\""
else if actionChoice is "Open Preferences Folder" then
	do shell script "open \"" & btest & ""
end if
