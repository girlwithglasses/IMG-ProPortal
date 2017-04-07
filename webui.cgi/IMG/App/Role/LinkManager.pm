package IMG::App::Role::LinkManager;

use IMG::Util::Import 'MooRole';
use IMG::Views::Links;
use IMG::Views::ExternalLinks;
use utf8;

requires 'config';

has '_links_init' => ( is => 'lazy' );

sub _build__links_init {
    my $self = shift;
    IMG::Views::Links::init( $self->config );
    return 1;
}

#sub BUILD {
#    my $self = shift;
#    if ( ! $self->_links_init ) {
#        $self->_links_init( 1 );
#    }
#}


=pod

=encoding UTF-8

=head1 NAME

IMG::App::Role::LinkManager - role providing an internal link manager for IMG pages

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use IMG::App;

    my $cfg = { # hash of environment variables, e.g. from getEnv };
    my $app = IMG::App->new( config => $cfg );

    my $url = $app->img_link({ id => 'MyIMG/preferences' });
    print $url;
    # http://example.com/cgi-bin/main.cgi?section=MyIMG&amp;page=preferences

=head1 DESCRIPTION

This module manages links for pages within IMG.

=cut

=head3 ext_link

Get an external link. See IMG::Views::ExternalLinks::get_external_link for details;
use IMG::Views::ExternalLinks directly for a function-oriented interface.

=cut

sub ext_link {
	my $self = shift;
	return IMG::Views::ExternalLinks::get_external_link( @_ );
}

=head3 link_data

Given an ID for a static page, fetch the data for creating the link. Data
includes parameters for constructing the link and the label for the link.

@param  $self
@param  $l      the ID for the page

@return $link_h     hashref of data for the link, including url and label

=cut


sub link_data {
	my $self = shift;
	return IMG::Views::Links::get_link_data( @_ );
}

=head3 img_link

Get a link from the library. See img_link_tt for the Template Toolkit wrapper.

@param  $arg_h  hashref of arguments, including the following
		id => $id           the link identifier (e.g. a page ID or link type)
		style => 'old' | 'new'  link style -- defaults to 'old' -- main.cgi?x=y
		params => { }     link parameters (e.g. taxon_oid=1234567)

@return $url_string

=cut

sub img_link {
	my $self = shift;
	$self->_links_init(1) unless $self->_links_init;
    return IMG::Views::Links::get_img_link( @_ );
}

=head3 img_link_tt

Template Toolkit wrapper for getting an IMG link, allowing a simpler syntax to be used

To use in a template, specify the link ID as the first argument, and any extra parameters as the second. For example:

[% link( 'MyIMG/preferences' ) %]

# http://example.com/cgi-bin/main.cgi?section=MyIMG&amp;page=preferences

[% link( 'details', { domain => 'taxon', taxon_oid => 1234567 } %]

# http://example.com/cgi-bin/main.cgi?section=TaxonDetail&amp;page=taxonDetail&taxon_oid=1234567

=cut

sub img_link_tt {
	my $self = shift;
	$self->_links_init(1) unless $self->_links_init;
	return IMG::Views::Links::get_img_link_tt( @_ );
}

1;
