package Routes::IMG;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
use IMG::App::Dispatcher;
# use IMG::Views::ViewMaker;
use Filter::Handle qw( Filter UnFilter) ;
our $VERSION = '0.1';

any '/launch' => sub {
	return '3... 2... 1... blast off!';
};

# menu pages


prefix '/cgi-bin';

any '/main.cgi?**' => sub {

	my $rtn = prep_parse_params( request );
	# get template variables
	var current => $rtn->{tmpl_args}{current};
	var page => $rtn->{tmpl_args}{module};

	my $tmpl_inc;

	for my $x ( 'yui_js', 'scripts' ) {
		if ( $rtn->{tmpl_args}{ $x } ) {
			push @{$tmpl_inc->{scripts}}, $rtn->{tmpl_args}{ $x };
		}
	}

	if ( $rtn->{tmpl_args}{ include_styles} ) {
		push @{$tmpl_inc->{styles}}, $rtn->{tmpl_args}{include_styles};
	}

	template "pages/any_content", {
		title => $rtn->{tmpl_args}{title},
		tmpl_includes => $tmpl_inc,
		content => $rtn
	};

=cut
	my $n_taxa;
	my $core = setting('_core');

	if ( config->{async} ) {


		delayed {

#			add_header 'X-Foo' => 'Bar';

			# optionally flush headers
			flush;

			# print top of the page
			content img_render( tmpl_args => $rtn->{tmpl_args}, request => request, part => 'page_top' ) if 'default' eq $rtn->{tmpl};

			# you can write more content
			# all streaming
			Filter \*STDOUT, sub { content @_; };

#			my $output;
#			local $@;
#			eval {
#				open local *STDOUT, ">", \$output or die "Could not open STDOUT: $!";

				$rtn->{sub_to_run}->( );

#				close local *STDOUT;
#
#			};
#			die $@ if $@;
			UnFilter \*STDOUT;

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

	return;
#	return $out;

#	return { %$prep_args, sub_to_run => $sub_to_run };
=cut

};


any '/main.cgi' => sub {
	# home pages
	my $tmpl_args = get_tmpl_vars();

	img_render( tmpl_args => $tmpl_args, request => request );

	return;

};


1;
