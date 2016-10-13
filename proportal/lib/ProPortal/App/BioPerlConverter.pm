{
	package ScriptAppArgs;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;

	has 'infh' => (
		is => 'ro',
		required => 1,
		init_arg => 'infile',
		coerce => sub {
			open my $fh, "<", $_[0] or die err({
				err => 'not_readable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		},
	);

	has 'outfh' => (
		is => 'ro',
		required => 1,
		init_arg => 'outfile',
		coerce => sub {
			open my $fh, ">", $_[0] or die err({
				err => 'not_writable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		}
	);

	has 'from' => (
		is => 'ro',
		required => 1,
	);

	has 'to' => (
		is => 'ro',
		required => 1,
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

#
#	Generated automatically from 'from' and 'to'
#
	has 'mode' => (
		is => 'lazy',
	);

	sub _build_mode {
		my $self = shift;
#		say 'running build mode: ' . Dumper $self;
		if ( $self->from eq $self->to ) {
			$self->choke({
				err => 'different',
				a => 'The source',
				b => 'destination formats'
			});
		}

		my $from = $self->_check_mode( $self->from );
		my $to = $self->_check_mode( $self->to );
		if ( $from ne $to ) {
			$self->choke({
				err => 'same',
				a => 'The source',
				b => 'destination format types'
			});
		}
		return $from;
	}

	has 'bioperl_module' => (
		is => 'lazy'
	);

	sub _build_bioperl_module {
		my $self = shift;
		my $modes = {
			aln => 'Bio::AlignIO',
			tree => 'Bio::TreeIO'
		};
		return $modes->{ $self->mode };
	}

	has 'valid_mode_h' => (
		is => 'lazy',
	);

	sub _build_valid_mode_h {
		return {

# alignment formats

# bl2seq      Bl2seq Blast output
# clustalw    clustalw (.aln) format
# emboss      EMBOSS water and needle format
# fasta       FASTA format
# maf         Multiple Alignment Format
# mase        mase (seaview) format
# mega        MEGA format
# meme        MEME format
# msf         msf (GCG) format
# nexus       Swofford et al NEXUS format
# pfam        Pfam sequence alignment format
# phylip      Felsenstein PHYLIP format
# prodom      prodom (protein domain) format
# psi         PSI-BLAST format
# selex       selex (hmmer) format
# stockholm   stockholm format

			aln => [ qw[
bl2seq
clustalw
emboss
fasta
maf
mase
mega
meme
msf
nexus
pfam
phylip
prodom
psi
selex
stockholm
			] ],

# tree formats:

# newick             Newick tree format
# nexus              Nexus tree format
# nhx                New Hampshire eXtended tree format

			tree => [ qw[ newick nexus nhx ] ],
		};
	}

	sub _check_mode {
		my $self = shift;
		my $fmt = shift;
		for my $m ( keys %{$self->valid_mode_h} ) {
			if ( grep { $fmt eq $_ } @{$self->valid_mode_h->{$m}} ) {
				return $m;
			}
		}
		$self->choke({
			err => 'invalid',
			subject => $fmt,
			type => 'format'
		});
	}

	1;

}

package ProPortal::App::BioPerlConverter;

use IMG::Util::Base 'Class';
use ScriptAppArgs;
extends 'IMG::App';
with qw(
	IMG::Util::ScriptApp
);

use Bio::TreeIO;
use Bio::AlignIO;

=head3 convert

Takes an input file and converts it to a different formats

Input: hashref with keys

	infile   - input file
	from     - input file format

	outfile  - writable file for output
	to       - output file format

@return
	1 if the conversion was successful
	dies on failure

=cut

sub convert {
	my $self = shift;

	my $module = $self->args->bioperl_module;
	my $next_cmd = 'next_' . $self->args->mode;
	my $write_cmd = 'write_' . $self->args->mode;

	my $input = $module->new(
		-fh   => $self->args->infh,
		-format => $self->args->from
	);

	my $output = $module->new(
		-fh => $self->args->outfh,
		-format => $self->args->to
	);

	# make warnings fatal
	local $SIG{__WARN__} = sub {
		my $msg = shift;
		$self->choke({
			err => 'module_err',
			subject => 'BioPerl',
			msg => $msg
		});
	};

	while( my $obj = $input->$next_cmd ) {
		$output->$write_cmd( $obj );
	}

	$SIG{__WARN__}  = 'DEFAULT';

	return 1;

}

1;
