package IMG::App::Role::Templater;

use IMG::Util::Base 'MooRole';
#use IMG::App::Role::LinkManager;
use Template;

requires 'ext_link', 'img_link_tt';

=pod

=encoding UTF-8

=head1 NAME

IMG::App::Role::Templater

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::App;

    my %args = (
        tmpl_dir => '/path/to/tmpl/dir:/path/to/another/tmpl/dir',
        base_url => 'http://server.com',
    );
    my $app = IMG::App->new( %args );

    # print out a data using a template:
    print $app->render_template( 'random_page.tt', { title => 'Random Page', data => $data } );

    # save formatted data as a string:
    my $str = $app->render_template( 'my_tmpl.tt', { fee => 'fi', fo => 'fum' } );


=head2 DESCRIPTION

Provides easy access to Template Toolkit via the render_template method, with built-in access to internal and external links and the application config.

=head3 render_template

Render a template using Template::Toolkit

@param  $tmpl_name      name of the template to render
@param  $data           hashref of data to render


The config parameter 'tmpl_args' is used to set the template arguments. If there is no INCLUDE_PATH specified, the config parameter tmpl_dir (if set) will be used as the INCLUDE_PATH. See the Template::Toolkit documentation for configuration details.

The following data is also added to each template:

    settings -- the configuration hash
    ext_link -- function to create external links
    link     -- function to create internal links
        (both functions use IMG::Views::Links)

Returns the output string if successful
Dies with an error if there is an issue

=cut

sub render_template {
    my $self = shift;
	my $tmpl_name = shift || die "No template name specified!";
	my $data = shift // {};

    my $tmpl_args = ( $self->config && defined $self->config->{tmpl_args} )
    ? $self->config->{tmpl_args}
    : {};

    $tmpl_args->{INCLUDE_PATH} ||= ( $self->config && defined $self->config->{tmpl_dir} )
    ? $self->config->{tmpl_dir}
    : '';

	my $tt = Template->new( $tmpl_args ) || die "Template error: $Template::ERROR\n";

    # add in link generation
	$data->{settings} = $self->config;
	$data->{ext_link} = sub { return $self->get_ext_link( @_ ) };
	$data->{link} = sub { return $self->get_img_link_tt( @_ ) };

	my $out;
	$tt->process($tmpl_name, $data, \$out) || die $tt->error() . "\n";
	return $out;
}


sub print_message {
	my $self = shift;
	my $message = shift;

	if ( ! $message ) {
		carp 'No message found';
	}
	else {
		return $self->render_template( 'message.tt', $message );
	}
#	print "<div id='message'>\n";
#	print "<p>\n";
#	print escapeHTML( $message );
#	print "</p>\n";
#	print "</div>\n";
}

1;
