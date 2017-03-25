package IMG::App::Role::FileManager;

use IMG::Util::Import 'MooRole';
use Scalar::Util qw( tainted );
use IO::All;
use IMG::Util::File;
use File::Spec::Functions qw( catdir catfile );
use IMG::App::Role::ErrorMessages qw( err );
use Storable;
requires 'config', 'session', 'choke';

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::FileSystem - Miscellaneous file system-related utility routines

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::App;

    my $app = IMG::App->new( %args );
    my $session_dir = $app->get_dirname( 'session' );



=cut

=head3 get_dirname

Get the name (well, path) of a directory. Does not check whether the directory is present.

@param  $dir    the type of directory;
                valid params: session | cart | web_data_dir

@return $dirname

=cut

sub get_dirname {
	my $self = shift;
	my $dir = lc( shift ) || $self->choke({ err => 'missing', subject => 'dir' });

	if ( 'session' eq $dir ) {
		return $self->get_session_dirname();
	}
	# workspace
	if ( 'workspace' eq $dir ) {
		return $self->get_workspace_dirname();
	}

	my @config_dirs = qw( web_data_dir oracle_config_dir );

	if ( grep { $dir eq $_ } @config_dirs ) {
		return $self->config->{$dir};
	}

	my $sess_subdirs = {
		cart => 'cart',
		genomehits => 'genomeHits',
		genomelist => 'GenomeList',
		genomelistjson => 'GenomeListJSON',
		studyviewer => 'StudyViewer',
		treefile => 'TreeFile',
		treefilemgr => 'TreeFileMgr',
		yui  => 'yui',
	};

	# session sub-directories
	if ( $sess_subdirs->{ $dir } ) {
		return catdir(
			$self->get_session_dirname,
			$sess_subdirs->{$dir}
		);
	}

    $self->choke({
    	err => 'invalid',
    	type => 'directory',
    	subject => $dir
    });
}


=head3 get_session_dirname

Get the name (path) of the session directory. No checking for presence/absence of dir.

@return $session_dirname

=cut

sub get_session_dirname {
	my $self = shift;
	$self->choke({
		err => 'cfg_missing',
		subject => '"cgi_tmp_dir" configuration parameter'
#	}) unless $self->has_config && $self->config->{cgi_tmp_dir};
	}) unless $self->config->{cgi_tmp_dir};

	$self->choke({
		err => 'missing',
		subject => 'sess_id'
	}) unless $self->has_session && defined $self->session->id;

	return catdir( $self->config->{cgi_tmp_dir}, $self->session->id );
}

=head3 get_workspace_dirname

Get the name (path) of the user's workspace directory.

@return $workspace_dirname

=cut

sub get_workspace_dirname {
	my $self = shift;
	$self->choke({
		err => 'cfg_missing',
		subject => '"workspace_dir" configuration parameter'
#	}) unless $self->has_config && $self->config->{workspace_dir};
	}) unless $self->config->{workspace_dir};

	$self->choke({
		err => 'missing',
		subject => 'contact_oid'
	}) unless $self->has_session
	&& defined $self->session->read('contact_oid');

	return catdir(
		$self->config->{workspace_dir},
		$self->session->read('contact_oid')
	);
}

=head3 get_taxon_file

Get the location of a taxon-related file -- e.g. sequence file,
blast results, GFF, etc.

@param $args hashref of arguments

	type => 'aa_seq' | 'dna_seq' | 'genes' | etc    type of file to retrieve
	taxon_oid => 1234567  taxon_oid

@return  /path/to/file

=cut

sub get_taxon_file {
	my $self = shift;
	my $args = shift;

	$self->choke({
		err => 'cfg_missing',
		subject => '"web_data_dir" config parameter'
	}) unless $self->config->{web_data_dir};

	my $f_names = {
		aa_seq =>	sub { return 'taxon.faa/' . +shift->{taxon_oid} . '.faa'; },
		dna_seq =>	sub { return 'taxon.fna/' . +shift->{taxon_oid} . '.fna'; },
		lin_seq =>	sub { return 'taxon.lin.fna/' . +shift->{taxon_oid} . '.lin.fna'; },
		genes =>	sub { return 'taxon.genes.fna/' . +shift->{taxon_oid} . '.fna'; },
		gff =>		sub { return 'tab.files/gff/' . +shift->{taxon_oid} . '.gff'; },
		cog =>		sub { return 'tab.files/cog/' . +shift->{taxon_oid} . '.cog.tab.txt' },
		kog =>		sub { return 'tab.files/kog/' . +shift->{taxon_oid} . '.kog.tab.txt' },
		pfam =>		sub { return 'tab.files/pfam/' . +shift->{taxon_oid} . '.pfam.tab.txt' },
		tigrfam =>	sub { return 'tab.files/tigrfam/' . +shift->{taxon_oid} . '.tigrfam.tab.txt' },
		ipr =>		sub { return 'tab.files/ipr/' . +shift->{taxon_oid} . '.ipr.tab.txt' },
		kegg =>		sub { return 'tab.files/ko/' . +shift->{taxon_oid} . '.ko.tab.txt' },
		tmhmm =>    sub { return 'tab.files/tmhmm/' . +shift->{taxon_oid} . '.tmhmm.tab.txt' },
		signalp =>  sub { return 'tab.files/signalp/' . +shift->{taxon_oid} . '.signalp.tab.txt' },
		xref =>     sub { return 'tab.files/xref/' . +shift->{taxon_oid} . '.xref.tab.txt' },
	};

	# aliases
	$f_names->{faa} = $f_names->{aa_seq};
	$f_names->{fna} = $f_names->{dna_seq};

	my $type = $args->{type} || $self->choke({ err => 'missing', subject => 'file type' });

	$self->choke({ err => 'invalid', subject => $type, type => 'file type' }) unless $f_names->{$type};

	return catdir(
		$self->config->{web_data_dir},
		$f_names->{ $type }->( $args )
	);
}


my $file_index = {

	prefs => {
		dirname => 'workspace',
		fn => 'mypreferences',
		fmt => 'hash'
	},

	genome_cart_state => {
		dirname => 'cart',
		fn_sub => sub { return 'genomeCart.' . +shift->session->id . '.stor'; },
		fmt => 'aoa'
	},

	gene_cart_col_ids => {
		dirname => 'cart',
		fn_sub => sub { return 'geneCart.' . +shift->session->id . '.colid'; },
		fmt => 'array'
	},

	gene_cart_state => {
		dirname => 'cart',
		fn_sub => sub { return 'geneCart.' . +shift->session->id . '.stor'; },
		fmt => 'aoa'
	},

	scaf_cart_state => {
		dirname => 'cart',
		fn_sub => sub { return 'scaffoldCart.' . +shift->session->id . '.stor'; },
		fmt => 'aoa'
	},

	# returns the actual cart object!
	cura_cart_state => {
		dirname => 'cart',
		fn_sub => sub { return 'curaCart.' . +shift->session->id . '.stor'; },
		fmt => 'storable'
	},

	func_cart_state => {
		dirname => 'cart',
		fn_sub => sub { return 'funcCart.' . +shift->session->id . '.stor'; },
		fmt => 'storable'
	},

	# set environment variables
	img_gold => {
		dirname => 'oracle',
		fn  => 'web.imgsg_dev.config',
		fmt => 'pl_env'
	},
	img_core => {
		dirname => 'oracle',
		fn  => 'web.img_core_v400.config',
		fmt => 'pl_env'
	},
	img_i_taxon => {
		dirname => 'oracle',
		fn  => 'web.img_i_taxon.config',
		fmt => 'pl_env'
	}

};




my $read_h = {
	hash     => sub { return IMG::Util::File::file_to_hash( $_[0] ); },
	aoa      => sub { return IMG::Util::File::file_to_aoa( $_[0] ); },
	array    => sub { return IMG::Util::File::file_to_aoa( $_[0], ',' )->[0] // []; },
	storable => sub { return retrieve( $_[0] ); },
	pl_env   => sub {
		local $@;
		eval { require $_[0]; };
		if ($@) {
			die err({
				err => 'not_readable',
				subject => $_[0],
				msg => $@
			});
		}
	},
};

=head3 read_file

Look up a file by path or by ID, read it, and return it!

=cut

sub read_file {
	my $self = shift;
	my $file = shift // $self->choke({ err => 'missing', subject => 'file' });
	my $fn = $self->get_filename( $file );
	if ( -e $fn ) {
		my $fmt = $self->get_file_fmt( $file );
		my $contents = $read_h->{$fmt}->( $fn );
		return $contents;
	}
	$self->choke({ err => 'not_found', subject => $fn });
}

sub get_file_fmt {
	my $self = shift;
	my $file = shift // $self->choke({ err => 'missing', subject => 'file' });
	if ( $file_index->{$file} ) {
		return $file_index->{$file}{fmt} || $self->choke({ err => 'missing', subject => 'file_fmt' });
	}
	$self->choke({
		err => 'not_known',
		subject => $file
	});
}

=head3 get_filename

Get the path and name of a file, given its id

@param  $file   - file ID, e.g. 'genome_cart_state' or 'prefs'

@return '/path/to/file'

Dies if the file is not known.

=cut

sub get_filename {
	my $self = shift;
	my $file = shift // $self->choke({ err => 'missing', subject => 'file' });
	if ( $file_index->{$file} ) {
		my $path = '';
		if ( $file_index->{$file}{dirname} ) {
			$path = $self->get_dirname( $file_index->{$file}{dirname} );
		}
		if ( $file_index->{$file}{fn} ) {
			return catfile( $path, $file_index->{$file}{fn});
		}
		elsif ( $file_index->{$file}{fn_sub} ) {
			return catfile( $path, $file_index->{$file}{fn_sub}->( $self ) );
		}
	}
	$self->choke({
		err => 'not_known',
		subject => $file
	});
}

=head3 touch

Touch a file, given its id. Uses IMG::Util::File::file_touch under the hood.

@param  $file   - file ID, e.g. 'genome_cart_state' or 'prefs'

Dies if the file is not known; file_touch dies if the file is not found, but this
catches the error.

=cut


sub touch {
	my $self = shift;
	my $file = shift // $self->choke({ err => 'missing', subject => 'file' });
	my $fn = $self->get_filename( $file );
	local $@;
	eval { IMG::Util::File::file_touch( $fn ); };
	return;
}


1;
