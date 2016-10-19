package Routes::API;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';
use IMG::Util::File qw( :all );
use File::Spec::Functions;

{
	package MiniContr;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
	1;
}

prefix '/api/proportal' => sub {

	my @valid_queries = qw( location clade data_type phylogram ecosystem ecotype big_ugly_taxon_table );

	my @subsets = qw( metagenome isolate prochlor synech prochlor_phage synech_phage );

	my $re = join '|', @valid_queries;

	# filterable queries
	get qr{
		/ (?<page> $re )
		/? (?<subset> \w+.* )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};


		my $pp = AppCore::bootstrap( $p );
		if ( $c->{subset} ) {
			$pp->set_filters({ subset => $c->{subset} });
		}

		my $rslt = $pp->get_data();

		if ( ! $rslt ) {
			$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
		}

		say Dumper $rslt;

		content_type 'application/json';

		my $json = JSON->new->convert_blessed(1)->encode( $rslt );

		return $json;
	};


	get qr{ /? }x => sub {

		# for each query, set the controller
		# get the valid_filters
		my $v_q;
		for ( @valid_queries ) {
			my $app = MiniContr->new();
			$app->add_controller_role( $_ );
			say $_ . ' controller: ' . Dumper $app->controller;
			$v_q->{$_} = $app->controller->valid_filters;
		}

		say 'valid filters: ' . Dumper $v_q;

		var menu_grp => 'proportal';
		var page_id => 'proportal';
		return template 'pages/datamart_stats', { queries => [ @valid_queries ], subsets => [ @subsets ] };

	}
};

1;
