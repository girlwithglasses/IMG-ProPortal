package IMG::App::Role::Schema;

use IMG::Util::Base 'MooRole';
use IMG::Util::Factory;

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
	my $s = shift || die "No schema specified";
	return $self->schema_h->{$s}{module} if $self->has_schema_h && $self->schema_h->{$s};
	return $self->_init_schema( $s, @_ );
}

sub _build_schema_h {
	my $self = shift;
	if ( $self->has_config && $self->config->{db} && $self->config->{schema} ) {

		# do something
	}
	else {

		return {
			img_core => { module => 'DataModel::IMG_Core', db => 'img_core' },
			img_gold => { module => 'DataModel::IMG_Gold', db => 'img_gold' },
		}
	}
}

sub _init_schema {
	my $self = shift;
	my $schema = shift || die "No schema specified";
	my $options = shift || {};

	# find the appropriate config for the module
	die "No config found" unless $self->has_config;

	if ( ! $self->config->{schema} || ! $self->config->{schema}{$schema} || ! $self->config->{schema}{$schema}{module} || ! $self->config->{schema}{$schema}{db} ) {
		die "DB schema configuration for $schema not found!";
	}

	my $schema_mod = $self->config->{schema}{$schema}{module};
	# set up the module...
	my %module_args = (
		debug => 1,
		dbi_prepare_method => 'prepare_cached',
	);

	if ( ! $options->{no_connection} ) {
		$module_args{dbh} = $self->connection_for_schema( $schema )->dbh;
	}

	# dies if the module cannot be loaded
	my $module = IMG::Util::Factory::create( $schema_mod, %module_args );


	$self->set_schema_h({ %{ $self->schema_h || {} }, $schema => { module => $module, db => sub { return shift->get_connection_for_schema($schema); } } });

	return $module;
}

1;

