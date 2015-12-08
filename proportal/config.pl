# This is the main configuration file of your Dancer2 app
# env-related settings should go to environments/$env.yml
# all the settings in this file will be loaded at Dancer's startup.
{
	cfg_file => 'webEnv.pl',

# Your application's name
	appname => "ProPortal",

# when the charset is set to UTF-8 Dancer2 will handle for you
# all the magic of encoding and decoding. You should not care
# about unicode within your app when this setting is set (recommended).
	charset => "UTF-8",

# template engine
	template => "template_toolkit",

# disable server tokens in production environments
	no_server_tokens => 1,

	auto_page => 1,

	engines => {
		template => {
			template_toolkit => {
				INCLUDE_PATH => 'views:views/pages:views/layouts:views/inc:public:../../webui.htd/views/pages',
				RELATIVE => 1,
				RECURSION => 1
			}
		},
	},

	googlemapsapikey => 'AIzaSyDrPC70YP1ZyZT-YIFXnol96In-3LKbn7w',

	db => {
		version_year => "Version alpha January 2014",
		server_name => "Server name",
		build_date => "Build date",
	},

	# URL of the ProPortal app
	pp_app => "https://img-proportal-dev.jgi-psf.org/",

	# home of css, js, images folders. Should end with "/"
	pp_assets => "https://img-proportal-dev.jgi-psf.org/",

	jbrowse_assets => 'https://img-proportal-dev.jgi-psf.org/jbrowse_assets/',

	scratch_dir => '/global/homes/a/aireland/tmp/jbrowse/',
	rsrc_dir => '/global/projectb/sandbox/IMG_web/img_web_data_secondary/',

	# main.cgi location
	main_cgi_url => 'https://img-proportal-dev.jgi-psf.org/cgi-bin/main.cgi',
	base_url => 'https://img-proportal-dev.jgi-psf.org/pristine_assets',

	# cookie name: jgi_return, value: url, domain: sso_domain
#	sso_enabled => 1,
	sso_url_prefix => 'https://signon.',
	sso_domain => 'jgi-psf.org',
	sso_api_url => 'https://signon.jgi-psf.org/api/sessions/',
}

