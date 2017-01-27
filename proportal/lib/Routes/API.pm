package Routes::API;
use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;
use IMG::Util::File qw( :all );
use File::Spec::Functions;

{
	package MiniContr;
	use IMG::Util::Import 'Class';
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

		bootstrap( $p );

		if ( $c->{subset} ) {
			img_app->set_filters({ subset => $c->{subset} });
		}

		my $rslt = img_app->controller->get_data();

		if ( ! $rslt ) {
			$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
		}

		content_type 'application/json';

		return JSON->new->convert_blessed(1)->encode( $rslt );

#		return $json;
	};


	get qr{ /? }x => sub {

		# for each query, set the controller
		# get the valid_filters
		my $v_q;
		for ( @valid_queries ) {
			$v_q->{$_} = MiniContr->new()->add_controller( $_ );
		}

		var menu_grp => 'proportal';
		var page_id => 'proportal';
		return template 'pages/api_home', { queries => [ @valid_queries ], subsets => [ @subsets ], apps => $v_q };

	}
};

1;
