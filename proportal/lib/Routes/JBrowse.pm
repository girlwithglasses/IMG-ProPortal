package Routes::JBrowse;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';
our $VERSION = '0.1.0';

use ProPortal::Util::JBrowseFilePrep;
#
#	Needs the JBrowse libs located at jbrowse/extlib/lib/perl5  and jbrowse/src/perl5
#

prefix '/jbrowse' => sub {

	# temporary fix for JBrowse path issues

#	get qr{/(img|plugins)/.*?} => sub {
#		my $path = request->dispatch_path;
#		$path =~ s!/jbrowse/!/jbrowse_assets/!;
#		redirect $path;
#	};

	get qr{
		/ (?<taxon_oid> \d{1,16} )
		/?
		}x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal/jbrowse';

		my $c = captures;
		my $taxon_oid = $c->{taxon_oid};

		die err({ err => 'missing', subject => 'taxon_oid' }) unless $taxon_oid;

		my $pp = #setting('_core') ||
			AppCore::create_core();
		my @roles = qw(
			ProPortal::IO::DBIxDataModel
			ProPortal::Util::JBrowseFilePrep
		);

		Role::Tiny->apply_roles_to_object( $pp, @roles );
		$pp->_set_taxon_oid( $taxon_oid );
		$pp->run();

		template 'pages/jbrowse.tt', { data_dir => '/jbrowse_assets/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };

	};
};

=cut

use AnyEvent;
use Promises backend => ['AE'], qw[ deferred collect ];
use AnyEvent::IO;
#use IO::AIO;
#use Carp 'verbose';

prefix '/async/jbrowse' => sub {
	get qr{
		/ (?<taxon_oid> \d{1,16} )
		/?
		}x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal/jbrowse';

		my $c = captures;
		my $taxon_oid = delete $c->{taxon_oid};

		die err({ err => 'missing', subject => 'taxon_oid' }) unless $taxon_oid;

		# see if we have already converted this data
		delayed {
#			flush;

			use IMG::App::Role::Templater;
			my $conf = config;
			IMG::App::Role::Templater::init_env({ %$conf, base_dir => '/Users/gwg/webUI/proportal' });
			my $output = IMG::App::Role::Templater::render_template({ tmpl => 'pages/jbrowse.tt', data => { data_dir => '/jbrowse_assets/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid } });
			content $output;

			if ( ! -e config->{scratch_dir} . $taxon_oid . '/trackList.json') {
				generate_jbrowse_data_async( $taxon_oid );
			}

#			template 'pages/jbrowse.tt', { data_dir => '/jbrowse_assets/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };
			done;
		}

	};
};


sub generate_jbrowse_data_async {

	my $taxid = shift // die 'No taxon ID supplied; cannot generate JBrowse data';
	my $dest_dir = config->{scratch_dir} . $taxid . '/source/';
	my $cv = AE::cv;

	collect(
		create_scratch_dir_async( $taxid ),
		do_async( \&create_ref_seq, $taxid ),
		do_async( \&create_gff_track, $taxid ),
#		get_taxon_data( $taxid ),
		do_async( \&get_gene_oids_from_gff, $taxid ),

	)->then( sub {
		my @args = @_;
		collect(  ## these all need to be Promises
			map {
				do_async( \&tab_delimited_to_gff, [ $_, $taxid, $args[-1][0] ] )
				} qw( cog kog pfam tigrfam ipr kegg )
		);
	})->then( sub {
		do_async( \&index_names, $taxid )
	})->then(
		sub { say 'Success!' and $cv->send; },
		sub { $cv->croak( 'ERROR' ) }
	);

	$cv->recv;
}


sub do_async {
    my ( $callback, $input ) = @_;
    my $d = deferred;
    my $w;
    $w = AE::timer 0, 0, sub {
    	say 'Running an async callback';
    	$d->resolve( $callback->( ref( $input ) ? @$input : $input ) );
        undef $w;
    };
    $d->promise;
}


sub create_scratch_dir_async {
	my $taxid = shift;
	my $d = deferred;
	aio_mkdir config->{scratch_dir} . $taxid, 0777, sub {
		-w config->{scratch_dir} . $taxid
		? $d->resolve( $taxid )
		: $d->reject( 'Could not create ' . config->{scratch_dir} . $taxid );
	};
	$d->promise;
}

=cut


1;
