{
# configuration file for development environment

# the logger engine to use
# console: log messages to STDOUT (your console where you started the
#          application server)
# file:    log message to a file in log/
	logger => "console",

# the log level for this environment
# core is the lowest, it shows Dancer2's core log messages as well as yours
# (debug, info, warning and error)
	log => "core",

# should Dancer2 consider warnings as critical errors?
	warnings => 1,

	traces => 1,

# should Dancer2 show a stacktrace when an error is caught?
# if set to yes, public/500.html will be ignored and either
# views/500.tt, 'error_template' template, or a default error template will be used.
	show_errors => 1,

	debug => 1,

	# print the banner
	startup_info => 1,

	# URL of the ProPortal app
#	pp_app => "http://localhost:5000/",
	pp_app => 'http://img-proportal.dev/',
	base_url => 'http://img-proportal.dev/',

	# home of css, js, images folders. Should end with "/"
	pp_assets => 'http://img-proportal.dev/',

	# main.cgi location
#	main_cgi_url => 'http://localhost:5000/cgi-bin/main.cgi',
	main_cgi_url => 'http://img-proportal.dev/cgi-bin/main.cgi',

	assets => 'http://img-proportal.dev/pristine_assets/',

#	jbrowse_assets => 'http://localhost:5000/jbrowse_assets/',
	jbrowse_assets => 'http://img-proportal.dev/jbrowse_assets/',

	scratch_dir => '/tmp/jbrowse/',
	rsrc_dir => '/Users/gwg/webUI/webui.cgi/t/files/rsrc_dir/',

	session => 'CGISession',

	engines => {
#		logger => {
#			File => {
#				log_dir => "log/",
#				file_name => "proportal.log",
#			},
#		},
		session => {
			CGISession => {
#				name => 'CGISESSID_proportal',
				cookie_name => 'CGISESSID_proportal',
				cookie_duration => '1.5 hours',
#				cookie_domain => 'jgi-psf.org',
				driver_params => {
					Directory => '/tmp',
				},
			},
		},
	},

	schema => {
		img_core => {
			module => 'DataModel::IMG_Core',
#			db => 'imgsqlite',
			db => 'img_core',
		},
		img_gold => {
			module => 'DataModel::IMG_Gold',
#			db => 'imgsqlite',
			db => 'img_gold',
		},
	},

	dbi_module => 'datamodel',

	db => {
		# schema and db connection required
		imgsqlite => {
			driver => 'SQLite',
			database => 'share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		img_gold => { # this is GOLD
			driver => 'Oracle',
#			database => 'imgiprd',
			database => '//gpodb08.nersc:1521/imgiprd',
			user => 'imgsg_dev',
			password => 'Tuesday',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
				ora_drcp => 1,
			},
		},
		img_core => {
			driver => 'Oracle',
			database => '//gpodb11.nersc.gov:1521/gemini1',
#			database => 'gemini1_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
				ora_drcp => 1,
			},
		},
	},
}
