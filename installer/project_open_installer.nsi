# -----------------------------------------------------------------------
# ]project-open[ V5.2 Installer
#
# (c) ]project-open[ Busines Solutions, S.L. and 
#     SPAZIO IT � Soluzioni Informatiche s.a.s. 
#
# This installer code is licenses under the GPL V2 or higher.
# Attention: Compile this only with NSIS-strlen-8192
# -----------------------------------------------------------------------

!define PRODUCT		"]project-open["
!define COMPANY		"]project-open[ Business Solutions, S.L."
!define SHORTNAME	"project-open"
!define DESCRIPTION	"]project-open[ Project Management"
!define	URL		https://www.project-open.com
!define REGKEY		"SOFTWARE\${SHORTNAME}"

!define VERSION_MAJ	"5.2.0"
!define VERSION_MIN	"2.9"
!define RELEASE		"003"

Name			"${PRODUCT} ${VERSION_MAJ}.${VERSION_MIN}"
Caption			"${DESCRIPTION}" 
!define TARGET		c:\project-open
!define NSD_VER		"naviserver499"
SetCompress		auto

# Create installer without the initial tests if already installed?
#!define NOTEST 1
# Create installer without files? Used for testing
#!define NOFILE 1

# Output
!define OUTPATH 	"e:\download"
!define OUTBASE		"project-open-Windows-Community-${VERSION_MAJ}.${VERSION_MIN}-${RELEASE}"
OutFile			"${OUTPATH}\${OUTBASE}.exe"


# -----------------------------------------------------------------------
# Bugs
# -----------------------------------------------------------------------

# 2 1	Permission issue on Windows 7:
#	icacls c:/project-open /reset /T /c
#
# 3 1	/usr/bin/chgrp: invalid group: 'Users'
#	Modified group ownership of /pgsql: result=1
# 3	Uninstall Registry: HKCU/SOFTWARE/Cygwin/*
# 5 4	Uninstaller leaves AOLDIR and CYGWIN env vars
# ------
# 7	Service Panel: Add mouse-over to show that icons are clickable
# 7	Service Panel: Link for local server
# 8 2	ZIP download from intranet-filestorage doesn't work
# 9 4	Handle email sending


# -----------------------------------------------------------------------
# Bugs Done
# -----------------------------------------------------------------------

# 020	First version working on D:\project-open\
# 021	sed.exe now replaces with /gi,
#	now stopping services on the build machine,
#	outcommented installer file delete,
#	new NSIS 3.0.1 with strlen-8192
# 022	Convert upper-case drive letters to lower-case
# 023-026 Playing with different versions from Maurizio's
#	NaviServer
# 027	Added descriptions to Windows services
# 028	Fixing conf files c:/project-open,
#       Replacing apm_parameter_values c:/project-open string
# 001	Fixed exec issue, new Service Panel, MAC fix etc.
# 2	Uninstaller doesn't delete files
# 2	Uninstaller doesn't delete ]po[ service monitor
# 4	Added descriptions to Windows services installed by ]po[
# 4	Create a description for the ]po[ services
# 2	Internal error: couldn't open "c:/tmp/oacs-a039441491512894839.rpc2":
# 	Need to modify acs_parameters to accodmodate INSTDIR
# 2	Uninstaller doesn't stop ]po[ service monitor before uninstalling
# 1 	pgsql call doesn't work (from executing upgrade scripts)
#	Added in config.tcl: ns_section "ns/db/driver/postgres" -> ns_param pgbin
#	"c:/project-open/pgsql/bin"
# 5	Portrait upload/delete doesn't work
# 1	bash -c "..." doesn't work
# 1	Check CSV Import because of exec change
# 1	Check /intranet-filestorage/: invalid command name: "::exec_orig"
# 3	Update service monitor to reflect new service names
# 2 8	Update po-service-panel using Eclipse or add start/stop scripts 
#	for the various services
# 3 	Need to revise ]po[ Service Monitor
# 3 1	w32oacs_get_mac doesn't exist, called in intranet-defs-procs.tcl
# 2 2	Fix issue with IP address on index.vmware-ajax
# 3 2	Centralize all calls to ifconfig or ipconfig
# 4 1	Change the index.vmware.adp to use the im_hardware_id
#	MAC address in intranet-defs-procs.im_hardware_id
# 1	Rogue chmod breaks installer
# 3 	GanttEditor: Error saving data on the server side: 
#	No authentication found ('').
# 2	Chmod not modifying Registry permissions anymore
# 3	Chmod now executed using nsExec::ExecToStack
# 4	Added copyright and description to installer executable
# 2 1	Set ownership to Administrator:Administrators to all CygWin files,
#	independent of language. Necessary for WS2012.
# 3	Display release notes before finishing the installer
#	Removed GetWinVersion information
# 3	mkpasswd: non-option command line argument `/etc/passwd' is not allowed.
# 3	"Open ]project-open[" Link in installer doesn't work
# 1	ServiceMonitor doesn't work due to missing SOFTWARE\Cygwin\setup\rootdir reg key.
# 2	Installer Link "Go to ]po[" (open browser) not working
# 3 1	WS2016 reported as WS2012
# 7 4	Service Monitor: parse AOLserver and PG log files for indicator
# 4 1	Need to delete all cygwin*, project-open*, projop*, naviserver*,
#	po-service-monitor*, postgres* registry keys 
# 4	Update the Service Panel to include Klaus new design
# 4	Error: im_audit: Error executing im_audit_impl: no current connection
# 3	Windows 10 recognized by installer als Windows 8.1
# 2 1	/intranet-filestorage/ on 2016:
#	Unable to get file list from 'nodosfilewarning/servers/projop/filestorage/home':
#	find_path=nodosfilewarning/servers/projop/filestorage/home
#	FIND: Parameter format not correct
# 2	Filestorage still not working with WS2016
# 5 2	Review & fix configuration process "Segment" wizard
# 5 3	Logroll doesn't work. Check cacls.exe or xcacls.exe to remove
#	the special DENY permissions for Administratoren
# 4 2	Handle automatic update after installation
# 4 1	NaviServer doesn't restart after "restart server"
# 4 1	couldn't execute "touch": no such file or directory
# 3 1	Fixed ns_db_pgbin call in backup
# 4 2	Added uptime.exe
# 3 1	xotcl-request-monitor now working
# 3 3	Updated Maurizios NSD to 2017-06-26, fixing server-restart issue
# 4 1	Fixed NSD issue with nsthread library (thread2.8.0.dll).
#	Copied /usr/local/tcl8.5.18 to tcl8.5.19, faking a new TCL version
#	Removed chmod and chgrp commands and replaced by icaclt
#	Changed mkpasswd -l and mkgroup -l to be executed directly instead of bash


# -----------------------------------------------------------------------
# Installer
# -----------------------------------------------------------------------

!define VERSION		"${VERSION_MAJ}.${VERSION_MIN}"

# Incude for updating the Path
!include project_open_installer_env_var_update.nsh
!include project_open_installer_registry.nsh
!include project_open_installer_ports.nsh
!include project_open_installer_l10n_strings.nsh
!include project_open_installer_strfilter.nsh
!include project_open_installer_create_internet_shortcut.nsh

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Admin
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME MultiUserInstallMode
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR 'C:\project-open'
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE Path

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\nsis1-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh
!include x64.nsh
!include LogicLib.nsh



# Variables
Var StartMenuGroup
InstallDir 'C:\project-open'
Var instv

# ---------------------------------------------------
# Installer pages
# ---------------------------------------------------

!insertmacro MUI_PAGE_WELCOME
Page custom windowsVersionPage windowsVersionPageLeave
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_LICENSE ${TARGET}\installer\version_copyright_disclaimer_po.txt
!define MUI_DIRECTORYPAGE_VARIABLE $instv
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_TEXT "Open ]project-open["
    !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchProjectOpen"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_RESERVEFILE_LANGDLL



var Dialog
Var Label
Var CheckBox
var ExitCode
var WinVerText
var WinVer
var WinProductName
Function windowsVersionPage
	!insertmacro MUI_HEADER_TEXT "Release Notes" "Please review the release notes for your Windows version"
        nsDialogs::Create 1018
        Pop $Dialog
	${If} $Dialog == error
		Abort
		# ExecShell "open" "https://www.project-open.net/en/"
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "Please check the release notes for known issues with your Windows version:"
	Pop $Label

	# Get the Windows version from "ver"
	nsExec::ExecToStack "cmd /C ver"
	Pop $ExitCode
	Pop $WinVerText	
	# Search for "Windows" and return anything after that word
	${StrStr} $0 $WinVerText "Version"
	# Extract only numbers and "." from the string
	${StrFilter} $0 "1" "." "" $WinVer
	
	ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "ProductName"
	${NSD_CreateLabel} 0 20u 100% 12u "Windows: $R0"
	Pop $Label
	${NSD_CreateLabel} 0 32u 100% 12u "Build: $WinVer"
	Pop $Label

	# Check for 32bit vs. 64bit systems
	${if} ${RunningX64}
		${NSD_CreateLabel} 0 44u 100% 12u "Word width: 64bit"
		Pop $Label   
	${else}
		${NSD_CreateLabel} 0 44u 100% 12u "Word width: 32bit"
		Pop $Label
	${endIf}

	# Link for reviewing release notes
	${NSD_CreateLink} 12u 60u 100% 12u "Review release notes for Windows $R0 ($WinVer)"
	Pop $R9
	${NSD_OnClick} $R9 windowsVersionPageOnClick

	# Create checkbox in front of "Review release notes..."
	${NSD_CreateCheckBox} 0u 60u 10u 10u ""
	Pop $CheckBox
	${NSD_Check} $CheckBox
	
	nsDialogs::Show
FunctionEnd

Function windowsVersionPageLeave
	# Open the release notes unless unchecked
	${NSD_GetState} $CheckBox $0
	${If} $0 == "1"
		Push ""
		Call windowsVersionPageOnClick
	${EndIf}

	# Warn about 32bit systems
	${if} ${RunningX64}
		DetailPrint "Found 64-bit Windows"    
	${else}
		MessageBox MB_OK $(message012)
		Abort
	${endIf}

FunctionEnd


var PoVersionDashes
var WordWidth
Function windowsVersionPageOnClick
	pop $0

	# ]po[ Version with dashes ('-') instead of dots ('.')
	${StrRep} $PoVersionDashes '${VERSION_MAJ}.${VERSION_MIN}' '.' '-'

	# 32bit vs. 64bit systems
	${if} ${RunningX64}
		StrCpy $WordWidth "64bit"
	${else}
		StrCpy $WordWidth "32bit"
	${endIf}

	# Get the Windows version from "ver"
	nsExec::ExecToStack "cmd /C ver"
	Pop $ExitCode
	Pop $WinVerText	
	# Search for "Windows" and return anything after that word
	${StrStr} $0 $WinVerText "Version"
	# Extract only numbers and "." from the string
	${StrFilter} $0 "1" "." "" $WinVer	
	ReadRegStr $WinProductName HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" "ProductName"

	ExecShell "open" "https://www.project-open.net/en/version-$PoVersionDashes?os=windows&installer=${VERSION_MAJ}.${VERSION_MIN}-${RELEASE}&build=$WinVer&width=$WordWidth&product_name=$WinProductName" 
FunctionEnd



CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion "${VERSION}"
VIAddVersionKey ProductName "${PRODUCT}"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription "${DESCRIPTION}"
VIAddVersionKey LegalCopyright "Copyright (c) 2003-2017 ${COMPANY} and others"
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show


# ---------------------------------------------------
# Actions to be executed _before_ actually compiling
# ---------------------------------------------------

!system '${TARGET}\bin\cp /installer/project_open_installer.nsi /servers/projop/packages/intranet-core/preconf/'
!system '${TARGET}\bin/bash -c "cd ~/packages/intranet-core"'
!system 'c:\windows\system32\sc.exe stop po-service-monitor'
!system '${TARGET}\bin\sleep 1'
!system 'c:\windows\system32\sc.exe stop po-projop'
!system '${TARGET}\bin\sleep 1'
!system 'c:\windows\system32\sc.exe stop postgresql-16.6'
!system 'c:\windows\system32\sc.exe stop postgresql-9.2'
!system '${TARGET}\bin\sleep 1'
Section
	StrCpy $INSTDIR $instv
SectionEnd


# ---------------------------------------------------
# Main Installer Section
# ---------------------------------------------------

# ---------------------------------------------------
# Check for error conditions _before_ the actual
# installer starts
#
Section -Main SEC0000

    # ---------------------------------------------------
    # Check for spaces in path
    #
    AddSize 102400
    Push $INSTDIR
    Call CheckForSpaces
    Pop $R0
    StrCmp $R0 0 NoSpaces
    MessageBox MB_OK $(message000)
    Abort
NoSpaces:

!ifndef NOTEST
    # ---------------------------------------------------
    # Check if ]po[ was already installed
    #
    ${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\${SHORTNAME}" $R0
    ${if} $R0 != -1
    MessageBox MB_OK $(message001)
    Abort
    ${endif}

    # ---------------------------------------------------
    # 
    ${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\PostgreSQL" $R0
    ${if} $R0 != -1
    MessageBox MB_OK $(message002)
    Abort
    ${endif}

    # ---------------------------------------------------
    #
    ${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\Cygnus Solutions\Cygwin" $R0
    ${if} $R0 != -1
    MessageBox MB_OK $(message004)
    Abort
    ${endif}
    ${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\Cygwin" $R0
    ${if} $R0 != -1
    MessageBox MB_OK $(message004)
    Abort
    ${endif}

    # ---------------------------------------------------
    # 
    ${if} ${TCPPortOpen} 8000
    MessageBox MB_OK $(message005)
    Abort
    ${EndIf}

    # ---------------------------------------------------
    # 
    ${if} ${TCPPortOpen} 7999
    MessageBox MB_OK $(message005)
    Abort
    ${EndIf}

    # ---------------------------------------------------
    # 
    ${if} ${TCPPortOpen} 5432
    MessageBox MB_OK $(message006)
    Abort
    ${EndIf}
!endif


    # ---------------------------------------------------    
    # Pack files

    SetOverwrite on

!ifndef NOFILE
    # Write out /var/ folder with exception of active *.log files
    Delete /REBOOTOK ${TARGET}\var\spool\mail\*
    Delete /REBOOTOK ${TARGET}\var\log\*
    Delete /REBOOTOK ${TARGET}\var\cache\*
    Delete /REBOOTOK ${TARGET}\var\log\exim\* 
    SetOutPath $INSTDIR\var
    File /a /r /x *.log ${TARGET}\var\*

    # Write out the /etc/ folder with exception of some private files
    SetOutPath $INSTDIR\etc
    File /a /r \
    /x \etc\setup\* \
    /x ssh_host_dsa_key \
    /x ssh_host_dsa_key.pub \
    /x ssh_host_ecdsa_key \
    /x ssh_host_ecdsa_key.pub \
    /x ssh_host_key \
    /x ssh_host_key.pub \
    /x ssh_host_rsa_key \
    /x ssh_host_rsa_key.pub \
    /x passwd \
    /x group \
    ${TARGET}\etc\*

    SetOutPath $INSTDIR\bin
    File /a /r ${TARGET}\bin\*

    SetOutPath $INSTDIR\installer
    File /a /r /x NSIS /x pg_dump.vanilla.sql /x pg_dump.vanilla.sql.gz /x naviserver499.zip /x tcl8.5.19.zip ${TARGET}\installer\*

    SetOutPath $INSTDIR\lib
    File /a /r ${TARGET}\lib\*

    SetOutPath $INSTDIR\home
    SetOutPath $INSTDIR\tmp

    SetOutPath $INSTDIR\jre
    File /a /r ${TARGET}\jre\*

    SetOutPath $INSTDIR\pgsql
    File /a /r /x doc /x include ${TARGET}\pgsql\*

    # The main ]po[ server, excluding the log and backup files
    Delete ${TARGET}\servers\projop\log\*
    SetOutPath $INSTDIR\servers\projop
    File /a /r /x error.log /x projop.log /x pg_dump*.sql ${TARGET}\servers\projop\*
    SetOutPath $INSTDIR\servers\projop\log

    SetOutPath $INSTDIR\usr
    File /a /r ${TARGET}\usr\*

    SetOutPath $INSTDIR\tcl
    File /a /r ${TARGET}\tcl\*

    SetOutPath $INSTDIR
    File ${TARGET}\Cygwin.bat
    File ${TARGET}\Cygwin-Terminal.ico
    File ${TARGET}\Cygwin.ico
    File ${TARGET}\setup-x86_64.exe
!endif

    # --------------------------------------------------------
    # Create Program Group for ]po[
    #
    SetOutPath $SMPROGRAMS\$StartMenuGroup

    # Create shortcut to open ]po[ in a browser
    !insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuGroup\]project-open[ Documentation" "https://www.project-open.com/en/" "$INSTDIR\installer\browser.ico" "0"
    !insertmacro CreateInternetShortcut "$SMPROGRAMS\$StartMenuGroup\Open ]project-open[" "http://localhost:8000/" "$INSTDIR\installer\browser.ico" "0"
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\CygWin Shell.lnk" "$INSTDIR\bin\mintty.exe" "-i /Cygwin-Terminal.ico -"
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\pgAdminIII.lnk" "$INSTDIR\pgsql\bin\pgAdmin3.exe" ""
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\]po[ Service Monitor.lnk" "$INSTDIR\jre\bin\javaw" "-jar $INSTDIR\installer\po-service-monitor.jar"

    # Autostart Service Monitor
    CreateShortcut "$SMPROGRAMS\Startup\]po[ Service Monitor.lnk" "$INSTDIR\jre\bin\javaw" "-jar $INSTDIR\installer\po-service-monitor.jar"

    # Don't know what this is for...
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
    
    # Write CygWin root dir
    WriteRegStr HKLM "SOFTWARE\Cygwin\setup" "rootdir" "$INSTDIR"

    # --------------------------------------------------------
    # Set PATH and other environment variables
    #
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\pgsql\bin"
    ${EnvVarUpdate} $0 "AOLDIR" "A" "HKLM" "$INSTDIR"
    ${EnvVarUpdate} $0 "CYGWIN" "A" "HKLM" "nodosfilewarning"

SectionEnd


# --------------------------------------------------------
# Post Installation Actions
# --------------------------------------------------------

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1


    # Tell CygWin about it's root folder
    DetailPrint "About to write CygWin registry key: HKLM.SOFTWARE\Cygwin\setup.rootdir = $INSTDIR"
    WriteRegStr HKLM "SOFTWARE\Cygwin\setup" "rootdir" "$INSTDIR"
    DetailPrint "Written CygWin registry key"

    SetOutPath $INSTDIR


    # ----------------------------------------------------
    # Install the MS VC++ Redistributable
    #
    DetailPrint "About to install MS VC++ redistributables"
    nsExec::ExecToLog "$INSTDIR\installer\vcredist_2010_x64.exe /passive"
    DetailPrint "Installed MS VC++ 2010 redistributable"
    nsExec::ExecToLog "$INSTDIR\installer\vcredist_2013_x64.exe /passive"
    DetailPrint "Installed MS VC++ 2013 redistributable"
    nsExec::ExecToLog "$INSTDIR\installer\vcredist_2015_x64.exe /passive"
    DetailPrint "Installed MS VC++ 2015 redistributable"
    
        
    # ----------------------------------------------------
    # Replace backslashes in INSTDIR and convert to lower case
    #
    ${StrRep} '$0' '$INSTDIR' '\' '/'
    Push $0
    Call StrLower
    Pop $0

    # ----------------------------------------------------
    # Setup CygWin
    #
    DetailPrint "About to create CygWin passwd and groups files."
    nsExec::ExecToLog 'cmd.exe /C "$INSTDIR\bin\mkpasswd.exe -l > $INSTDIR\etc\passwd"'
    pop $R0
    DetailPrint "Created /etc/passwd: result=$R0"
    
    nsExec::ExecToLog 'cmd.exe /C "$INSTDIR\bin\mkgroup.exe -l > $INSTDIR\etc\group"'
    pop $R0
    DetailPrint "Created /etc/group: result=$R0"

    # Grant everybody access to all files. That's necessary on
    # Windows 8, 10, Server 2012 and Server 2016 versions
!ifndef NOFILE
    DetailPrint "About to reset permissions using icacls. This may take several minutes, particularly on systems without SSD..."
    nsExec::ExecToStack 'icacls "$INSTDIR" /reset /T /c'
    pop $R0
    DetailPrint "Modified permissions of $INSTDIR using icacls"
!endif

    # DetailPrint "About to set permissions using chmod. This may take several minutes, particularly on systems without SSD..."
    # nsExec::ExecToStack '"$INSTDIR\bin\chmod" -R go=u bin etc home installer lib pgsql servers tcl tmp usr var'
    # pop $R0
    # DetailPrint "Modified permissions of /"


    
    # ----------------------------------------------------
    # Setup Service Monitor service
    #
    DetailPrint "About to install ]po[ Service Monitor service"
    nsExec::ExecToLog 'sc create po-service-monitor binpath= "$INSTDIR\installer\service.exe \"$INSTDIR\jre\bin\javaw -cp $INSTDIR\installer\po-service-monitor.jar org.projectopen.winservice.WinService\"" DisplayName= "]po[ Service Monitor Helper" start= "delayed-auto" type= own'
    pop $R0
    DetailPrint "Registered ]po[ Service Monitor Service: result=$R0"

    nsExec::ExecToLog 'sc start po-service-monitor'
    pop $R0
    DetailPrint "Started ]po[ Service Monitor Service: result=$R0"

    # Start the Windows client
    ExecCmd::exec /NOUNLOAD /ASYNC "$INSTDIR\jre\bin\javaw.exe -jar $INSTDIR\installer\po-service-monitor.jar"
    pop $R0
    DetailPrint "Started ]po[ Service Monitor GUI: result=$R0"

    # new 16.6: "C:\PostgreSQL\16\bin\pg_ctl.exe" runservice -N "postgresql-x64-16" -D "C:\PostgreSQL\16\data" -w
    # old 9.2: C:\project-open\pgsql\bin\pg_ctl.exe runservice -N postgresql-9.2 -D C:\project-open/pgsql/data -w


    # ----------------------------------------------------
    # Setup PostgreSQL service
    #
    # DetailPrint "About to install ]po[ PostgreSQL service"

    # Register & start PostgreSQL service
    nsExec::ExecToLog 'sc create postgresql-16.6 binPath= "$INSTDIR\pgsql\bin\pg_ctl.exe runservice -N postgresql-16.6 -D $INSTDIR/pgsql/data -w" DisplayName= "]po[ PostgreSQL 16.6" start= "delayed-auto" type= own '
    pop $R0
    DetailPrint "Registered ]po[ PostgreSQL Database Service: result=$R0"
    nsExec::ExecToLog 'sc start postgresql-16.6'
    pop $R0
    DetailPrint "Started ]po[ PostgreSQL Database Service: result=$R0"

    # Wait until the port is open.
    # PG startup may take quite some time on slow systems...
    DetailPrint "Waiting for PostgreSQL..."
    Sleep 5000
    ${Unless} ${TCPPortOpen} 5432
	Sleep 5000
        DetailPrint "Waiting for PostgreSQL..."
    ${EndUnless}

    DetailPrint "About to update ]po[ PostgreSQL path attributes"
    DetailPrint "About to execute: �$INSTDIR\pgsql\bin\psql\� -h localhost -c �update apm_parameter_values set attr_value = '$0' || substring(attr_value from 'c:/project-open(.*)') where lower(attr_value) like 'c:/project-open/%'� projop projop"
    nsExec::ExecToLog `"$INSTDIR\pgsql\bin\psql" -h localhost -c "update apm_parameter_values set attr_value = '$0' || substring(attr_value from 'c:/project-open(.*)') where lower(attr_value) like 'c:/project-open/%'" projop projop`
    pop $R0
    DetailPrint "Updated ]po[ PostgreSQL path attributes: result=$R0"


    # ----------------------------------------------------
    # Register ]po[ Naviserver service
    #
    DetailPrint "About to replace INSTDIR in config.aolserver451.tcl: sed.exe -i 's!c:/project-open!$0!gi' $INSTDIR\servers\projop\etc\config.aolserver451.tcl"
    nsExec::ExecToLog '$INSTDIR\bin\sed.exe -i "s!c:/project-open!$0!gi" $INSTDIR\servers\projop\etc\config.aolserver451.tcl'
    pop $R0
    DetailPrint "Replaced INSTDIR in config.aolserver451.tcl: result=$R0"

    DetailPrint "About to replace INSTDIR in config.naviserver499.tcl: sed.exe -i 's!c:/project-open!$0!gi' $INSTDIR\servers\projop\etc\config.naviserver499.tcl"
    nsExec::ExecToLog '$INSTDIR\bin\sed.exe -i "s!c:/project-open!$0!gi" $INSTDIR\servers\projop\etc\config.naviserver499.tcl'
    pop $R0
    DetailPrint "Replaced INSTDIR in config.naviserver499.tcl: result=$R0"
    
    DetailPrint "About to install ]po[ NaviServer service"
    nsExec::ExecToLog 'sc create po-projop binPath= "$INSTDIR\usr\local\${NSD_VER}\bin\nsd.exe -S -s projop -t $INSTDIR\servers\projop\etc\config.${NSD_VER}.tcl" DisplayName= "]po[ NaviServer Projop" start= "delayed-auto" type= own'
    pop $R0
    DetailPrint "Registered ]po[ NaviServer Projop: result=$R0"

    nsExec::ExecToLog 'sc config po-projop depend= postgresql-16.6'
    pop $R0
    DetailPrint "Created dependency from ]po[ NaviServer Projop to PostgreSQL: result=$R0"

    DetailPrint "About to set ]po[ NaviServer Projop restart behavior"
    nsExec::ExecToLog 'sc failure po-projop reset= 30000 actions= restart/30000/restart/30000/restart/30000'
    pop $R0
    DetailPrint "Set ]po[ NaviServer Projop restart behavior: result=$R0"

    DetailPrint "Starting ]po[ - this may take several minutes, particularly with SmartScreen/Defender enabled"
    nsExec::ExecToLog 'net start po-projop'
    pop $R0
    DetailPrint "]po[ started: result=$R0"


    # ----------------------------------------------------
    # Add descriptions to ]po[ services
    #
    nsExec::ExecToLog 'sc description po-service-monitor "]project-open[ Service Monitor helper - provides a back-end for the ]po[ Service Panel with permissions to start and stop the database and application server"'
    nsExec::ExecToLog 'sc description postgresql-16.6 "]project-open[ Database Server - provides persistent storage to the ]po[ Application Server"'
    nsExec::ExecToLog 'sc description po-projop "]project-open[ Application Server - executes the ]po[ application and answers to HTTP requests on port 8000"'


    # SetRebootFlag true
    SetRebootFlag false


    # ----------------------------------------------------
    # Write registry key for ]po[
    #
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR


    # ----------------------------------------------------
    # Setup the pgAdmin3 default database
    #
    #DetailPrint "Setting up pgAdminIII preconfiguration"
    #WriteRegDWORD HKCU	"Software\pgAdmin III\Servers"   "Count" 1
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Colour" ""
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Database" "projop"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "DbRestriction" ""
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Description" "localhost:projop (empty password)"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "DiscoveryID" ""
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "LastDatabase" "projop"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "LastSchema" "public"
    #WriteRegDWORD HKCU	"Software\pgAdmin III\Servers\1" "Port" 5432
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Restore" "true"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Server" "localhost"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "ServiceID" ""
    #WriteRegDWORD HKCU	"Software\pgAdmin III\Servers\1" "SSL" 0
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "StorePwd" "true"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\1" "Username" "projop"

    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\Hints" "saving-passwords" "Suppress"
    #WriteRegStr HKCU	"Software\pgAdmin III\Servers\Updates" "pgsql-Versions" "9.2"
    
    
    # ----------------------------------------------------
    # Setup GIT
    #

    # Fraber 2025-02-27: Moved to /etc/gitconfig for system wide defaults
    #nsExec::ExecToLog `$INSTDIR\bin\mkdir -p ~`
    #DetailPrint "GIT: mkdir -p ~: Create home directory if needed"

    #nsExec::ExecToLog `$INSTDIR\bin\bash -c "git config --global --replace-all safe.directory '*'"`
    #DetailPrint "GIT: git config --global --replace-all safe.directory '*'"
    
    #nsExec::ExecToLog `$INSTDIR\bin\bash -c "git config --global user.name 'Project Open'"`
    #DetailPrint "GIT: git config --global user.name 'Project Open'"
    
    #nsExec::ExecToLog `$INSTDIR\bin\bash -c "git config --global user.email 'infoproject-open.com'"`
    #DetailPrint "GIT: git config --global user.email 'info@project-open.com'"
    
    #nsExec::ExecToLog `$INSTDIR\bin\bash -c "git config --global credential.helper 'cache --timeout=7200'"`
    #DetailPrint "GIT: git config --global credential.helper 'cache --timeout=7200'"
        
    #nsExec::ExecToLog `$INSTDIR\bin\bash -c "git config --global core.fileMode false"`
    #DetailPrint "GIT: git config --global system core.fileMode false"

SectionEnd



# --------------------------------------------------------
# Uninstaller sections
# --------------------------------------------------------

Section /o -un.Main UNSEC0000

    # --------------------------------------------------------
    # Remove services
    #
    DetailPrint "About to stop ]po[ Service Monitor service"
    nsExec::ExecToLog 'sc stop po-service-monitor'
    nsExec::ExecToLog 'sc delete po-service-monitor'
    pop $R0
    DetailPrint "Deleted ]po[ Service Monitor service: result=$R0"

    DetailPrint "About to stop ]po[ NaviServer Projop"
    nsExec::ExecToLog 'sc stop po-projop'
    nsExec::ExecToLog 'sc delete po-projop'
    pop $R0
    DetailPrint "Deleted ]po[ NaviServer Projop: result=$R0"

    DetailPrint "About to stop ]po[ postgresql-16.6 service"
    nsExec::ExecToLog 'sc stop postgresql-9.2'
    nsExec::ExecToLog 'sc delete postgresql-9.2'
    nsExec::ExecToLog 'sc stop postgresql-16.6'
    nsExec::ExecToLog 'sc delete postgresql-16.6'
    pop $R0
    DetailPrint "Deleted ]po[ postgresql-16.6 service: result=$R0"


    # ----------------------------------------------------
    # Uninstall the MS VC++ 2010 Redistributable
    #
    nsExec::ExecToLog "$INSTDIR\installer\vcredist_x64.exe /passive /uninstall"


    # ----------------------------------------------------
    # Uninstall registry & program group
    #
    DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" \
                        "$SMPROGRAMS\$StartMenuGroup\Start ]project-open[.lnk"
    DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\layers" \
                        "$SMPROGRAMS\$StartMenuGroup\Stop ]project-open[.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Stop ]project-open[.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Start ]project-open[.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Open ]project-open[.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\]po[ Service Monitor.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\CygWin Shell.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\pgAdminIII.lnk"

    # Get rid of autostart link
    Delete /REBOOTOK "$SMSTARTUP\]po[ Service Monitor.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\Startup\]po[ Service Monitor.lnk"

!ifndef NOFILE
    RmDir /r /REBOOTOK $INSTDIR\bin
    RmDir /r /REBOOTOK $INSTDIR\dev
    RmDir /r /REBOOTOK $INSTDIR\etc
    RmDir /r /REBOOTOK $INSTDIR\jre
    RmDir /r /REBOOTOK $INSTDIR\home
    RmDir /r /REBOOTOK $INSTDIR\include
    RmDir /r /REBOOTOK $INSTDIR\installer
    RmDir /r /REBOOTOK $INSTDIR\jre
    RmDir /r /REBOOTOK $INSTDIR\lib
    RmDir /r /REBOOTOK $INSTDIR\modules
    RmDir /r /REBOOTOK $INSTDIR\pgsql
    RmDir /r /REBOOTOK $INSTDIR\servers
    Delete   /REBOOTOK $INSTDIR\log\*
    RmDir    /REBOOTOK $INSTDIR\log
    RmDir /r /REBOOTOK $INSTDIR\usr
    RmDir /r /REBOOTOK $INSTDIR\var
    RmDir /r /REBOOTOK $INSTDIR\tcl
    RmDir /r /REBOOTOK $INSTDIR\tmp
    Delete   /REBOOTOK $INSTDIR\Cygwin.bat
    Delete   /REBOOTOK $INSTDIR\Cygwin.ico
    Delete   /REBOOTOK $INSTDIR\Cygwin-Terminal.ico
    Delete   /REBOOTOK $INSTDIR\setup.exe
!endif

    DeleteRegValue HKLM "${REGKEY}\Components" Main

    # --------------------------------------------------------
    # Remove PATH and other environment variables
    #
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\pgsql\bin"
    ${un.EnvVarUpdate} $0 "AOLDIR" "R" "HKLM" "$INSTDIR"
    ${un.EnvVarUpdate} $0 "CYGWIN" "R" "HKLM" "nodosfilewarning"

    Push "AOLDIR"
    Call un.DeleteEnvStr
    
    Push AOLDIR
    Call un.DeleteEnvStr

    
    # completely delete envvars
    Push "AOLDIR"
    Call un.DeleteEnvStr
    Push "CYGWIN"
    Call un.DeleteEnvStr
SectionEnd


# --------------------------------------------------------
# Post-Uninstall Actions
# --------------------------------------------------------

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    # Cygwin Registry Key removal
    DeleteRegKey HKLM "SOFTWARE\Cygnus Solutions\Cygwin"
    DeleteRegKey HKLM "SOFTWARE\Cygwin"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd


# --------------------------------------------------------
# Installer functions
# --------------------------------------------------------

Function .onInit
    !insertmacro MUI_LANGDLL_DISPLAY
    InitPluginsDir
    StrCpy $StartMenuGroup "]project-open["
    !insertmacro MULTIUSER_INIT
    StrCpy $instv "${TARGET}"
FunctionEnd


# Uninstaller functions
Function un.onInit
    StrCpy $StartMenuGroup "]project-open["
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
    !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Function LaunchProjectOpen
    # Open up a browser pointing to the local ]po[ instance
    ExecShell "open" "http://localhost:8000/"
FunctionEnd



# --------------------------------------------------------
# Upload file to SourceForge after compilation
# --------------------------------------------------------

#!finalize '${TARGET}\bin\rm -f ${OUTPATH}\${OUTBASE}.zip'
#!finalize '${TARGET}\bin\7z a "${OUTPATH}\${OUTBASE}.zip" %1 C:\project-open\servers\projop\packages\intranet-core\LICENSE.Windows C:\project-open\servers\projop\packages\intranet-core\README.ProjectOpen'
#!finalize '${TARGET}\bin\rm -f ${OUTPATH}\${OUTBASE}.exe'
