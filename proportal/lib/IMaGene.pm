package IMaGene;

# use lib qw(
# 	/global/u1/a/aireland/webUI/webui.cgi
# 	/global/u1/a/aireland/webUI/proportal/lib
# 	/global/u1/a/aireland/perl5/lib/perl5
# );

use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use Dancer2::Session::CGISession;
use Dancer2::Plugin::Ajax;
use IMG::App;
use IMG::App::Dispatcher;
use IMG::Views::ViewMaker;
use CGI::Emulate::PSGI;
use Filter::Handle;
our $VERSION = '0.1';

any '/launch' => sub {
	return '3... 2... 1... blast off!';
};

prefix '/cgi-bin';

any '/main.cgi?**' => sub {

	say 'about to run cgi_dispatch';
	my $rtn = cgi_dispatch( request );
	my $n_taxa;
	my $core = setting('_core');
	# get template variables
	my $tmpl_vars = get_tmpl_vars();
	$tmpl_vars->{title} = $rtn->{tmpl_args}{title};
	# current -- which section
	say 'rtn: ' . Dumper $rtn;
	my $tmpl_inc;
#	my $tmpl_vars = $rtn->{tmpl_args};
	if ( $rtn->{tmpl_args}{ yui_js } ) {
		push @{$tmpl_inc->{scripts}}, $rtn->{tmpl_args}{ yui_js };
	}

	for my $x ( 'yui_js', 'scripts' ) {
		if ( $rtn->{tmpl_args}{ $x } ) {
			push @{$tmpl_inc->{scripts}}, $rtn->{tmpl_args}{ $x };
		}
	}

	if ( $rtn->{tmpl_args}{ include_styles} ) {
		push @{$tmpl_inc->{styles}}, $rtn->{tmpl_args}{include_styles};
	}



	if ( config->{async} ) {


		delayed {

#			add_header 'X-Foo' => 'Bar';

			# optionally flush headers
			flush;

			# print top of the page
			content img_render( tmpl_args => $rtn->{tmpl_args}, request => request, part => 'page_top' ) if 'default' eq $rtn->{tmpl};

			# you can write more content
			# all streaming
			content 'Hello, again!';

			my $output;
			local $@;
			eval {

				open local *STDOUT, ">", \$output or die "Could not open STDOUT: $!";

				$rtn->{sub_to_run}->( );

				close local *STDOUT;

			};
			die $@ if $@;

			# print the bottom of the page
			content img_render( tmpl_args => $rtn->{tmpl_args}, request => request, part => 'page_bottom' ) if 'default' eq $rtn->{tmpl};

			# when done, close the connection
			done;

			# do whatever you want else, asynchronously
			# the user socket closed by now
		};
		return;
	}


	my $out = img_render( tmpl_args => $rtn->{tmpl_args}, request => request, part => 'page_top' ) if 'default' eq $rtn->{tmpl};

	# need to get the stuff from %$prep_args
	#	tmpl
	#	tmpl_args

	# capture output and save it to $output
	my $output;
	$| = 1;

	local $@;
	eval {

		open local *STDOUT, ">", \$output or die "Could not open STDOUT: $!";

		$rtn->{sub_to_run}->( );

		close local *STDOUT;

	};

	die $@ if $@;

	$out .= $output;

	$out .= img_render( tmpl_args => $rtn->{tmpl_args}, request => request, part => 'page_bottom' ) if 'default' eq $rtn->{tmpl};

	template "pages/any_content.tt", { title => $rtn->{tmpl_args}{title}, tmpl_includes => $tmpl_inc, content => $output };

	return;
#	return $out;

#	return { %$prep_args, sub_to_run => $sub_to_run };

};


any '/main.cgi' => sub {
	# home pages
	my $tmpl_args = get_tmpl_vars();

	img_render( tmpl_args => $tmpl_args, request => request );

	return;

};


any '/inner.cgi' => sub {

	return 'Called the inner cgi!';

};

ajax '/xml.cgi' => sub {

	require XMLProxy;
	return XMLProxy->run( params => request->parameters, config => config );
#	return 'Called xml.cgi!';

};

ajax '/json_proxy.cgi' => sub {

	require JSONProxy;
	# args: hash of parameters

	my $result = JSONProxy->run( params => request->parameters, config => config );

	if ( $result ) {
		# JSON header
		content_type 'application/json';
		return to_json $result;
	}
#	return 'Called json_proxy.cgi!';
};


1;
