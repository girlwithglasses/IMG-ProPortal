package Routes::ProPortal;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';
use ProPortal::Util::Factory;

our $VERSION = '0.1';

our @active_components = qw( home data_type location clade phylo_heat phylogram );

prefix '/proportal' => sub {

	# filterable queries
	get qr{
		/ (?<page> location | clade | data_type | phylo_heat | phylogram | ecosystem )
		/? (?<subset> prochlor | synech | prochlor_phage | synech_phage | metagenome | isolate )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};

		var menu_grp => 'proportal';
		var page_id => 'proportal/' . $p;

		my $pp = CoreStuff::bootstrap( $p, config );

		my $results;
		if ($c->{subset}) {
			$pp->set_filters($c);
		}
		else {
			'phylogram' eq $p
			? $pp->set_filters({ subset => 'isolate' })
			: $pp->set_filters({ subset => 'datamart' });
		}

		return template "pages/" . $p, $pp->render();

	};

	get qr{
		( / ( home | index ) )?
		}x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal';

		my $pp = CoreStuff::bootstrap( 'Home', config );

		return template "pages/home", $pp->render();

	};

# 	get '/taxon/:taxon_oid' => sub {
#
# 		my $pp = CoreStuff::bootstrap( 'Details' );
#
# 		$pp->set_filters({ taxon_oid => params->{taxon_oid} });
#
# 		template "pages/genome_details", $pp->render();
#
# 	};

};

1;
