package ProPortal::Controller::Base;

use IMG::Util::Import 'Class';
with 'IMG::App::Role::ErrorMessages';
#'ProPortal::Controller::Role::OutputFormat';

=head3 _core

Reference to the core IMG::App object and methods

=cut

has '_core' => (
	is => 'rw',
	lazy => 1,
#	is => 'ro',
	weak_ref => 1
);

=head3 page_id

the ID of the page, as referenced in Links.pm and MenuManager.pm

=cut

has 'page_id' => (
	is => 'lazy'
);

sub _build_page_id {
	my $self = shift;
	$self->choke({
		err => 'missing',
		subject => 'page_id'
	});
}


=head3 page_group

The group under which the page appears in the menu structure

=cut

has 'page_group' => (
	is => 'rwp',
	lazy => 1,
	default => ''
);


=head3 page_wrapper

the layout template for the page

=cut

has 'page_wrapper' => (
	is => 'lazy',
	default => 'layouts/default.tt'
);

=head3 tmpl

template to use for rendering the page

=cut

has 'tmpl' => (
	is => 'lazy'
);

sub _build_tmpl {
	my $self = shift;
	return 'pages/' . $self->page_id . '.tt';
# 	$self->choke({
# 		err => 'missing',
# 		subject => 'template name'
# 	});
}

=head3 tmpl_includes

templates to include in the page

=cut

has 'tmpl_includes' => (
	is => 'lazy',
	default => sub { return {}; }
);


=head3 render

Calls _render in the controller.

Slight hack to ensure that the tmpl_includes and page_wrapper get added to the results.

@return   $output  -- results data structure; see docs/Docs.md for details

=cut

sub render {
	my $self = shift;

	my $output = $self->_render(@_);
	for ( qw( tmpl_includes page_wrapper page_id ) ) {
		if ( $self->$_ ) {
			$output->{$_} = $self->$_;
		}
	}
	return $output;
}


1;
