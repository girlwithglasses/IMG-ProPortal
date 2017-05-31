package IMG::Util::Import;

use parent 'Import::Base';
use Scalar::Util qw( blessed );

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

$Data::Dumper::Sortkeys = \&filter_me;
$Data::Dumper::Indent = 1;

sub filter_me {
	my ( $hash ) = @_;
	my %avoid = {
		'__schema' => 1,
		'_core' => 1,
		connected_source => 1
	};
	return [ sort grep { ! defined $avoid{$_} } keys %$hash ];

#	return [ sort @filtered ];
#
		# return an array ref containing the hash keys to dump
		# in the order that you want them to be dumped
	return [
	  # Sort the keys of %$foo in reverse numeric order
	#	$hash eq $foo ? (sort {$b <=> $a} keys %$hash) :
	  # Only dump the odd number keys of %$bar
	#	$hash eq $bar ? (grep {$_ % 2} keys %$hash) :
	  # Sort keys in default order for all other hashes
		( sort grep { return $_ if ! $avoid{$_}; return 0; } keys %$hash )
	];
}

our %IMPORT_BUNDLES = (

#	Class =>   [ 'Moo', 'Types::Standard' => [qw( :all )] ],

#	MooRole => [ 'Moo::Role', 'Types::Standard' => [qw( :all )] ],

	LogErr =>  [ 'IMG::Util::Logger', 'IMG::App::Role::ErrorMessages' => [ ':all' ] ],
	ErrLog =>  [ 'IMG::Util::Logger', 'IMG::App::Role::ErrorMessages' => [ ':all' ] ],

	Class =>   [
		'IMG::Util::Logger',
		'Moo',
		'Types::Standard' => [qw( :all )],
		'IMG::App::Role::ErrorMessages' => [ ':all' ]
	],

	MooRole => [
		'IMG::Util::Logger',
		'Moo::Role',
		'Types::Standard' => [qw( :all )],
		'IMG::App::Role::ErrorMessages' => [ ':all' ]
	],

	Test  =>   [
		'IMG::Util::Logger',
		'File::Temp' => [ qw( tempfile tempdir ) ],
		'TestUtils' => [ qw( :all ) ],
		'IMG::App::Role::ErrorMessages' => [ ':all' ],
		qw( File::Spec::Functions Test::Most Test::Fatal Test::Script ),
		# in t/lib:
		'ProPortalTestData' => [ ':all' ],
		'MyUserAgent',
		'DataModel::IMG_Test',
	],

	NetTest => [
		'IMG::Util::Logger',
		'File::Temp' => [ qw( tempfile tempdir ) ],
		'TestUtils' => [ qw( :all ) ],
		'IMG::App::Role::ErrorMessages' => [ ':all' ],
		qw( File::Spec::Functions Test::Most Test::Fatal Test::Script Plack::Test Plack::Util HTTP::Request::Common HTTP::Cookies ),
		# in t/lib:
		'ProPortalTestData' => [ ':all' ],
		'MyUserAgent',
		'DataModel::IMG_Test',

	],

	psgi => [
		'IMG::Util::Logger',
		'IMG::App::Role::ErrorMessages' => [ ':all' ],
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

