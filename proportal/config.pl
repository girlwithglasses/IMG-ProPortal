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

# session engine
	session => 'CGISession',

# disable server tokens in production environments
	no_server_tokens => 1,

	auto_page => 1,

	engines => {
		session => {
			CGISession => {
				name => 'CGISESSID_proportal',
				cookie_name => 'CGISESSID_proportal',
				cookie_duration => '1.5 hours',
				driver_params => {
					Directory => '/tmp',
				},
			},
		},
		template => {
			template_toolkit => {
#				INCLUDE_PATH => '/global/homes/a/aireland/webUI/proportal/',
				RELATIVE => 1,
				RECURSION => 1
			}
		},
	},
};



