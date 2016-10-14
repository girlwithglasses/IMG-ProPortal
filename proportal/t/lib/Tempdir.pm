# Not in use currently

package Tempdir;

use Cwd;
use autodie;
use File::Temp;
use File::Path;

use base 'File::Temp::Dir';

sub new {
	my ($class, %options)       = @_;
	my $self                    = File::Temp->newdir;
	@{ $self }{ keys %options } = values %options;
	$self->{original_dir}       = cwd();

	chdir $self->dirname;
	File::Path::make_path( @{ $self->{mkdirs} } );

	bless $self, $class;
}

sub write_file {
	my ($self, $name, $contents) = @_;
	open my $outfh, '>', $name;
	print {$outfh} $contents;
}

sub DESTROY {
	my $self = shift;
	chdir delete $self->{original_dir};
	$self->SUPER::DESTROY( @_ );
}

1;

# usage:
# create the storage directories for topics/2

# my $tempdir = Tempdir->new(mkdirs => [ 'sites/Bravo', 'sites/Bravo/css' ]);
# $tempdir->write_file( $css->filepath, $css->contents );
