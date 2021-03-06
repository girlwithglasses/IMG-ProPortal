#!/usr/bin/env perl

# This is the main configuration file of your Dancer2 app
# env-related settings should go to environments/$env.yml
# all the settings in this file will be loaded at Dancer's startup.

# load WebConfig-<TEST SITE NAME>

return {

#	Your application's name
	appname => "ProPortal",

# when the charset is set to UTF-8 Dancer2 will handle for you
# all the magic of encoding and decoding. You should not care
# about unicode within your app when this setting is set (recommended).
	charset => "UTF-8",

# template engine
	template => "template_toolkit",

# log engine
	logger => 'Console',

# disable server tokens in production environments
	no_server_tokens => 1,

# print the banner on Dancer server startup
	startup_info => 1,

# if the requested path does not match any specific route, Dancer2 will check in the views directory for a matching template, and use it to satisfy the request if found
	auto_page => 1,

	log => 'core',

	engines => {
		template => {
			template_toolkit => {
				RELATIVE => 1,
				RECURSION => 1
			}
		},

		logger => {
			File => {
				log_dir => "log/",
				file_name => "proportal.log",
				log_level => 'error'
			},
			Console => {
				log_level => 'debug',
			},
			'log4perl' => {
				config_file => 'environments/log4perl.conf',
			}
		},

		serializer => {
			JSON => {
				convert_blessed => 1
			}
		}
	},
};



