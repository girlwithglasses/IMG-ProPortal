package IMG::IO::Schema;

use IMG::Util::Base 'MooRole';

requires 'config', 'db_connection_h';

=head2 IMG::IO::Schema

Provides access to IMG database schemas and associated DB handles

usage:

	# e.g.
	$self->schema('img_gold')->table('Contact')
		->select();

=cut

has 'schema' => (




	builder => 1,
);

sub schema {
	my $self = shift;


}

sub _build_schema {
	my $self = shift;
	if ( ... ) {

	}
	else {

		return {
			img_core => 'DataModel::IMG_Core',
			img_gold => 'DataModel::IMG_Gold',
		}
	}
}

=head3 get_db_conn

Get or create a database connection

@param  $h  name of the connection

@return $connection
        dies if a parameter is missing

=cut

sub get_db_conn {
	my $self = shift;
	my $h = shift || die "Specify a connection to return";
	return $self->db_connection_h->{$h} if $self->has_db_connection_h && $self->db_connection_h->{$h};
	return $self->create_db_conn( $h );
}

=head3 get_db_conn

Get an existing database connection

@param  $h  name of the connection

@return $connection
        undef if the connection does not exist
        dies if a parameter was not provided

=cut

sub get_db_conn_no_create {
	my $self = shift;
	my $h = shift || die "Specify a connection to return";
	return undef unless $self->has_db_connection_h;
	return $self->db_connection_h->{$h} || undef;
}

=head3 set_db_conn

Add a connection to the database connection hash

Will overwrite existing connections of the same name

@param   $dbh_name   name for the connection
@param   $dbh        the connection itself

@return  $self
         dies if a parameter is not provided or the name / connection are wrong

=cut

sub set_db_conn {
	my $self = shift;
	my ($dbh_name, $dbh) = (shift, shift);
	die "No name supplied for dbh" if ! $dbh_name;
	die "No database handle supplied" if ! $dbh;

	# this will die if the $dbh or $dbh_name are not of the correct type!
	$self->set_db_connection_h({ %{$self->db_connection_h || {} }, $dbh_name => $dbh });
	return $self;
}

=head3 create_db_conn

Create a database connection; also sets it in db_connection_h

@param  $h   name of the connection to create

@return $conn  db connection on success
        dies if parameters are not specified


=cut

sub create_db_conn {
	my $self = shift;
	my $h = shift || die "Specify a connection to create";

	# find the config and load it
	if (! $self->has_config || ! $self->config->{db} || ! $self->config->{db}{conf} || ! $self->config->{db}{conf}{$h}) {
		die "No db conf found for $h";
	}

=TO DO:

add time out here

=cut

	local $@;
	my $conn = eval {
		IMG::Util::DBIxConnector::get_dbix_connector( $self->config->{db}{conf}{$h} );
	};
	if ( $@ ) {
		if ( $@ =~ /DB connection error/ ) {
			warn $@;
			return undef;
		}
		else {
			# programmer problem
			die $@;
		}
	}
	$self->set_db_conn( $h, $conn );
	return $conn;
=uses of 'around'
	my $orig = shift;
    my $self = shift;
    $orig->($self, reverse @_);

# OR
	my $orig = shift;
	do_something( $orig->(@_) );
=cut

}


=head3 get_connection_for_schema

Given a schema (img_core or img_gold), get a connection to it

=cut

sub get_connection_for_schema {
	my $self = shift;
	my $schema = shift || die 'No schema specified';

	if ( ! $self->has_config || ! $self->config->{db} || ! $self->config->{db}{schema} || ! $self->config->{db}{schema}{$schema} ) {
		die "No configuration data found for $schema";
	}

	# get the connection for this schema
	return $self->get_db_conn( $self->config->{db}{schema}{$schema} );

}


1;

