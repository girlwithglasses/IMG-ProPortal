package ProPortal::Controller::Ecosystem;

use IMG::Util::Base 'MooRole';

#extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/ecosystem.tt',
			tmpl_includes => {
    			tt_scripts => qw( ecosystem ),
	    	}
		};
	}
);

# has '+tmpl_includes' => (
# 	is => 'ro',
# 	default => sub {
# 		return {
# 			tt_scripts => qw( ecosystem ),
# 		};
# 	},
# );

use JSON qw( encode_json decode_json );

=head3 render

Ecosystem query

=cut

sub render {
	my $self = shift;

    my $res = $self->get_data();
    if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
    }

    my $class_type_h;
    my @class_types = qw( all ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem taxon );
    my $n = 0;
    for ( @class_types ) {
        ( $class_type_h->{ $n++ } = $_ ) =~ s/_/ /g;
    }

    pop @class_types;
    shift @class_types;
    my $data;

    for my $r ( @$res ) {
        push @{$data->{ $r->{ecosystem} }
            { $r->{ecosystem_category} }
            { $r->{ecosystem_type} }
            { $r->{ecosystem_subtype} }
            { $r->{specific_ecosystem} } }, {
                name => $r->{taxon_display_name},
                data => $r
            };
    }

    my $tree = { name => 'all', path => 'all', children => $self->recurse( $data, 'all' ) };

	return $self->add_defaults_and_render({
        class_types => \@class_types,
        array => $res,
        js => {
            class_type_h => $class_type_h,
            tree => $tree,
        }
    });

}

sub recurse {
    my $self = shift;
    my $ds = shift;
    my $path = shift // '';
    if ( 'ARRAY' eq ref $ds ) {
        return [ sort { $a->{name} cmp $b->{name} } @$ds ];
    }
    elsif ( 'HASH' eq ref $ds ) {
        my $struct;
        my $p;
        for ( sort keys %$ds ) {
            ( $p = $_ ) =~ s/\W/_/g;
            push @$struct, {
                name => $_,
                path => $path . "__$p",
                children => $self->recurse( $ds->{$_}, $path . "__$p"  )
            };
        }
        return $struct;
    }
    die 'encountered unexpected input: ' . $ds;
}

sub get_data {
    my $self = shift;
	return $self->run_query({
		query => 'ecosystem',
		filters => $self->filters,
	});
}

1;
