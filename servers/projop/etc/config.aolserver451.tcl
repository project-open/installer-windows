###################################################################### 
#
# Configuration for the "projop" server.
#
###################################################################### 

# ns_log Notice "nsd.tcl: starting to read config file..."

#---------------------------------------------------------------------
# Change to 80 and 443 for production use
set httpport			8000
set httpsport			8443 

# Turn of debugging ("false") for production use
set debug			true

# Start to listen on all network interfaces
set hostname			localhost
set address			0.0.0.0

# Server name and description
set server			"projop" 
set server_description		"\]project-open\[ V4.0"

# Directories
if {![info exists env(AOLDIR)]} {
	# Deal with absence of AOLDIR during the installation
	set env(AOLDIR) [lindex $::argv 0]
}
set winaoldir			[string tolower $env(AOLDIR)]
set winaoldir			"e:/project-open"
set unixaoldir			[string map {\\ /} ${winaoldir}]
set rootdir_pieces		[split $unixaoldir "/"]
set rootdir			[join [lrange $rootdir_pieces 0 1] "/"]

set serverroot			"${rootdir}/servers/${server}"
set aoldir			${rootdir}/usr/local/aolserver451
set bindir			${rootdir}/usr/local/aolserver451/bin
set libdir			${rootdir}/usr/local/aolserver451/lib

# ns_log Notice "nsd.tcl: rootdir=$rootdir"
# ns_log Notice "nsd.tcl: serverroot=$serverroot"
# ns_log Notice "nsd.tcl: aoldir=$aoldir"
# ns_log Notice "nsd.tcl: bindir=$bindir"
# ns_log Notice "nsd.tcl: libdir=$libdir"


# Limit upload of files in terms of size and time
set max_file_upload_mb		20
set max_file_upload_min		5


#---------------------------------------------------------------------
# Which database do you want? postgres or oracle
set database			postgres
set db_name			$server
set db_host			localhost
set db_port			""
set db_user			"projop"
set db_password			""


###################################################################### 
#
# End of instance-specific settings
# Nothing below this point need be changed in a default install.
#
###################################################################### 


#---------------------------------------------------------------------
#
# AOLserver's directories. Autoconfigurable. 
#
#---------------------------------------------------------------------
# Where are your pages going to live ?
set pageroot			${serverroot}/www 
set directoryfile		index.tcl,index.adp,index.html,index.htm


#---------------------------------------------------------------------
# Global server parameters 
#---------------------------------------------------------------------
ns_section ns/parameters
	ns_param	serverlog		${serverroot}/log/error.log 
	ns_param	home			$aoldir 
	# maxkeepalive is ignored in aolserver4.x
	ns_param	maxkeepalive		0
	ns_param	logroll			on
	ns_param	maxbackup		5
	ns_param	debug			$debug
	ns_param	mailhost		localhost 

	# setting to Unicode by default
	# see http://dqd.com/~mayoff/encoding-doc.html
	ns_param	HackContentType		1	
	ns_param	DefaultCharset		utf-8
	ns_param	HttpOpenCharset		utf-8
	ns_param	OutputCharset		utf-8
	ns_param	URLCharset		utf-8

#---------------------------------------------------------------------
# Thread library (nsthread) parameters 
#---------------------------------------------------------------------
ns_section ns/threads 
	ns_param	mutexmeter		true		;# measure lock contention 
	# The per-thread stack size must be a multiple of 8k for AOLServer to run under MacOS X
	ns_param	stacksize		[expr {128 * 8192}]

# 
# MIME types. 
# 
ns_section ns/mimetypes
	#  Note: AOLserver already has an exhaustive list of MIME types:
	#  see: /usr/local/src/aolserver-4.{version}/aolserver/nsd/mimetypes.c
	#  but in case something is missing you can add it here. 
	ns_param	Default			*/*
	ns_param	NoExtension		*/*
	ns_param	.pcd			image/x-photo-cd
	ns_param	.prc			application/x-pilot
	ns_param	.xls			application/vnd.ms-excel
	ns_param	.doc			application/vnd.ms-word


#---------------------------------------------------------------------
# 
# Server-level configuration 
# 
#  There is only one server in AOLserver, but this is helpful when multiple
#  servers share the same configuration file.  This file assumes that only
#  one server is in use so it is set at the top in the "server" Tcl variable
#  Other host-specific values are set up above as Tcl variables, too.
# 
#---------------------------------------------------------------------
ns_section ns/servers 
	ns_param	$server			$server_description 

# 
# Server parameters 
# 
ns_section ns/server/${server} 
	ns_param	directoryfile		$directoryfile
	ns_param	pageroot		$pageroot
	ns_param	maxconnections		100		;# Max connections to put on queue
	ns_param	maxdropped		0
	ns_param	maxthreads		10
	ns_param	minthreads		5
	ns_param	threadtimeout		120		;# Idle threads die at this rate
	ns_param	globalstats		false		;# Enable built-in statistics 
	ns_param	urlstats		false		;# Enable URL statistics 
	ns_param	maxurlstats		1000		;# Max number of URL's to do stats on
#	ns_param	directoryadp		$pageroot/dirlist.adp ;# Choose one or the other
#	ns_param	directoryproc		_ns_dirlist	;#  ...but not both!
#	ns_param	directorylisting	fancy		;# Can be simple or fancy

	#
	# Special HTTP pages
	#
	ns_param	NotFoundResponse	"/global/file-not-found.html"
	ns_param	ServerBusyResponse	"/global/busy.html"
	ns_param	ServerInternalErrorResponse "/global/error.html"

#---------------------------------------------------------------------
# 
# ADP (AOLserver Dynamic Page) configuration 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/adp 
	ns_param	map			/*.adp		;# Extensions to parse as ADP's 
#	ns_param	map			"/*.html"	;# Any extension can be mapped 
	ns_param	enableexpire		false		;# Set "Expires: now" on all ADP's 
	ns_param	enabledebug		$debug		;# Allow Tclpro debugging with "?debug"
	ns_param	defaultparser		fancy

ns_section ns/server/${server}/adp/parsers
	ns_param	fancy			".adp"

ns_section ns/server/${server}/redirects
	ns_param	404			"global/file-not-found.html"
	ns_param	403			"global/forbidden.html"

# 
# Tcl Configuration 
# 
ns_section ns/server/${server}/tcl
	ns_param	library			${serverroot}/tcl
	ns_param	autoclose		on 
	ns_param	debug			$debug
 
#---------------------------------------------------------------------
#
# Rollout email support
#
# These procs help manage differing email behavior on 
# dev/staging/production.
#
# EmailDeliveryMode can be:
#	default:	Email messages are sent in the usual manner.
#	log:		Email messages are written to the server's error log.
#	redirect:	Email messages are redirected to the addresses specified 
#			by the EmailRedirectTo parameter.  If this list is absent 
#			or empty, email messages are written to the server's error log.
#	filter:		Email messages are sent to in the usual manner if the 
#			recipient appears in the EmailAllow parameter, otherwise they 
#			are logged.
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/acs/acs-rollout-support

	ns_param	EmailDeliveryMode	default
#	ns_param	EmailRedirectTo		somenerd@yourdomain.test, othernerd@yourdomain.test
#	ns_param	EmailAllow		somenerd@yourdomain.test,othernerd@yourdomain.test


#---------------------------------------------------------------------
#
# WebDAV Support (optional, requires oacs-dav package to be installed
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/tdav
	ns_param	propdir			${serverroot}/data/dav/properties
	ns_param	lockdir 		${serverroot}/data/dav/locks
	ns_param	defaultlocktimeout	"300"

ns_section ns/server/${server}/tdav/shares
	ns_param	share1			"OpenACS"
#	ns_param	share2			"Share 2 description"

ns_section ns/server/${server}/tdav/share/share1
	ns_param	uri			"/dav/*"
	# all WebDAV options
	ns_param options "OPTIONS COPY GET PUT MOVE DELETE HEAD MKCOL POST PROPFIND PROPPATCH LOCK UNLOCK"

#ns_section ns/server/${server}/tdav/share/share2
#	ns_param uri "/share2/path/*"
# read-only WebDAV options
#	ns_param options "OPTIONS COPY GET HEAD MKCOL POST PROPFIND PROPPATCH"


#---------------------------------------------------------------------
# 
# Socket driver module (HTTP)  -- nssock 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nssock
	ns_param	timeout			120
	ns_param	address			$address
	ns_param	hostname		$hostname
	ns_param	port			$httpport
# setting maxinput higher than practical may leave the server vulnerable to resource DoS attacks
# see http://www.panoptic.com/wiki/aolserver/166
	ns_param	maxinput		[expr {$max_file_upload_mb * 1024 * 1024}] ;# Maximum File Size for uploads in bytes
	ns_param	maxpost			[expr {$max_file_upload_mb * 1024 * 1024}] ;# Maximum File Size for uploads in bytes
	ns_param	recvwait		[expr {$max_file_upload_min * 60}] ;# Maximum request time in minutes

# maxsock will limit the number of simultanously returned pages,
# regardless of what maxthreads is saying
	ns_param	maxsock			100	;# 100 = default

# On Windows you need to set this parameter to define the number of
# connections as well (it seems).
	ns_param	backlog			5	;# if < 1 == 5 

# Optional params with defaults:
	ns_param	bufsize			16000
	ns_param	rcvbuf			0
	ns_param	sndbuf			0
	ns_param	socktimeout		30 ;# if < 1 == 30
	ns_param	sendwait		30 ;# if < 1 == socktimeout
	ns_param	recvwait		30 ;# if < 1 == socktimeout
	ns_param	closewait		2  ;# if < 0 == 2
	ns_param	keepwait		30 ;# if < 0 == 30
	ns_param	readtimeoutlogging	false
	ns_param	serverrejectlogging	false
	ns_param	sockerrorlogging	false
	ns_param	sockshuterrorlogging	false

#---------------------------------------------------------------------
# 
# Access log -- nslog 
# 
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nslog 
	ns_param	debug			false
	ns_param	dev			false
	ns_param	enablehostnamelookup	false
	ns_param	file			${serverroot}/log/${server}.log
	ns_param	logcombined		true
	ns_param	extendedheaders		COOKIE
#	ns_param	logrefer		false
#	ns_param	loguseragent		false
	ns_param	logreqtime		true
	ns_param	maxbackup		1000
	ns_param	rollday			*
	ns_param	rollfmt			%Y-%m-%d-%H:%M
	ns_param	rollhour		0
	ns_param	rollonsignal		true
	ns_param	rolllog			true

#---------------------------------------------------------------------
#
# nsjava - aolserver module that embeds a java virtual machine.  Needed to 
#	support webmail.  See http://nsjava.sourceforge.net for further 
#	details. This may need to be updated for OpenACS4 webmail
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nsjava
	ns_param	enablejava		off		;# Set to on to enable nsjava.
	ns_param	verbosejvm		off		;# Same as command line -debug.
	ns_param	loglevel		Notice
	ns_param	destroyjvm		off		;# Destroy jvm on shutdown.
	ns_param	disablejitcompiler	off  
	ns_param	classpath		/usr/local/jdk/jdk118_v1/lib/classes.zip:${bindir}/nsjava.jar:${pageroot}/webmail/java/activation.jar:${pageroot}/webmail/java/mail.jar:${pageroot}/webmail/java 

#---------------------------------------------------------------------
# 
# CGI interface -- nscgi, if you have legacy stuff. Tcl or ADP files inside 
# AOLserver are vastly superior to CGIs. I haven't tested these params but they
# should be right.
# 
#---------------------------------------------------------------------
#ns_section "ns/server/${server}/module/nscgi" 
#	ns_param	map			"GET  /cgi-bin ${serverroot}/cgi-bin"
#	ns_param	map			"POST /cgi-bin ${serverroot}/cgi-bin" 
#	ns_param	Interps			CGIinterps

#ns_section "ns/interps/CGIinterps" 
#	ns_param .pl "/usr/bin/perl"


#---------------------------------------------------------------------
#
# PAM authentication
#
#---------------------------------------------------------------------
ns_section ns/server/${server}/module/nspam
	ns_param	PamDomain		"pam_domain"


#---------------------------------------------------------------------
#
# OpenSSL
#
#---------------------------------------------------------------------

ns_section "ns/server/${server}/module/nsopenssl"

# This is used by acs-tcl/tcl/security-procs.tcl to get the https port.
ns_param		ServerPort		$httpsport

# setting maxinput higher than practical may leave the server vulnerable to resource DoS attacks
# see http://www.panoptic.com/wiki/aolserver/166
# must set maxinput for nsopenssl as well as nssock
ns_param	    	maxinput		[expr {$max_file_upload_mb * 1024 * 1024}] ;# Maximum File Size for uploads in bytes

ns_section "ns/server/${server}/module/nsopenssl/sslcontexts"
	ns_param	users			"SSL context used for regular user access"
#	ns_param	admins			"SSL context used for administrator access"
	ns_param	client			"SSL context used for outgoing script socket connections"

ns_section "ns/server/${server}/module/nsopenssl/defaults"
	ns_param	server			users
	ns_param	client			client

ns_section "ns/server/${server}/module/nsopenssl/sslcontext/users"
	ns_param	Role			server
	ns_param	ModuleDir		${serverroot}/etc/certs
	ns_param	CertFile		certfile.pem 
	ns_param	KeyFile			keyfile.pem
#	ns_param	CADir			ca-client/dir
#	ns_param	CAFile			ca-client/ca-client.crt
# for Protocols		"ALL" = "SSLv2, SSLv3, TLSv1"
	ns_param	Protocols		"SSLv3, TLSv1" 
	ns_param	CipherSuite		"ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP" 
	ns_param	PeerVerify		false
	ns_param	PeerVerifyDepth		3
	ns_param	Trace			false

# following from bartt's nsd4.tcl, might help stablize openssl connections? 
# http://www.mail-archive.com/aolserver@listserv.aol.com/msg07092.html
	ns_param	SessionCache		true
	ns_param	SessionCacheID		1
	ns_param	SessionCacheSize	512
	ns_param	SessionCacheTimeout	300


#	ns_section "ns/server/${server}/module/nsopenssl/sslcontext/admins"
#	ns_param	Role			server
#	ns_param	ModuleDir		/path/to/dir
#	ns_param	CertFile		server/server.crt 
#	ns_param	KeyFile			server/server.key 
#	ns_param	CADir			ca-client/dir 
#	ns_param	CAFile			ca-client/ca-client.crt
# for Protocols		"ALL" = "SSLv2, SSLv3, TLSv1"
#	ns_param	Protocols		"All"
#	ns_param	CipherSuite		"ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP" 
#	ns_param	PeerVerify		false
#	ns_param	PeerVerifyDepth		3
#	ns_param	Trace			false

ns_section "ns/server/${server}/module/nsopenssl/sslcontext/client"
	ns_param	Role			client
	ns_param	ModuleDir		${serverroot}/etc/certs
	ns_param	CertFile		certfile.pem
	ns_param	KeyFile			keyfile.pem 
#	ns_param	CADir			${serverroot}/etc/certs
#	ns_param	CAFile			certfile.pem
# for Protocols		"ALL" = "SSLv2, SSLv3, TLSv1"
	ns_param	Protocols		"SSLv2, SSLv3, TLSv1" 
	ns_param	CipherSuite		"ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP" 
	ns_param	PeerVerify		false
	ns_param	PeerVerifyDepth		3
	ns_param	Trace			false

# following from bartt's nsd4.tcl, might help stablize openssl connections? 
# http://www.mail-archive.com/aolserver@listserv.aol.com/msg07092.html
	ns_param	SessionCache		true
	ns_param	SessionCacheID		1
	ns_param	SessionCacheSize	512
	ns_param	SessionCacheTimeout	300

# SSL drivers. Each driver defines a port to listen on and an explitictly named
# SSL context to associate with it. Note that you can now have multiple driver
# connections within a single virtual server, which can be tied to different
# SSL contexts.
ns_section "ns/server/${server}/module/nsopenssl/ssldrivers"
	ns_param	users			"Driver for regular user access"
#	ns_param	admins			"Driver for administrator access"

ns_section "ns/server/${server}/module/nsopenssl/ssldriver/users"
	ns_param	sslcontext		users
#	ns_param	port			$httpsport_users
	ns_param	port			$httpsport
	ns_param	hostname		$hostname
	ns_param	address			$address
# following added per
# http://www.mail-archive.com/aolserver@listserv.aol.com/msg07365.html
# Maximum File Size for uploads:
	ns_param	maxinput		[expr {$max_file_upload_mb * 1024 * 1024}] ;# in bytes
# Maximum request time
	ns_param	recvwait		[expr {$max_file_upload_min * 60}] ;# in minutes

#	ns_section "ns/server/${server}/module/nsopenssl/ssldriver/admins"
#	ns_param	sslcontext		admins
#	ns_param	port			$httpsport_admins
#	ns_param	port			$httpsport
#	ns_param	hostname		$hostname
#	ns_param	address			$address


#---------------------------------------------------------------------
# 
# Database drivers 
#
#---------------------------------------------------------------------


# ns_log Notice "nsd.tcl:Starting with nspostgres.so"

ns_section "ns/db/drivers" 
	ns_param	postgres		${bindir}/nspostgres.so  ;# Load PostgreSQL driver

ns_section "ns/db/driver/postgres"
    ns_param	pgbin				"e:/project-open/pgsql/bin"	    ;# Path for psql binary


 
# Database Pools: This is how AOLserver  ``talks'' to the RDBMS. You need 
# three for OpenACS: main, log, subquery. Make sure to replace ``yourdb'' 
# and ``yourpassword'' with the actual values for your db name and the 
# password for it, if needed.  

ns_section ns/db/pools 
	ns_param	pool1			"Pool 1"
	ns_param	pool2			"Pool 2"
	ns_param	pool3			"Pool 3"

ns_section ns/db/pool/pool1
	ns_param	maxidle			0
	ns_param	maxopen			0
	ns_param	connections		15
	ns_param	verbose			$debug
	ns_param	extendedtableinfo	true
	ns_param	logsqlerrors		$debug
	ns_param	driver			postgres 
	ns_param	datasource		${db_host}:${db_port}:${db_name}
	ns_param	user			$db_user
	ns_param	password		$db_password

ns_section ns/db/pool/pool2
	ns_param	maxidle			0
	ns_param	maxopen			0
	ns_param	connections		5
	ns_param	verbose			$debug
	ns_param	extendedtableinfo	true
	ns_param	logsqlerrors		$debug
	ns_param	driver			postgres 
	ns_param	datasource		${db_host}:${db_port}:${db_name}
	ns_param	user			$db_user
	ns_param	password		$db_password

ns_section ns/db/pool/pool3
	ns_param	maxidle			0
	ns_param	maxopen			0
	ns_param	connections		5
	ns_param	verbose			$debug
	ns_param	extendedtableinfo	true
	ns_param	logsqlerrors		$debug
	ns_param	driver			postgres
	ns_param	datasource		${db_host}:${db_port}:${db_name}
	ns_param	user			$db_user
	ns_param	password		$db_password

ns_section ns/server/${server}/db
	ns_param	pools			pool1,pool2,pool3
	ns_param	defaultpool		pool1


#---------------------------------------------------------------------
# Which modules should be loaded?  Missing modules break the server, so
# don't uncomment modules unless they have been installed.
ns_section ns/server/${server}/modules 
	ns_param	nssock			${bindir}/nssock.so 
	ns_param	nslog			${bindir}/nslog.so 
	ns_param	nssha1			${bindir}/nssha1.so

	#---------------------------------------------------------------------
	# nsopenssl will fail unless the cert files are present as specified
	# later in this file, so it's disabled by default
#	ns_param	nsopenssl	       ${bindir}/nsopenssl.so

	# authorize-gateway package requires dqd_utils
	# ns_param	dqd_utils		dqd_utils[expr {int($tcl_version)}].so

	# Full Text Search
#	ns_param	nsfts			${bindir}/nsfts.so

	# PAM authentication
#	ns_param	nspam			${bindir}/nspam.so

	# LDAP authentication
#	ns_param	nsldap			${bindir}/nsldap.so

	# These modules aren't used in standard OpenACS installs
#	ns_param	nsperm			${bindir}/nsperm.so 
#	ns_param	nscgi			${bindir}/nscgi.so 
#	ns_param	nsjava			${bindir}/libnsjava.so
#	ns_param	nsrewrite		${bindir}/nsrewrite.so 

	# Database
	ns_param	nsdb			${bindir}/nsdb.so

	# nsthread library which should become standard in 5.3
	if {[file exists ${libdir}/thread2.6.5/thread26[info sharedlibextension]]} {
	ns_param	libthread		${libdir}/thread2.6.5/thread26[info sharedlibextension]
	}

# ns_log Notice "nsd.tcl: using threadsafe tcl: [info exists tcl_platform(threaded)]"
# ns_log Notice "nsd.tcl: finished reading config file."

ns_limits set default -maxupload [ns_config ns/server/${server}/module/nssock maxinput]
