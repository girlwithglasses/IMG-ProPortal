package IMG::App::Role::Schema;

use IMG::Util::Import 'MooRole';
use IMG::Util::Factory;

with 'IMG::App::Role::ErrorMessages';

requires 'config', 'db_connection_h';

=head1 IMG::Schema

=head2 Summary

Provides access to IMG database schemas, data models, and associated DB handles

usage:

	# e.g.

	my $user = $self->schema('img_core')->table('Contact')
		->select(
			-columns  => [ qw( username contact_oid ) ],
			-where    => {
				username => 'billy_the_kid'
			}
		);
	# equivalent to
	#	my $user = DataModel::IMG_Core->table('Contact')...

configuration format:

	db => {
		# hashref of database connection details
		# see IMG::IO::DbConnection
		my_database => { ... },
		my_other_db => { ... },
	},
	schema => {
		img_core => {
			db => 'my_database',   # hash key for the DB connection in conf
			module => 'DataModel::IMG_Core',   # module with schema details
		}
	}

=cut


has 'schema_h' => (
	is => 'rw',
#	isa => Map[ Str, Dict[ module => Object, db => [Object|CodeRef] ] ],
	isa => Map[ Str, HashRef ],
	lazy => 1,
	predicate => 1,
#	builder => 1,
	writer => 'set_schema_h',
);

=head3 schema

Retrieve a schema for use. The schema will be initialised and a connection created
if they do not already exist.

@param  $s  the schema ID (e.g. 'img_core')

@return $schema_object if successful
        dies on failure

=cut

sub schema {
	my $self = shift;
	my $s = shift || $self->choke({ err => 'missing', subject => 'schema' });
	if ( $self->has_schema_h && $self->schema_h->{$s} ) {
		return $self->schema_h->{$s}{module};
	}
	return $self->_init_schema( $s, @_ );
}


=head3 _init_schema

Initialise a database schema

@param $schema   -- schema name

@param $options  -- hashref


=cut

sub _init_schema {
	my $self = shift;
	my $schema = shift || $self->choke({ err => 'missing', subject => 'schema' });
	my $options = shift || {};

	if ( ! $self->config->{schema} ) {
		$self->choke({ err => 'cfg_missing', subject => 'schema' });
	}

	# find the appropriate config for the module
	if ( ! $self->config->{schema}{$schema}
		|| ! $self->config->{schema}{$schema}{module}
		|| ! $self->config->{schema}{$schema}{db} ) {
			$self->choke({
				err => 'invalid',
				subject => $schema,
				type => 'schema'
			});
	}

	my $schema_mod = $self->config->{schema}{$schema}{module};

=cut

# $schema->debug(1);             # will warn for each SQL statement
# $schema->debug($debug_object); # will call $debug_object->debug($sql)

=cut

	# set up the module...
	my %module_args = (
		debug => IMG::App::Role::Logger::get_logger(),
		dbi_prepare_method => 'prepare_cached',
	);

	if ( ! exists $self->config->{show_sql_verbosity_level} || ! $self->config->{show_sql_verbosity_level} ) {
		delete $module_args{debug};
	}

	if ( ! $options->{no_connection} ) {
		$module_args{dbh} = $self->connection_for_schema( $schema )->dbh;
	}

	# dies if the module cannot be loaded
	my $module = IMG::Util::Factory::create( $schema_mod, %module_args );

	$self->set_schema_h({ %{ $self->schema_h || {} }, $schema => { module => $module, db => sub { return shift->get_connection_for_schema($schema); } } });

	return $module;
}

1;

