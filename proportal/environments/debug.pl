{
# configuration file for development environment

# the log level for this environment
# core is the lowest, it shows Dancer2's core log messages as well as yours
# (debug, info, warning and error)
#	log => "debug",

# If set to true, Dancer2 will display full stack traces when a warning or a die occurs. (Internally sets Carp::Verbose). Default to false.
	traces => 1,

# should Dancer2 show a stacktrace when an error is caught?
# if set to yes, public/500.html will be ignored and either
# views/500.tt, 'error_template' template, or a default error template will be used.
	show_errors => 1,

# turn on debug setting to dump data to html pages
	debug => 1,


}



