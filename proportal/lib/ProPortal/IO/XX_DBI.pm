package ProPortal::IO::DBI;

require 5.010_000;
use strict;
use warnings;
use feature ':5.10';

use Carp;
use Types::Standard qw( Int Str Bool InstanceOf HashRef );
use Data::Dumper;
use Moo;

use Role::Tiny::With;

has 'dbh' => (
	is => 'rw',
	predicate => 1,
	clearer => 1,
);

has 'sth' => (
	is => 'rw',
	predicate => 1,
	clearer => 1,
);

has 'verbose' => (
	is => 'rw',
	isa => Int,
	predicate => 1,
	clearer => 1,
);

has 'config' => (
	is => 'rw',
	isa => HashRef,
	clearer => 1,
);

sub BUILDARGS {
	my $class = shift;
	my $args;
	if ( @_ && 1 < scalar( @_ ) ) {
		$args = { @_ } ;
	}
	else {
		$args = shift;
	}

	if ( ! $args->{dbh} ) {
		croak "Arguments to " . __PACKAGE__ . " must be a hashref with keys 'config' and 'dbh'";
	}

	return {
		dbh => delete $args->{dbh},
		verbose => delete $args->{verbose} // 0,
		config => $args->{config} || $args,
	};
}


=head3 run_query

Run a database query

If there is no database handle set, takes care of doing the login first

@param  hash with keys

@param  query  => the name of the query to be run
	(a.k.a. the name of the method in this package)

@param  input  => extra query param to be filled in using $self->proportal_filters

@param  bind   => [ $arg1, $arg2, $arg3 ] - bind these to the SQL sttmnt

@param  output => how to return the output: e.g. fetchall_arrayref, fetchall_hashref

@return $output - raw output from the query


sub run_query {
	my $self = shift;
	my %args = @_;

	my $query = $args{query}
		# no query specified
		or die __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query specified!';

	if (! $self->has_dbh) {
		$self->db_login;
	}
	# get the sql
	my $sql = $self->$query( $args{input} || undef )
		or die __PACKAGE__ . ' ' . (caller(0))[3]
		. ": no SQL found for ${args{query}}";

	if ($self->verbose) {
		say "SQL: $sql";
	}

#	# run the actual query
#	my $q = ProPortal::WebUtil::execSql( $self->dbh, $sql, $self->verbose );
	# prepare...
	my $sth = $self->dbh->prepare($sql)
		or die __PACKAGE__ . ' ' . (caller(0))[3]
		. ': could not prepare SQL query: '. $self->dbh->errstr;

	$self->sth($sth);

	# execute...
	my $rtn = $self->sth->execute( @{$args{bind} || [] } )
		or die __PACKAGE__ . ' ' . (caller(0))[3]
		. ': could not execute SQL query: ' . $self->sth->errstr;

	# get the column headers
	my $cols = $self->sth->NAME_lc;

	# return the results
	if ($args{output} =~ /^fetchall_aoh/) {
		my $ary = $self->sth->fetchall_arrayref;
		return [ map { my %h; @h{ @$cols } = @$_; %h; } @$ary ];
	}
	if ($args{output} =~ /^fetchall_(hash|array)ref$/ ) {
		my $output = $args{output};
		return $self->sth->$output();
	}
	# otherwise, return the handle
	return $self->sth;
}
=cut

=head3 db_login

Log in to the database and set $self->dbh to the database handle returned

@return $dbh - database handle

sub db_login {
	my $self = shift;

	if (! $self->has_dbh) {
		# run dbLogin
		my $dbh; # = database;

		if (! $dbh) {
			# crap!
			die ( __PACKAGE__ . ' ' . (caller(0))[3]
			. ': could not create a DB handle!' );
		}
		$self->dbh = $dbh;
	}

	return $self->dbh;

}
=cut


=head2 proportal_filters

Get the filters for the ProPortal-specific species

=cut

sub proportal_filters {
#	my $self = shift;

	return {
		'prochlorococcus' => qq{ lower(t.GENUS) LIKE '%prochlorococcus%' AND t.sequencing_gold_id IN (SELECT gold_id FROM gold_sequencing_project\@imgsg_dev WHERE ecosystem_type = 'Marine') },

		'synechococcus' => qq{ lower(t.GENUS) LIKE '%synechococcus%' AND t.sequencing_gold_id IN (select gold_id FROM gold_sequencing_project\@imgsg_dev WHERE ecosystem_type = 'Marine') },

		'cyanophage' => qq{
lower(t.taxon_display_name) LIKE '%cyanophage%' OR lower(t.taxon_display_name) LIKE '%prochlorococcus phage%' OR lower(t.taxon_display_name) LIKE '%synechococcus phage%' },
	};


}

=head3 taxon_oid_display_name

Query from data_type_graph

Taxon query using one of the stored SQL snippets

@param  $args   - the stored sql query to fill in the gap

@return $sql    - SQL query string

=cut

sub taxon_oid_display_name {
	my $self = shift;
	my $args = shift;
	my $return = shift;

	my $e = $self->proportal_filters;

	if ( ! $args || ! $e->{$args} ) {
		# we require the argument!
		return undef;
	}

	return qq{select t.taxon_display_name, t.taxon_oid from taxon t where ( }
	. $e->{$args}
	. qq{ ) and t.obsolete_flag = 'No' and t.is_public = 'Yes' order by t.taxon_display_name, t.taxon_oid };

}

=head3 taxon_marine_metagenome

Marine metagenome taxon query

@return $sql    - SQL query string

=cut

sub taxon_marine_metagenome {

	return "select t.taxon_display_name, t.taxon_oid, t.family "
	. "from taxon t "
	. "where t.genome_type = 'metagenome' "
	. "and t.ir_order = 'Marine' "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. "and (t.combined_sample_flag is null or t.combined_sample_flag = 'No') "
	. "order by t.taxon_display_name, t.taxon_oid";

}

sub depth_graph {

	return 'select t.taxon_display_name, t.taxon_oid, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, t.genus '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. "and p.ecosystem_type = 'Marine' AND p.depth is not null "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes'";

}

sub clade_graph {

	return 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.clade '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. "and (lower(t.genus) like '%prochlorococcus%' or lower(t.genus) like '%synechococcus%') "
	. "and p.ecosystem_type = 'Marine' AND p.clade is not null "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. 'ORDER BY 4, 5, 2';

}

sub tax_count {
	my $self = shift;
	my $args = shift;

	my $sql = 'select count(*) from taxon t '
		. "where t.obsolete_flag = 'No' and t.is_public = 'Yes' ";

	return $sql if ! $args;

	return $self->add_proportal_filters($sql);
}

sub depth_clade {
	my $self = shift;
	my $args = shift;

	my $sql = 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.clade '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. 'and p.depth is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes'";
}

# note: almost identical to depth_clade

sub depth_ecotype {
	my $self = shift;
	my $args = shift;

	my $sql = 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.ecotype '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. 'and p.depth is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes'";

}

sub location {
	my $self = shift;
	my $args = shift;
	my $sql = 'select t.taxon_oid, t.taxon_display_name, '
		. 'p.geo_location, p.latitude, p.longitude, '
		. 'p.altitude, p.depth, t.domain, p.clade '
		. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
		. 'where t.sequencing_gold_id = p.gold_id '
		. "and p.latitude != '' and p.longitude != '' "
		. 'and p.latitude is not null and p.longitude is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. " and t.obsolete_flag = 'No' and t.is_public = 'Yes'";

}

=head3 stats

database stats

=cut

sub stats {
	my $self = shift;
	my $f = $self->proportal_filters;

	return join(" UNION ", map {
		"select '"
		. $_
		. "', t.taxon_oid, t.domain, t.taxon_display_name "
		. 'from taxon t '
		. 'where (' . $f->{$_} . ') '
		. "and t.obsolete_flag = 'No' and t.is_public = 'Yes'";
	 } keys %$f)
	 . " ORDER BY t.taxon_display_name, t.taxon_oid";
}

sub role {
	return qq{select role from contact_img_groups\@imgsg_dev where contact_oid = ? and img_group = ? };
}

sub news {
	my $self = shift;
	my $args = shift;

	return 'select news_id, title, add_date '
	. 'from img_group_news\@imgsg_dev'
	. 'where group_id = ? '
	. $args ? "and is_public = 'Yes'" : ''
	. 'order by 3 desc';
}

=head3

Append a filter string corresponding to the three taxa sets

=cut

sub add_proportal_filters {
	my $self = shift;
	my $sql  = shift;

	return $sql . ' AND ( '
		. join( " OR ", values %{$self->proportal_filters} )
		. ' )';
}


1;
