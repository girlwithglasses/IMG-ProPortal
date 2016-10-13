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
	log => 'core',

# should Dancer2 consider warnings as critical errors?
	warnings => 1,

# should Dancer2 show a stacktrace when an error is caught?
# if set to yes, public/500.html will be ignored and either
# views/500.tt, 'error_template' template, or a default error template will be used.
	show_errors => 1,

#	debug => 1,

	traces => 1,

	# print the banner
	startup_info => 1,

	# home of css, js, images folders. Should end with "/"
#	pp_assets => "http://img-proportal.dev/",
	# URL of the ProPortal app
#	pp_app => "http://img-proportal.dev/",

	# main.cgi location
#	main_cgi_url => 'http://img-proportal.dev/cgi-bin/main.cgi',
#	base_url => 'http://img-proportal.dev/',

#	assets => 'http://img-proportal.dev/pristine_assets/',

#	jbrowse_assets => 'http://img-proportal.dev/jbrowse_assets/',

#	scratch_dir =>    '/tmp/jbrowse',
#	web_data_dir =>   '/global/homes/a/aireland/webUI/proportal/t/files/img_web_data',
#	local_data_dir => '/global/homes/a/aireland/webUI/proportal/t/files',

	engines => {
		logger => {
			File => {
				log_dir => "log/",
				file_name => "proportal.log",
			},
		},
	},
#		session => {
# 			Dumper => {
# 				session_dir => '/global/u1/a/aireland/tmp',
# 				cookie_name => 'CGISESSID_proportal',
# 				cookie_domain => 'jgi-psf.org',
# 				cookie_duration => '1.5 hours',
# 			},
# 		},
# 	},

# 	plugins => {
# 		Ajax => {
# 			content_type => 'application/json'
# 		}
# 	},

}
