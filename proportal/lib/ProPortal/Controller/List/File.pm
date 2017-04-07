package ProPortal::Controller::List::File;

use IMG::Util::Import 'Class';#'MooRole';
use File::Basename;
use IO::All;

extends 'ProPortal::Controller::Filtered';

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/file'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type file_type taxon_oid ) ];
	}
);

=head3 file_type

Retrieve a list of the files available for download

=cut

sub _render {
	my $self = shift;

	my $table = {
		thead => {
			enum => [ 'taxon_oid', 'taxon_display_name', 'dataset_type', 'pp_subset', @{$self->query_filter_schema->{file_type}{enum}} ],
			enum_map => {
				taxon_oid => 'Taxon ID',
				pp_subset => 'ProPortal subset',
#				%{ $self->query_filter_schema->{file_type}{enum_map} },
			}
		},
		transform => {
			taxon_oid => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
					text => $x->{taxon_oid}
				};
			},
			taxon_display_name => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
					text => $x->{taxon_display_name}
				};
			}
		}
	};

	for my $e ( @{$self->query_filter_schema->{file_type}{enum}} ) {
		$table->{transform}{$e} = sub {
			my $x = shift;
			return '' unless $x->{$e};
			return {
				macro => 'generic_link',
				type => 'file',
				params => { taxon_oid => $x->{taxon_oid}, file_type => $e },
				text => $x->{$e}
			};
		};
	}


	return { results => {
		domain => 'file',
		arr => $self->get_data,
		table => $table,
		params => $self->filters,

		## UPDATE!
#		taxon => $self->get_data
	} };
}


sub get_data {
	my $self = shift;

	# get basic taxon info for each of the members
	my $data = $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
	});

	# TEMPORARY
	for my $tax ( @$data ) {
		for ( @{$self->query_filter_schema->{file_type}{enum}} ) {
			my $f = $self->_core->get_taxon_file({ type => $_, taxon_oid => $tax->{taxon_oid} });
			$tax->{$_} = io( $f )->exists ? basename( $f ) : 0 ;
		}
	}

	# get the listings file, filtering by file_type and taxon_oid


	return $data;


}

sub examples {

# Use /file/ to download several different types of annotation files for one or many taxa.  In order to actually download a file, provide a unique taxon_oid and a file_type.  Other argument combinations will list available files for given taxa and file types.
#
# Valid Key IDs:  ( taxon_oid )
#
# Valid Arguments:
# file_type = ( aa_seq | dna_seq | lin_seq | genes | gff | cog | kog | pfam | tigrfam | ipr | kegg | tmhmm | signalp | xref | bundle )
# pp_subset = ( pro | syn | other | metagenome | pro_phage | other_phage )
# dataset_type = ( transcriptome | single_cell | isolate | metagenome | metatranscriptome )
#
#
# /api/file	displays a large table with download links for all available taxon_oids in ProPortal for each “file_type”
# /api/details/file **	readme showing the available values of the argument “file_type” and how to use it in a URL query
# 	** note that this belongs in the /details/ section, but is relevant here!
#
# /api/file?taxon_oid=12345678	shows the available files for a taxon
# /api/file?pp_subset=pro
# /api/file?taxon_oid=12345678&file_type=gff		downloads a gff file for taxon 12345678.

	return [{
		url => '/api/file?pp_subset=pro',
		desc => 'shows the list of all available files for all <i>Prochlorococcus</i> taxa'
	},{
		url => '/api/file?taxon_oid=640069325',
		desc => 'shows the files available for taxon IMG:640069325, <i>Prochlorococcus</i> sp. NATL1A'
	},{
		url => '/api/file?taxon_oid=12345678&file_type=gff',
		desc => 'downloads the GFF file for taxon 12345678'
	}];
}




1;
