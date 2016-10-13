package ProPortal::Controller::Phylogram;

use IMG::Util::Base 'MooRole';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/phylogram.tt',
			tmpl_includes => {
				tt_scripts => qw( phylogram ),
			},
			filters => {
				subset => 'isolate'
			},
			valid_filters => {
				subset => {
					enum => [ qw( prochlor synech prochlor_phage synech_phage isolate ) ],
				}
			}
		}
	}
);
=head3 render

Phylogram query

=cut

sub render {
	my $self = shift;

	my $res = $self->get_data();

    my $data;
    my $count;
    for ( @$res ) {
        $count++;
        push @{ $data->{ $_->{genome_type} }
        	{ $_->{domain} || 'unclassified' }
        	{ $_->{phylum} || 'unclassified' }
        	{ $_->{ir_class} || 'unclassified' }
        	{ $_->{ir_order} || 'unclassified' }
        	{ $_->{family} || 'unclassified' }
        	{ $_->{genus} || 'unclassified'}
        	{ $_->{clade} || 'unclassified' } }, { name => $_->{taxon_display_name}, data => $_ };
    }

    my $tree;
    if ( 1 == scalar keys %$data ) {
        $tree = { name => ( keys %$data )[0], children => $self->recurse( ( values %$data )[0] ) };
    }
    else {
        $self->choke({ err => 'full_data_disabled' });
    }

	return $self->add_defaults_and_render({
		array => $res,
		js => {
			count => $count,
			tree => $tree,
			class_types => [ qw( genome_type domain phylum class order family genus clade species ) ],
		}
	});

}

sub recurse {
    my $self = shift;
    my $ds = shift;
    if ( 'ARRAY' eq ref $ds ) {
        return [ sort { $a->{name} cmp $b->{name} } @$ds ];
    }
    elsif ( 'HASH' eq ref $ds ) {
        my $struct;
        for ( sort keys %$ds ) {
            push @$struct, { name => $_, children => $self->recurse( $ds->{$_} ) };
        }
        return $struct;
    }
    die 'encountered unexpected input: ' . $ds;
}


sub get_data {
	my $self = shift;
	return $self->run_query({
		query => 'taxon_oid_display_name',
		filters => $self->filters,
	});
}

1;
