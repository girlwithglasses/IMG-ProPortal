{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	use Getopt::Long qw( GetOptionsFromArray );
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;

	has 'gene_taxon_file' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				die 'gene taxon file ' . $_[0] .
				( -e $_[0]
					? ' is not readable'
					: ' does not exist' );
			}
		}
	);

	has 'newick' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				die 'Newick file ' . $_[0] .
				( -e $_[0]
					? ' is not readable'
					: ' does not exist' );
			}
		}
	);

	has 'metadata' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				die 'Metadata file ' . $_[0] .
				( -e $_[0]
					? ' is not readable'
					: ' does not exist' );
			}
		}
	);

	has 'outfile' => (
		is => 'ro',
		required => 1,
		coerce => sub {
			open my $fh, ">", $_[0] or die err({
				err => 'not_writable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		}
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

	1;
}

package ProPortal::App::PhyloViewerPageGenerator;

use IMG::Util::Import 'Class';
use ScriptAppArgs;
use AppCore;
extends 'IMG::App';
with qw(
	ProPortal::IO::DBIxDataModel
	ProPortal::Controller::PhyloViewer::Pipeline
	IMG::Util::ScriptApp
	IMG::App::Role::Templater
);

has 'controller_role' => (
	is => 'ro',
	default => 'ProPortal::Controller::PhyloViewer::Results'
);

sub run {
	my $self = shift;

	my $rslts = $self->render( $self->args );
	$rslts->{settings} = $self->config;
	$rslts->{page_wrapper} = 'layouts/contents_only.html.tt';
	$rslts = AppCore::get_tmpl_vars({ core => $self, output => $rslts });

	print { $self->args->outfile } $self->render_template({
		tmpl_args => {
			%{ $self->config->{engines}{template}{template_toolkit} },
			INCLUDE_PATH => $self->config->{views}
		},
		tmpl_data => $rslts,
		tmpl => 'pages/proportal/phylo_viewer/results.tt'
	});

}

1;
