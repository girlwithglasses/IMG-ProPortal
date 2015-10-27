package IMG::Util::ConfigValidator;

use IMG::Util::Base 'Class';

requires 'config';

has 'schema' => (
	is => 'ro',
	isa => Map[ Str => Dict[ module => Str, db => Str ]],
);

has 'db' => (
	is => 'ro',
	isa => Map[ Str => Dict[
		database => Str,
		driver => Str,
		[user|username] => Optional[Str],
		password => Optional[Str],
		dbi_options => Optional[HashRef]
		] ],
);

has 'engines' => (


);

has 'session' => (
	is => 'ro',
);


if ( $self->config->{sso_enabled} ) {
    # require

}

	engines => {
		template => {
			template_toolkit => {
				INCLUDE_PATH => 'views:views/pages:views/layouts:views/inc:public:../../webui.htd/views/pages',
				RELATIVE => 1,
			}
		},
	},

	googlemapsapikey => 'AIzaSyDrPC70YP1ZyZT-YIFXnol96In-3LKbn7w',

	db => {
		version_year => "Version 4.3 January 2014",
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

    # copy tmpl_dir from engines->{template}{template_toolkit}{INCLUDE_PATH}
    # tmpl_args->{INCLUDE_PATH} = $tmpl_dir;

    # URLs
    main_cgi_url : full path to main.cgi
    base_url :
    img_google_site:
    server:



1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::ConfigValidator

Validate the format of a configuration hash

=cut

