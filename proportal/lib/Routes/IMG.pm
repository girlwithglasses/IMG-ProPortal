package Routes::IMG;
use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;

# use IMG::App::Role::Dispatcher;
# use IMG::Views::ViewMaker;
use Filter::Handle qw( Filter UnFilter subs ) ;
use CGI::Emulate::PSGI;

prefix '/cgi-bin' => sub {

	any '/main.cgi?**' => sub {

		my $rtn = img_app->prepare_dispatch({
			'session' => session,
			'request' => request
		});

		# get template variables
		img_app->current_query->_set_page_params({
			page_id => $rtn->{page_id},
			menu_group => $rtn->{tmpl_args}{current}
		});

# 	my @appArgs = $section->getAppHeaderData();
# 	my $numTaxons = printAppHeader(@appArgs) if $#appArgs > -1;
# 	$section->dispatch($numTaxons);

		my $output;
		{
			local $@;
			eval {
				open local *STDOUT, ">", \$output or die "Could not open STDOUT: $!";
				$rtn->{sub_to_run}->( );

				warn 'STDOUT: ' . $output;

#				close local *STDOUT;
#				close *STDOUT;
			};
			die $@ if $@;
		}

		template "pages/any_content", {
			title => $rtn->{tmpl_args}{title},
			tmpl_includes => $rtn->{tmpl_args},
			extra_javascript => $rtn->{extra_javascript} // '',
			page_head_img => 1,
			content => $output
		};


=cut
	my $n_taxa;
	my $core = setting('img_app');

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


#	any '/main.cgi' => sub {
		# home pages
# 		my $tmpl_args = get_tmpl_vars();
#
# 		img_render( tmpl_args => $tmpl_args, request => request );

#		return;

#	};

};

1;
