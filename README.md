\]project-open\[ on Windows
=========================

This document explains how to build the \]po\[ Windows installer.
For issues please see the GitHub issue tracker:
https://github.com/project-open/installer-windows/issues

To download the Windows installer please see:
https://sourceforge.net/projects/project-open/files/project-open/V5.2/


\]po\[ Version
--------------

The instructions for \]po\[ V5.2.


Get the repo
------------

The GitHub repository for the installer is available at
[https://github.com/project-open/installer-windows](https://github.com/project-open/installer-windows).

The repo contains the installer source code for
[NSIS (Nullsoft Scriptable Install System)](https://nsis.sourceforge.io/Main_Page),
plus some auxilliary files used in the process, but no major binaries that change
between versions such as PostgreSQL or the Java JRE.

Get a copy of the repo (as Zip file at this stage) and copy into c:\\project-open
(rename the folder from "installer-windows" to "project-open").


Install CygWin
--------------

Please execute the following steps as Administrator:

[CygWin](https://www.cygwin.com) is used to emulate a Linux environment on Windows.
You have to install CygWin _right_ into the c:\\project-open folder.
This seems a bit dirty, but it's necessary, because we will need to deliver a single
zip, and both CygWin and the the installer source should be part of this zip.
The CygWin files are excluded by the .gitignore, so they don't form part of this repo.

You can get the CygWin installer from: [https://cygwin.com/setup-x86\_64.exe](https://cygwin.com/setup-x86_64.exe)

Perform a standard 64bit install of CygWin:

*   Root Directory: c:\\project-open
*   Install for: All Users
*   Local Package Directory: c:\\download\\cygwin
*   Choose a Download Site: Something close to you
*   Packages: Only select "Base" for the first install

In a second iteration please select and install the following:

Package selection:

*   Archieve: bzip2, zip
*   Base: everything
*   Database
    *   We will use the binary distro of PostgreSQL for Windows
        instead of the CygWin version for performance reasons.  
        In case of a Cygwin PG installation please select the
	latest postgresql-\*
*   Dev: git
*   Editors: emacs-nox, vim
*   Net: openldap2, openssh, openssl, openssl-perl, rsync, wget
*   Perl: perl, perl-Data-Compare, perl-DBI, perl-IO-Socket-IP,
    perl-IO-Socket-INET6, perl-IO-Socket-SSL, perl-IO-String,
    perl-JSON, perl-LWP-Online, perl-Net-IP, perl-Net-HTTP,
    perl-Net-SSLeay, perl-YAML, perl\_base


Using Git with the Installer
----------------------------

Now that we have CygWin running, we can operate the installer using Git:

*   Double-click on c:\\project-open\\Cygwin.bat.
    You should get a Bash shell running. Try "pwd", "whoami"
*   Move to the root directory: "cd /".
    Using "ls" you should see "bin", "Cygwin.bat", "etc", "installer" etc.
*   Check if Git is installed: "which git", you should return "/usr/bin/git".
*   "git status" may give an error "dubious ownership", because we use the
    CygWin root directory "/" as a repo, just do what Git asks you to.
*   Use "git --global config core.fileMode false" to ignore changes in file
    permssions, we'll override them anyway during the install process.
*   Configure Git user.email and user.name
*   Try "git pull"

Install NSIS (Nullsoft Scriptable Install System)
--------------------------------------------------

We use NSIS V3.0.1. Version 3.0.5 _doesn't_work_.
nsis-3.01-setup.exe is included in c:\\project-open\\installer\\NSIS.
Just use the defaults by NSIS.

You need to install the following plug-ins, which are included in
c:\\project-open\\installer:

*   Registry:  
    You need to copy "registry.dll" from the Zip file c:\\project-open\\installer\\NSIS\\NSIS-Plugin-Registry.zip -> Desktop/Plugin/registry.dll into C:\\ProgramFiles (x86)\\NSIS\\Plugins\\x86-ansi.  
    Watch out that the older plugins may install themselves in C:\\ProgramFiles (x86)\\NSIS\\Plugins. This is wrong since NSIS 3.0 apparently.  
    Otherwise you will get an error
    
    Plugin not found, cannot call registry::\_KeyExists
    
*   UserMgr: You need to manually copy the UserMgr.dll into the x86-ansi folder like above.
*   ExecCmd: Like UsrMgr above
*   Textreplace: Like above


Install PostgreSQL
------------------

There is a "binary distribution" of PG available for win64 as a ZIP.
We currently use:

*   postgresql-16.6-3-windows-x64.exe

Install into some temporary folder:

*   Installation Directory: c:\\postgres\\16
*   Select Components: PostgreSQL Server, Command Line Tools (no pgAdmin4 nor StackBuilder)
*   Data Directory: c:\\postgres\\16\\data
*   Password: your\_secret
*   Port: 5432
*   Locale: C (yes, just this single letter...)

We assume that PostgreSQL will only be available locally on the
server computer, with port 5432 closed for the outside.
In this case we don't care too much about the password,
as access to this server will automatically grant access
to everything else and the possibility to reset the PostgreSQL password.

### Move PostgreSQL into the c:\\project-open folder

Now:

*   Stop the postgresql-x64-16 service in the "Services" Windows application
*   Disable the postgresql-x64-16 service. The \]po\[ installer will create a replacement.
*   Move c:\\postgres\\16 to c:\\project-open\\pgsql, so that you can see c:\\project-open\\pgsql\\bin and c:\\project-open\\pgsql\\data etc. 


Obsolete steps from the past
-----------------------------

These steps are obsolete at the moment, they are included
in case we'll get problems with PG in the future.

    net user postgres "Qwer.1234" /add /fullname:"PostgreSQL"
    # ToDo: UF\_PASSWD\_NOTREQD, UF\_DONT\_EXPIRE\_PASSWD, SeBatchLogonRight, SeServiceLogonRight
    chown -R postgres "/pgsql"
    chmod -R go=u "/pgsql"
    chgrp" -R Users "/pgsql"
    sc create postgresql-16.6 \\
        binpath= "$INSTDIR\\pgsql\\bin\\pg\_ctl.exe runservice -N \\
        postgresql-16.6 -D $INSTDIR/pgsql/data -w" \\
        DisplayName= "\]po\[ PostgreSQL 16.6" start= "delayed-auto" \\
        type= own obj= ".\\postgres" password= "Qwer.1234"
    sc start postgresql-9.2

You can manually run PostgreSQL with the following command (from within a CygWin shell):

/pgsql/bin/pg\_ctl.exe -D "C:\\project-open\\pgsql\\data" start

Some error messages that you might encounter then and how to fix them:

*   Error while loading shared libraries: MSVCR100.dll: cannot open shared object file: No such file or directory:  
    This means that you have to install the 2010 vcredist\_x64.exe distributable. This file is included in the \]po\[ installer as vcredist\_2010\_x64.exe.
*   PANIC:  could not open control file "global/pg\_control": Permission denied:  
    You forgot to execute the chown and chmod commands below.

Finally initialize the database and load a database backup from the \]po\[ product master:

initdb -D "c:/project-open/pgsql/data" --encoding=utf8 --locale=en\_US
chown -R postgres:Users /pgsql
chmod -R go=u /pgsql
psql -f pgback.project-open-v50.projop.20170223.0529.sql projop > import.log 2>&1 &
psql -c "select count(\*) from persons" projop


Install the product code in /packages
-------------------------------------

In the CygWin shell perform:

```bash
cd /servers/projop/
git clone https://github.com/project-open/packages.git
cd packages
git submodule update --recursive --init
```


Install Java JRI
----------------

Java is used to run the "Service Panel" to start/stop/show
the status of the \]po\[ server. We currently use:

*   jre-8u121-windows-x64.tar.gz

Just install into c:\\project-open\\jre\\


NaviServer
----------

This installer starts off with the OpenACS installer from
Maurizio Martignani from SpazioIT.

The files tcl8.5.19.zip and naviserver499.zip are included
in c:\\project-open\\installer\\. Just unzip into /usr/local/:

<pre>
/usr/local/tcl8.5.18       Official TCL source distribution
/usr/local/ns/bin
    nscgi.dll
    nscp.dll
    nsd.dll
    nsdb.dll
    nsdbpg.dll
    nslog.dll
    nsoracle.dll
    nsperm.dll
    nssock.dll
    nsssl.dll
    nsthread.dll
/usr/local/ns/lib
    nsf2.0.0                  XoTcl libraries
    tcllib1.18                TCLLib
    nfs2.0.0                  XoTcl libraries
    tdom0.8.3                 XML parser libraries
    Thread
    thread2.8.0
    threads
    libxotcl1.6.7.dll         XoTcl DLL
/usr/local/ns/tcl             TCL Library
</pre>

Windows Server 2012 R2
======================

There is a known issue with Windows Server 2012 R2 causing an installation
failure of the Visual Studio 2015 vcredist\_x64.exe.
Please make sure Microsoft updates KB2919442 and KB2919355 are installed
(in this order), before starting with the installation of \]project-open\[.

