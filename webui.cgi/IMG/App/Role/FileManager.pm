package IMG::App::Role::FileManager;

use IMG::Util::Base 'MooRole';
use Scalar::Util qw(tainted);
use IMG::Util::File;
use File::Spec::Functions qw( catdir catfile );
use Storable;
requires 'config', 'session';

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

@param  $dir    the type of directory; valid params: session | cart |

@return $dirname

=cut

sub get_dirname {
	my $self = shift;
	my $dir = lc( shift ) || die 'No directory specified';

	if ( 'session' eq $dir ) {
		return $self->get_session_dirname();
	}
	# workspace
	if ( 'workspace' eq $dir ) {
		return $self->get_workspace_dirname();
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
		return catdir( $self->get_session_dirname, $sess_subdirs->{$dir} );
	}

    die "directory '$dir' not known";
}


=head3 get_session_dirname

Get the name (path) of the session directory. No checking for presence/absence of dir.

@return $session_dirname

=cut

sub get_session_dirname {
	my $self = shift;
	die 'Config parameter "cgi_tmp_dir" not set' unless $self->has_config && $self->config->{cgi_tmp_dir};
	die 'No session ID found' unless $self->has_session && defined $self->session->id;

	return catdir( $self->config->{cgi_tmp_dir}, $self->session->id );
}

=head3 get_workspace_dirname {

Get the name (path) of the user's workspace directory.

@return $workspace_dirname

=cut

sub get_workspace_dirname {
	my $self = shift;
	die 'Config parameter "workspace_dir" not set' unless $self->has_config && defined $self->config->{workspace_dir};
	die 'User ID not found in session' unless $self->has_session && defined $self->session->read('contact_oid');
	return catdir(
		$self->config->{workspace_dir},
		$self->session->read('contact_oid')
	);
}


my $file_index = {

	prefs => { dirname => 'workspace', fn => 'mypreferences', fmt => 'hash' },

	genome_cart_state => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'genomeCart.' . $self->session->id . '.stor'; }, fmt => 'aoa' },

	genome_cart_col_ids => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'geneCart.' . $self->session->id . '.colid'; }, fmt => 'array' },

	gene_cart_state => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'geneCart.' . $self->session->id . '.stor'; }, fmt => 'aoa' },

	scaf_cart_state => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'scaffoldCart.' . $self->session->id . '.stor'; }, fmt => 'aoa' },

	# returns the actual cart object!
	cura_cart_state => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'curaCart.' . $self->session->id . '.stor'; }, fmt => 'storable' },

	func_cart_state => { dirname => 'cart', fn_sub => sub { my $self = shift; return 'funcCart.' . $self->session->id . '.stor'; }, fmt => 'storable' },

};

my $read_h = {
	hash => sub { return IMG::Util::File::file_to_hash( @_ ); },
	aoa  => sub { return IMG::Util::File::file_to_aoa( @_ ); },
	storable => sub { return retrieve( @_ ); },
};

=head3 read_file

Look up a file by path or by ID, read it, and return it!

=cut

sub read_file {
	my $self = shift;
	my $file = shift // die 'No file specified';
	my $fn = $self->get_filename( $file );
	if ( -e $fn ) {
		my $fmt = $self->get_file_fmt( $file );
		my $contents = $read_h->{$fmt}->( $fn );
		return $contents;
	}
	die $fn . ' not found';
}

sub get_file_fmt {
	my $self = shift;
	my $file = shift // die 'No file specified';
	if ( $file_index->{$file} ) {
		return $file_index->{$file}{fmt} || die 'No format specified';
	}
	die 'File ' . $file . ' is unknown';
}

=head3 get_filename

Get the path and name of a file, given its id

@param  $file   - file ID, e.g. 'genome_cart_state' or 'prefs'

@return '/path/to/file'

Dies if the file is not known.

=cut

sub get_filename {
	my $self = shift;
	my $file = shift // die 'No file specified';
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
	die 'File ' . $file . ' is unknown';
}

=head3 touch

Touch a file, given its id. Uses IMG::Util::File::file_touch under the hood.

@param  $file   - file ID, e.g. 'genome_cart_state' or 'prefs'

Dies if the file is not known; file_touch dies if the file is not found, but this
catches the error.

=cut


sub touch {
	my $self = shift;
	my $file = shift // die 'No file specified';
	my $fn = $self->get_filename( $file );
	local $@;
	eval { IMG::Util::File::file_touch( $fn ); };
	return;
}


1;
