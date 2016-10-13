package ProPortal::Controller::PhyloViewer::Query;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';
with qw( ProPortal::Controller::PhyloViewer::Schema );

# use IMG::App::Cart;

=head3 render

Create the PhyloViewer submission form

=cut

sub render {
	my $self = shift;

	# get the contents of the gene cart
	my $genes = $self->get_cart_contents('genes');

	return unless $genes;

# Gene ID
# taxon name
# Strain
# Gene Product Name

# 	gene_oid
# 	taxon_oid
# 	taxon_display_name
# 	desc
# 	?? strain

	my $headers = {
		enum => [ qw( cbox gene_oid desc taxon_display_name ) ],
		enum_map => {
			cbox => '',
			gene_oid => 'Gene ID',
			desc => 'Gene name',
			taxon_display_name => 'Taxon',
		}
	};

	my $uniq = 'gene_oid';
	my $transform = {
		# create a checkbox with the gene_oid + taxon_oid as the value
		cbox => sub {
			my $gp = shift;
			return {
				name => 'gp',
				id => $gp->{gene_oid} || '',
				value => $gp->{gene_oid} || ''
			};
		},
		gene_oid => sub {
			my $gp = shift;
			return '<label for="'
			. ( $gp->{gene_oid} || '' )
			. '">'
			. ( $gp->{gene_oid} || '' ) . '</label>';
		}
	};

# 	Automatically populate this list with all sequences from Gene Cart.  List box will need a scroll bar.  For each sequence in the list, provide the following columns:
# Select/deselect sequence (checkbox)
# Gene ID
# Strain
# Gene Product Name
#
# 		Controls surrounding the list:
# Label: number of sequences in list, above list box.
# Label: number of sequences selected, above list box.
# Select All (text link) --  “Select All” sequences in list, above list box
# Deselect All (text link) -- “Deselect All” sequences in list, above list box
# Ellipse (text link, toggle) -- An ellipse at the bottom of the list.  This lengthens/shortens the sequence list so that users can see more lines at once.
#
	return $self->add_defaults_and_render({
		schema => $self->get_query_schema,
		transform => $transform,
		form => [ qw(
			input
			gp
			msa
			tree
		)],
		js => {
			table_headers => $headers,
			array => $genes
		}
	});
}


sub get_cart_contents {


	return;
}

1;
