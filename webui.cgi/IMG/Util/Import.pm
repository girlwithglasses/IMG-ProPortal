package IMG::Util::Import;

use parent 'Import::Base';

our @IMPORT_MODULES = (
#	'warnings',
   'strict',
	'strictures' => [ 'version', '2' ],
    '>-indirect' => [ 'fatal' ],
    '>-multidimensional',
    '>-bareword::filehandles',
	'feature' => [ qw( :5.16 ) ],
	'Data::Dumper::Concise',
	'Carp',
#	'local::lib'
);

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;

our %IMPORT_BUNDLES = (

	Class =>   [ 'Moo', 'Types::Standard' => [qw( :all )] ],

	MooRole => [ 'Moo::Role', 'Types::Standard' => [qw( :all )] ],

	Test  =>   [
		'File::Temp' => [ qw( tempfile tempdir )],
		'TestUtils' => [ qw( :all ) ],
		'IMG::App::Role::ErrorMessages' => [ 'err' ],
		qw( File::Spec::Functions Test::Most Test::Fatal Test::Script ),
		# in t/lib:
		'ProPortalTestData' => [ ':all' ],
		'MyUserAgent',
		'DataModel::IMG_Test',
	],

	NetTest => [
		'File::Temp' => [ qw( tempfile tempdir )],
		'TestUtils' => [ qw( :all ) ],
		'IMG::App::Role::ErrorMessages' => [ 'err' ],
		qw( File::Spec::Functions Test::Most Test::Fatal Test::Script Plack::Test Plack::Util HTTP::Request::Common HTTP::Cookies ),
		# in t/lib:
		'ProPortalTestData' => [ ':all' ],
		'MyUserAgent',
		'DataModel::IMG_Test',

	],

	psgi => [
		'Dancer2',
		'AppCorePlugin',
		'File::Basename',
		'Plack::Builder',
		'Plack::Middleware::Conditional',
		# speed up Dancer2
		'Class::XSAccessor',
		'URL::Encode::XS',
		'CGI::Deurl::XS',
		'HTTP::Parser::XS',
		'YAML::XS',

#		'JSON::MaybeXS',
#		'Cpanel::JSON::XS',

		'HTTP::XSCookies',
		'Math::Random::ISAAC::XS',
		'Crypt::URandom',
		'Scope::Upper',
		'EV',
	]

);

# $IMPORT_BUNDLES{ TestVerbose } = [ @{$IMPORT_BUNDLES{ Test }}, 'Carp::Always' ];
# $IMPORT_BUNDLES{ NetTestVerbose } = [ @{$IMPORT_BUNDLES{ NetTest }}, 'Carp::Always' ];



sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

	return $self;
}

1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::Import - Basic object instantiation

This module is not intended for direct use; instead, you can use it as a base
for classes to get a free constructor and set of basic modules.

	package MyCoolObject;

	use IMG::Util::Import;

This module always imports the following into your namespace:

=over

=item L<strict>

=item L<warnings>

=item L<feature>

Currently the 5.16 feature bundle

=item L<Data::Dumper>

=item L<Carp>

=back

=head3 new

	my $obj = IMG::Util::Import->new();

@return IMG::Util::Import object

=cut
