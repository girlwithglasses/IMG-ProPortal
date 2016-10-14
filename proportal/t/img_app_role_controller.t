#!/usr/bin/env perl
my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Base 'Test';
use Dancer2;
use AppCore; # basic app stuff
use ProPortal::Controller::Filtered;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App';
}

{	package MiniController;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
}

{
	package Controller::FilteredRole;
	use IMG::Util::Base 'MooRole';

	has 'controller_args' => (
		is => 'lazy',
		default => sub {
			return {
				class => 'ProPortal::Controller::Filtered',
				tmpl_includes => {
					tt_scripts => qw( data_type )
				}
			};
		}
	);

	sub random_function {
		say 'I can do random_function!';
	}
}

subtest 'default controllers' => sub {

	my $base = ProPortal::Controller::Base->new();
	my $filt = ProPortal::Controller::Filtered->new();

	my $test = TestApp->new();
	my $app2 = TestApp->new( controller => 'ProPortal::Controller::Filtered' );
	my $app3 = TestApp->new( controller => $filt );
	my $app4 = TestApp->new( controller => { pip => 'pop' } );

	ok( ! $base->can("filters"), 'Checking that directly-created model does not have filters' );
	ok( ! $test->controller->can('filters'), 'Checking that test app does not have filters' );

	is_deeply(
		$filt->filters,
		{ subset => 'all_proportal' },
		'Checking that directly-created controller has filters'
	);

	is_deeply( $app2->controller->filters, { subset => 'all_proportal' }, 'Checking that directly-created controller has filters' );

	is_deeply( $app3->controller->filters, { subset => 'all_proportal' }, 'Checking that directly-created controller has filters' );

	is_deeply( $app4->controller->{pip}, 'pop', 'Checking a hashref' );
	ok( ! defined $app4->controller->{filters}, 'Checking there are no filters' );

};

my $msg;

subtest 'filter validity' => sub {

	subtest 'error states' => sub {

		my $filt = ProPortal::Controller::Filtered->new();
		my $f = 'blob';

		$msg = err({
			err => 'invalid',
			subject => $f,
			type => 'query dimension to filter'
		});
		throws_ok {
			$filt->set_filters( $f => [ 1, 2, 3 ] );
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => $f,
			type => 'filter value'
		});
		throws_ok {
			$filt->set_filters( subset => $f );
		} qr[$msg];
	};

	subtest 'valid' => sub {

		my $filt = ProPortal::Controller::Filtered->new();

		is_deeply(
			$filt->valid_filters,
			{	subset => {
					enum => [ qw( prochlor synech prochlor_phage synech_phage isolate metagenome all_proportal ) ]
				}
			},
			'checking valid filters'
		);
		is_deeply(
			$filt->filter_schema,
			{
				subset => {
					id => 'subset',
					type  => 'enum',
					title => 'subset',
					control => 'checkbox',
					enum => [ qw( prochlor synech prochlor_phage synech_phage isolate metagenome all_proportal ) ],
					enum_map => {
						prochlor => 'Prochlorococcus',
						synech => 'Synechococcus',
						prochlor_phage => 'Prochlorococcus phage',
						synech_phage => 'Synechococcus phage',
						isolate => 'All ProPortal isolates',
						metagenome => 'Marine metagenomes',
						all_proportal => 'All isolates and metagenomes'
					}
				}
			},
			'Checking schema is correct'
		);

	};
};

subtest 'controllers and roles' => sub {

	# if we apply a role that has controller_args, use the values controller_args
	# to set the controller
	subtest 'ProPortal::Controller::PhyloViewer::Results' => sub {
		my $test = TestApp->new();

		ok( ! $test->can( 'get_metadata_for_taxa' ), 'cannot get_metadata_for_taxa' );
		ok( ! $test->can( 'get_taxon_oid_for_genes' ), 'cannot get_taxon_oid_for_genes' );

		$test->add_controller_role( 'ProPortal::Controller::PhyloViewer::Results' );

		ok( $test->can( 'get_metadata_for_taxa' ), 'can get_metadata_for_taxa' );
		ok( $test->can( 'get_taxon_oid_for_genes' ), 'can get_taxon_oid_for_genes' );
		isa_ok( $test->controller, 'ProPortal::Controller::Base' );
		is_deeply( $test->controller->tmpl_includes, { tt_scripts => [ 'phylo_viewer' ] } );
	};

	subtest 'ProPortal::Controller::Clade' => sub {
		my $test = TestApp->new();
		ok( ! $test->can('render'), 'cannot render' );
		ok( ! $test->can('get_data'), 'cannot get data' );
		$test->add_controller_role('clade');
		ok( $test->can('render'), 'can render' );
		ok( $test->can('get_data'), 'can get data' );
		isa_ok( $test->controller, 'ProPortal::Controller::Filtered' );

		subtest 'defaults' => sub {

			is_deeply( $test->controller->tmpl_includes, {
				tt_scripts => qw( clade ),
				tt_styles  => qw( clade ),
			}, 'checking tmpl_includes' );

			is_deeply( $test->controller->valid_filters, {
				subset => {
					enum => [ qw( prochlor synech isolate ) ],
				}
			}, 'checking valid filters' );

			is_deeply( $test->controller->filters, {
				subset => 'isolate'
			}, 'checking default value' );

		};

		subtest 'error states' => sub {
			# check invalid and valid values
			my $f = 'blob';
			$msg = err({
				err => 'invalid',
				subject => $f,
				type => 'query dimension to filter'
			});
			throws_ok {
				$test->set_filters( $f => [ 1, 2, 3 ] );
			} qr[$msg];
			throws_ok {
				$test->controller->set_filters( $f => [ 1, 2, 3 ] );
			} qr[$msg];

			is_deeply(
				$test->filters,
				{ subset => 'isolate' },
				'checking filter is unchanged'
			);

			$msg = err({
				err => 'invalid',
				subject => $f,
				type => 'filter value'
			});
			throws_ok {
				$test->set_filters( subset => $f );
			} qr[$msg];
			throws_ok {
				$test->set_filters({ subset => $f });
			} qr[$msg];
		};

		subtest 'valid' => sub {

			lives_ok {
				$test->set_filters({ subset => 'prochlor' });
			};

			is_deeply(
				$test->filters,
				{ subset => 'prochlor' },
				'checking the filters are set correctly'
			);

			lives_ok {
				$test->set_filters( subset => 'synech' );
			};
			is_deeply(
				$test->filters,
				{ subset => 'synech' },
				'checking the filters are set correctly'
			);

			$msg = err({
				err => 'invalid',
				subject => 'blob',
				type => 'filter value'
			});
			throws_ok {
				$test->set_filters( subset => 'blob' );
			} qr[$msg];

			is_deeply(
				$test->filters,
				{ subset => 'synech' },
				'checking the filters have not changed'
			);

			lives_ok {
				$test->set_filters( subset => 'isolate' );
			};
			is_deeply(
				$test->filters,
				{ subset => 'isolate' },
				'checking the filters are set correctly'
			);

		};

	};

	subtest 'Controller::FilteredRole' => sub {
		my $test = TestApp->new();
		ok( ! $test->can('random_function'), 'cannot random_function' );
		$test->add_controller_role('Controller::FilteredRole');
		ok( $test->can('random_function'), 'can random_function' );
		isa_ok( $test->controller, 'ProPortal::Controller::Filtered' );
		is_deeply( $test->controller->tmpl_includes, {
			tt_scripts => qw( data_type )
		}, 'checking tmpl_includes' );
		is_deeply( $test->controller->filters, { subset => 'all_proportal' }, 'checking filters' );
	};

	subtest 'ProPortal::Controller::DataType' => sub {
		my $test = TestApp->new();
		ok( ! $test->can('render'), 'cannot render' );
		ok( ! $test->can('get_data'), 'cannot get data' );
		$test->add_controller_role('ProPortal::Controller::DataType');
		ok( $test->can('render'), 'can render' );
		ok( $test->can('get_data'), 'can get data' );
		isa_ok( $test->controller, 'ProPortal::Controller::Filtered' );
		is_deeply( $test->controller->tmpl_includes, {
			tt_scripts => qw( data_type )
		}, 'checking tmpl_includes' );
		is_deeply( $test->controller->filters, { subset => 'all_proportal' }, 'checking filters' );
	};

	subtest 'ProPortal::Controller::Phylogram' => sub {
		my $test = TestApp->new();
		ok( ! $test->can('render'), 'cannot render' );
		ok( ! $test->can('get_data'), 'cannot get data' );
		$test->add_controller_role('ProPortal::Controller::Phylogram');
		ok( $test->can('render'), 'can render' );
		ok( $test->can('get_data'), 'can get data' );
		isa_ok( $test->controller, 'ProPortal::Controller::Filtered' );
		is_deeply( $test->controller->tmpl_includes, {
			tt_scripts => qw( phylogram )
		}, 'checking tmpl_includes' );
		is_deeply( $test->controller->filters, { subset => 'isolate' }, 'checking filters' );
		is_deeply( $test->controller->valid_filters,
		{ subset => {
			enum => [ qw( prochlor synech prochlor_phage synech_phage isolate ) ]
		}	}, 'checking valid filters' );
		$test->set_filters( subset => 'prochlor_phage' );
		is_deeply( $test->controller->filters, { subset => 'prochlor_phage' }, 'checking filters post-setting' );
		$msg = err({
			err => 'invalid',
			subject => 'metagenome',
			type => 'filter value'
		});

		throws_ok {
			$test->set_filters( subset => 'metagenome' )
		} qr[$msg], 'Checking invalid filter';

		$test = TestApp->new();
		$test->add_controller_role('phylogram');
		$test->set_filters( subset => 'isolate' );
		is_deeply( $test->controller->filters, { subset => 'isolate' }, 'checking filters post-setting' );
	};

	subtest 'custom controller_args' => sub {
		my $test = TestApp->new();
		subtest 'blank controller' => sub {
			ok( ! $test->can('render'), 'cannot render' );
			ok( ! $test->can('get_data'), 'cannot get data' );
		};
		subtest 'adding datatype controller' => sub {
			$test->add_controller_role('ProPortal::Controller::DataType');
			ok( $test->can('render'), 'can render' );
			ok( $test->can('get_data'), 'can get data' );
			is_deeply( $test->controller->tmpl_includes,
			{ tt_scripts => qw( data_type ) },
			'checking tmpl_includes are correct');
		};

		## THIS IS NOT WORKING!!
		subtest 'adding base controller' => sub {
			# set controller args
			$test = TestApp->new();
			$test->_set_controller({ class => 'ProPortal::Controller::Base', tmpl_includes => 'this', filters => 'that', valid_filters => { pip => 'pop' } });
			isa_ok( $test->controller, 'ProPortal::Controller::Base' );
			ok( ! $test->controller->can( 'filters' ), 'Checking there are no filters' );
			ok( $test->controller->tmpl_includes eq 'this', 'checking tmpl includes' );
		};

		subtest 'adding a different controller' => sub {

			$test = MiniController->new();
			$test->add_controller_role('ProPortal::Controller::Ecotype');

			say 'test now: ' . Dumper $test;
			isa_ok( $test->controller, 'ProPortal::Controller::Filtered' );
			is_deeply( $test->controller->filters,
				{ subset => 'prochlor' },
				'testing default for ecotype controller'
			);
			is_deeply( $test->controller->valid_filters->{subset},
			{ enum => [ 'prochlor' ] },
			'testing valid filters'
			);
		};
	};

	subtest 'instantiate object with role' => sub {

		my $test = TestApp->new(
			controller_role => 'ProPortal::Controller::PhyloViewer::Results',
			controller_args => {
				tmpl_includes => 'blob',
				valid_filters => { pip => 'pop' }
			}
		);

		ok( $test->does('ProPortal::Controller::PhyloViewer::Results'), 'checking role' );

		ok( $test->can( 'render' ), 'can render' );
		ok( $test->can( 'get_metadata_for_taxa' ), 'can get_metadata_for_taxa' );
		ok( $test->can( 'get_taxon_oid_for_genes' ), 'can get_taxon_oid_for_genes' );
		isa_ok( $test->controller, 'ProPortal::Controller::Base' );
		## THIS SHOULD NOT WORK!!
		is_deeply( $test->controller->tmpl_includes, { tt_scripts => ["phylo_viewer"] }, 'checking tmpl_includes' );


	};

};


done_testing();

