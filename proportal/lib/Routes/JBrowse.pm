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

1;
