package ProPortal::Controller::Tools::Krona;

use IMG::Util::Base 'MooRole';

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Base',
			tmpl => 'pages/tools/krona.tt',
			tmpl_includes => {
#				tt_scripts => qw( data_type )
			}
		};
	}
);

=head3 krona page

Requires krona blurb and taxon cart contents

=cut

sub render {
	my $self = shift;

	# get the contents of the gene cart
	my $genomes = $self->get_cart_contents('genomes');

	return unless $genomes;

	my $headers = {
		enum => [ qw( cbox taxon_oid taxon_display_name genome_type ) ],
		enum_map => {
			cbox => '',
			taxon_oid => 'IMG ID',
			taxon_display_name => 'Name',
			genome_type => 'Genome type'
		}
	};

	my $uniq = 'taxon_oid';
	my $transform = {
		# create a checkbox with the taxon_oid as the value
		cbox => sub {
			my $t = shift;
			return {
				name => 'taxon_oid',
				id => $t->{taxon_oid} || '',
				value => $t->{taxon_oid} || ''
			};
		},
		taxon_oid => sub {
			my $t = shift;
			return '<label for="'
			. ( $t->{taxon_oid} || '' )
			. '">'
			. ( $t->{taxon_oid} || '' ) . '</label>';
		}
	};

	return $self->add_defaults_and_render({
		tool_name => 'Krona',
		schema => $self->get_query_schema,
		transform => $transform,
		form => [ qw(
			taxon
		)],
		js => {
			table_headers => $headers,
			array => $genomes
		}
	});
}

sub get_cart_contents {
	my $self = shift;

	my $res = $self->run_query({
		query => 'clade',
		filters => { subset => 'prochlor' },
	});

	return $res;
}

sub get_query_schema {

	return {
		taxon => {
			control => 'checkbox_table',
			type => 'array',
			name => 'taxon_oid',
			label => 'Input',
		},
	};
}


1;