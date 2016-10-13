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

{
	package MiniContr;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
	1;
}


use IMG::Util::Base 'NetTest';
use Dancer2;
use Routes::ProPortal;

# set up the app
#my $psgi = Plack::Util::load_psgi( "$dir/proportal/bin/app.psgi" );
#is( ref $psgi, 'CODE', 'Got psgi app' );

debug 'Starting tests!';

my $pp = Routes::ProPortal->to_app;
is( ref $pp, 'CODE', 'Got app' );

my $test = Plack::Test->create( Routes::ProPortal->to_app );

# $req = GET 'http://localhost/set_session/John';
# $jar->add_cookie_header($req);
# $res = $test->request( $req );
# ok( $res->is_success, 'Successful request' );
# $jar->extract_cookies($res);


#$Plack::Test::Impl = "Server";

debug 'server: ' . ( $ENV{PLACK_SERVER} || 'undefined' );

my @filters = qw( prochlor synech prochlor_phage synech_phage isolate metagenome all_proportal );

my $obj = Routes::ProPortal->new;


my $active = $obj->active_components;
#say 'active: ' . Dumper $active;

# to test $psgi, prefix the request with "proportal/"
my $prefix = "/proportal/";

for my $p ( @{$active->{base}} ) {
	test_base_page( $p );
}

for my $p ( @{$active->{filtered}} ) {
	test_base_page( $p );
	my $mc = MiniContr->new();
	$mc->add_controller_role( $p );
	my $valid = $mc->controller->valid_filters;

	for my $f ( @filters ) {
		my $arguments = {
			page => $p,
			filter => $f,
			url => "$p/$f"
		};

		if ( grep { $f eq $_ } @{$valid->{subset}{enum}} ) {
			$arguments->{valid} = 1;
		}
		test_filter_page( $arguments );
	}
}


sub test_base_page {
	my $p = shift;

	base_tests({
		resp => $test->request( GET "$prefix$p" ),
		prefix => $prefix,
		page => $p
	});

	test_psgi Routes::ProPortal::to_app, sub {
		my $app = shift;
		my $r = $app->( GET "$prefix$p" );
		base_tests({
			resp => $r,
			prefix => $prefix,
			page => $p
		});
	};

}

sub base_tests {
	my $args = shift;
	my $p = $args->{page};
	ok( $args->{resp}->is_success, "GET " . $args->{prefix} . "$p successful!" );
	ok( $args->{resp}->content =~ /$p\.tt/, "page template name should be $p.tt" );
	if ( $args->{resp}->content !~ /$p\.tt/) {
		get_tmpl_name( $args->{resp}->content );
	}
}

sub test_filter_page {
	my $args = shift;

	filter_tests({ resp => $test->request( GET "$prefix" . $args->{url} ), %$args });

	test_psgi Routes::ProPortal::to_app, sub {
		my $app = shift;
		say "getting $prefix" . $args->{url};
		my $r = $app->( GET "$prefix" . $args->{url} );
		filter_tests({ resp => $r, %$args });
	};
}

sub filter_tests {
	my $args = shift;
	my $r = $args->{resp};
	if ($args->{valid}) {
		ok( $r->is_success, "GET successful!" );
		my $page = $args->{page} . '.tt';
		ok( $r->content =~ /$page/, "page template name should be $page" );
		if ( $r->content !~ /$page/) {
			get_tmpl_name( $r->content );
		}
		ok( $r->content =~ /.*?\(currently displayed\)/, "checking filter is active" );
	}
	else {
		ok( ! $r->is_success, "GET not successful!" );
		if ( $r->content !~ /500.tt/ ) {
			get_tmpl_name( $r->content );
		}
		ok( $r->content =~ /500.tt/, "page template name should be 500.tt" );
		my $err = err({
			err => 'invalid',
			subject => $args->{filter},
			type => 'filter value'
		});
		ok( $r->content =~ /$err/, 'Checking content contains error message');
	}
}

sub get_tmpl_name {
	my $content = shift;
	if ( $content =~ /<!-- template: (.*?) -->/s ) {
		say "template: $1";
	}
	else {
		say 'Could not find page template name';
	}
}

# pages requiring arguments: taxon/{\d+}

# check that it uses home.tt
# ok( $res-> 'home.tt'

done_testing();
