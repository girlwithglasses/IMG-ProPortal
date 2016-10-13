package IMG::Util::ConfigValidator;

use IMG::Util::Base 'Class';
use IMG::App::Role::ErrorMessages qw( err );

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
		]
	],
);

has 'engines' => (
	is => 'rw',

);

has 'session' => (
	is => 'ro',
);


# if ( $self->config->{sso_enabled} ) {
#     # require
#
# }
#
# 	engines => {
# 		template => {
# 			template_toolkit => {
# 				INCLUDE_PATH => 'views:views/pages:views/layouts:views/inc:public:../../webui.htd/views/pages',
# 				RELATIVE => 1,
# 			}
# 		},
# 	},
#
# 	googlemapsapikey => 'AIzaSyDrPC70YP1ZyZT-YIFXnol96In-3LKbn7w',
#
# 	db => {
# 		version_year => "Version 4.3 January 2014",
# 		build_date => "Build date",
# 	},
#
#
# 	# URL of the ProPortal app
# 	pp_app => "https://img-proportal-dev.jgi-psf.org/",
#
# 	# home of css, js, images folders. Should end with "/"
# 	pp_assets => "https://img-proportal-dev.jgi-psf.org/",
#
# 	jbrowse_assets => 'https://img-proportal-dev.jgi-psf.org/jbrowse_assets/',
#
# 	scratch_dir => '/global/homes/a/aireland/tmp/jbrowse',
# 	web_data_dir => '/global/dna/projectdirs/microbial/img_web_data',
#
# 	# main.cgi location
# 	main_cgi_url => 'https://img-proportal-dev.jgi-psf.org/cgi-bin/main.cgi',
# 	base_url => 'https://img-proportal-dev.jgi-psf.org/pristine_assets',
#
# 	# cookie name: jgi_return, value: url, domain: sso_domain
# #	sso_enabled => 1,
# 	sso_url_prefix => 'https://signon.',
# 	sso_domain => 'jgi-psf.org',
#
# 	sso_api_url => 'https://signon.jgi-psf.org/api/sessions/',
#
#     # copy tmpl_dir from engines->{template}{template_toolkit}{INCLUDE_PATH}
#     # tmpl_args->{INCLUDE_PATH} = $tmpl_dir;
#
#     # URLs
#     main_cgi_url : full path to main.cgi
#     base_url :
#     img_google_site:
#     server:
#

sub make_config {

	my $env_dir = $base . '/environments';
	opendir(my $dh, $env_dir) || die err ({
		err => 'not_readable',
		subject => $env_dir,
		msg => $!
	});
	my @files = map { "$env_dir/$_" } grep { /^[^\.]/ && -f "$env_dir/$_" } readdir($dh);
	closedir $dh;
	push @files, $base . '/config.pl';


	my $cfg = Config::Any->load_files({ files => [ @files ], use_ext => 1, flatten_to_hash => 1 });
	my @keys = keys %$cfg;
	for ( @keys ) {
		if ( m!.+/(\w+)\.\w+$!x ) {
			$cfg->{ $1 } = delete $cfg->{ $_ };
		}
	}

	say 'config: ' . Dumper $cfg;

	return $cfg;

}

1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::ConfigValidator

Munge and validate the format of a configuration hash

=cut

