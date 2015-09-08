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

# should Dancer2 show a stacktrace when an error is caught?
# if set to yes, public/500.html will be ignored and either
# views/500.tt, 'error_template' template, or a default error template will be used.
	show_errors => 1,

# print the banner
	startup_info => 1,

	auto_page => 1,

	# home of css, js, images folders. Should end with "/"
	pp_assets => "http://localhost:5000/proportal/",
	# URL of the ProPortal app
	pp_app => "http://localhost:5000/proportal/",

	# main.cgi location
	main_cgi_url => 'http://localhost:5000/cgi-bin/main.cgi',
	base_url => 'http://localhost:5000/',

	engines => {
		logger => {
			File => {
				log_dir => "log/",
				file_name => "dancer.log",
			},
		},
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

	dbi_module => 'datamodel',

	primary_db => 'imgsqlite',
#	primary_db => 'img_core',

	db_conf => {
		imgsqlite => {
			driver => 'SQLite',
			database => 'share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		imgsgdev => {
			driver => 'Oracle',
			database => 'imgiprd',
			user => 'imgsg_dev',
			password => 'Tuesday',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		},
		img_core => {
			driver => 'Oracle',
			database => 'gemini1_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		},
	}
}
