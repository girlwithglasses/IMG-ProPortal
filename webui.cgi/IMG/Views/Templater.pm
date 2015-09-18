package IMG::Views::Templater;

use IMG::Util::Base;

use Template;
use WebConfig qw();

my $env;

=pod

=encoding UTF-8

=head1 NAME

IMG::Views::Templater

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::Views::Templater;

=cut

sub init_env {
	my $temp_env = shift;
	if ( not defined $temp_env ) {
		$temp_env = WebConfig::getEnv();
	}
	die 'environment should be a hash!' unless ref $temp_env && 'HASH' eq ref $temp_env;
	$env = $temp_env;
}

=head3 render_template

Render a template using Template::Toolkit

@param  $tmpl_name      name of the template to render
@param  $data           hashref of data to render

Returns the output string if successful
Dies with an error if there is an issue

=cut

sub render_template {

	my $tmpl_name = shift || die "No template name specified!";
	my $data = shift // {};

	init_env() unless defined $env;

	say 'Base dir: ' . $env->{base_dir};

	my $tt = Template->new({
		INCLUDE_PATH =>  [
			$env->{base_dir} . "/views",
			$env->{base_dir} . "/views/pages",
			$env->{base_dir} . "/views/layouts",
			$env->{base_dir} . "/views/inc"
		],
	}) || die "Template error: $Template::ERROR\n";

	$data->{cfg} = $env;
	my $out;
	$tt->process($tmpl_name, $data, \$out) || die $tt->error() . "\n";
	return $out;
}




sub print_message {

#	my $self = shift;
	my $message = shift;

	if ( ! $message ) {
		carp 'No message found';
	}
	else {
		render_template( 'message.tt', $message );
	}
	return;
#	print "<div id='message'>\n";
#	print "<p>\n";
#	print escapeHTML( $message );
#	print "</p>\n";
#	print "</div>\n";
}

1;
