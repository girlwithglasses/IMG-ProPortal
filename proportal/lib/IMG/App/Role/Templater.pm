package IMG::App::Role::Templater;

use IMG::Util::Import 'MooRole';
#use IMG::App::Role::LinkManager;
use Template;
use Sys::Hostname;

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
    print $app->render_template({ tmpl => 'random_page.tt', tmpl_data => { title => 'Random Page', data => $data } });

    # save formatted data as a string:
    my $str = $app->render_template({ tmpl => 'my_tmpl.tt', tmpl_data => { fee => 'fi', fo => 'fum' } });


=head2 DESCRIPTION

Provides easy access to Template Toolkit via the render_template method, with built-in access to internal and external links and the application config.

=head3 render_template

Render a template using Template::Toolkit

takes hashref of parameters:

@param  tmpl      => $tmpl_name    name of the template to render
@param  tmpl_data => $data         data to render (hashref)


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
	my $args = shift;
	if ( ! $args->{tmpl} ) {
		$self->choke({
			err => 'missing',
			subject => 'template name'
		});
	}

	my $data = $args->{tmpl_data} // {};

    my $tmpl_args = ( $self->config && defined $self->config->{tmpl_args} )
    ? $self->config->{tmpl_args}
    : { INTERPOLATE => 1 };

    $tmpl_args->{INCLUDE_PATH} ||= ( $self->config && defined $self->config->{tmpl_dir} )
    ? $self->config->{tmpl_dir}
    : '';

	## ADDED TEMPORARILY ##
	$tmpl_args = $args->{tmpl_args};

	my $tt = Template->new( $tmpl_args ) || die "Template error: $Template::ERROR";

    # add in link generation
	$data->{settings} = $self->config;
	$data->{ext_link} = sub { return $self->get_ext_link( @_ ) };

# 	if ( $self->can('get_ext_link') ) {
# 		log_debug { 'Can get_ext_link' };
# 	} else {
# 		log_debug { 'Cannot get_ext_link' };
# 	}
# 	if ( $self->can('get_img_link_tt') ) {
# 		log_debug { 'can get_img_link_tt' };
# 	} else {
# 		log_debug { 'cannot get_img_link_tt' };
# 	}

#	$data->{link} = sub { return $self->get_img_link_tt( @_ ) };

	my $out;
	$tt->process( $args->{tmpl}, $data, \$out, $args->{extras} || {} ) || die $tt->error();
	return $out;
}


sub print_message {
	my $self = shift;
	my $message = shift;

	if ( ! $message ) {
		carp 'No message found';
	}
	else {
		return $self->render_template({ tmpl => 'message.tt', tmpl_data => $message });
	}
}

=head3 get_tmpl_vars

Default data to add to the templates

Adds external and internal links, plus navigation data.

@param  $args hashref with  keys
	core	IMG::App core
	output	(opt) data hash to add the defaults to

@return $args->{output} with added goodness

=cut

sub get_tmpl_vars {
	my $self = shift;
	my $args = shift;
	my $output = $args->{output};
#	my $core = $args->{core};

	$output->{link} = sub { return $self->img_link_tt( @_ ) };
	$output->{ext_link} = sub { return $self->ext_link( @_ ) };
	$output->{web_safe_text} = sub { return $self->make_text_web_safe( @_ ) };

	$output->{img_app_config} = $self->config;
	$output->{server_name} = hostname;
	$output->{ora_service} = $ENV{ORA_SERVICE} || 'The Oracle is silent';
	$output->{breadcrumbs}++;
	$output->{copyright_year} = ( localtime(time) )[5] + 1900;

#	$output->{img_cfg} = $core->img_cfg;
	return $output;
}

1;
