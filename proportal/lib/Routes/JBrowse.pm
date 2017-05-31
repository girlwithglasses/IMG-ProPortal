package Routes::JBrowse;
use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;
our $VERSION = '0.1.0';

use ProPortal::Util::JBrowseFilePrep;
#
#	Needs the JBrowse libs located at jbrowse/extlib/lib/perl5  and jbrowse/src/perl5
#

prefix '/jbrowse' => sub {

	get qr{
		/ (?<taxon_oid> \d{1,16} )
		/?
		}x => sub {

		img_app->current_query->_set_page_id( 'proportal/jbrowse' );
		img_app->current_query->_set_menu_group( 'proportal' );

		my $c = captures;
		my $taxon_oid = $c->{taxon_oid};

		die err({ err => 'missing', subject => 'taxon_oid' }) unless $taxon_oid;

		my $pp = img_app;
		my @roles = qw(
			ProPortal::IO::DBIxDataModel
			ProPortal::Util::JBrowseFilePrep
		);

#		bootstrap( $cntrl, $controller_args );
		Role::Tiny->apply_roles_to_object( $pp, @roles );
		$pp->_set_taxon_oid( $taxon_oid );
		$pp->run();

		template 'pages/jbrowse.tt', { data_dir => '/jbrowse_assets/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };

	};
};




1;
