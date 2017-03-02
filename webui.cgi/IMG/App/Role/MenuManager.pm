package IMG::App::Role::MenuManager;

use IMG::Util::Import 'MooRole';

with 'IMG::App::Role::LinkManager';

requires 'link_data', 'config';

=pod

=encoding UTF-8

=head1 NAME

IMG::App::Role::MenuManager - role conferring basic navigation-related functionality

=head1 VERSION

version 0.01

=head1 SYNOPSIS

	# given the application config, a page ID, and optionally a menu group, create a menu data structure to be rendered by menu.tt, nav.tt, and breadcrumbs.tt.

	my $menu = $self->make_menu( $config, $menu_grp, $page_id );

=head1 DESCRIPTION

IMG::App::Role::Menu, IMG::App::Role::menu links for a page.

Menus are stored as nested arrays of IDs or hashes representing pages.

=head3 make_menu

Get the page menus

@param  $self
@param  $menu_grp - the submenu to display in the left-hand nav -- optional
@param  $page_id  - the current page ID -- optional

@output menu data structure -- nested arrays of hashrefs populated with link data

=cut

sub make_menu {
	my $self = shift;
	my $args = shift;

	my $menu_grp = $args->{group} || undef;
	my $page_id = $args->{page} || undef;

	say 'Looking for group ' . ( $menu_grp || 'undefined' ) . ' and page ' . ( $page_id || 'undefined' );

	# if the ID is not defined, return the default menu
#	if ( not defined $page_id ) {
#		warn "page ID is not defined: group was " . Dumper $menu_grp;
#		return make_menus( undef, $menu_grp, $page_id );
#	}

	# translate the menu group if necessary
	if ( defined $menu_grp ) {
		$menu_grp = $self->_get_group( $menu_grp, $page_id );
	}

	# get the menu data structures and populate the links
	my $menu_ds = $self->get_menu_items();


	my $fn = sub {
		my $l = shift;
		my $rtn;
		if ( $menu_grp && $menu_grp eq $l->{id} ) {
#			say 'MATCH! Group matches ' . $l->{id};
			$l->{class} = 'parent';
			$rtn++;
		}
		if ( $page_id && $page_id eq $l->{id} ) {
#			say 'MATCH! page ID matches ' . $l->{id};
			$l->{class} = 'current';
			$rtn++;
		}
		return $rtn;
	};

	$self->populate_links( $menu_ds, $fn );

	return {
		menu => $menu_ds,
		page => $page_id,
		group => $menu_grp
	};

}

=head3 populate_links

Iterate through a menu structure, adding links as necessary

@param  $data_struct    menu data structure (e.g. from get_menu_items() )

@param  $fn             callback to execute on each item (optional)

@return

=cut

sub populate_links {
	my $self = shift;
	my ( $data_struct, $fn ) = @_;
	$fn = sub {} unless defined $fn;

	my $match;
	if ( ! ref $data_struct || 'HASH' eq ref $data_struct ) {
		$data_struct = [ $data_struct ];
	}

	if ('ARRAY' eq ref $data_struct) {
		for my $i ( @$data_struct ) {
			# scalar: replace with id
			if ( ! ref $i ) {
				$i = { id => $i };
			}

			if ( 'HASH' eq ref $i ) {
				if ( defined $i->{submenu} && $self->populate_links( $i->{submenu}, $fn ) ) {
					$i->{class} = 'parent';
					$match++;
				}
				if ( $i->{id} ) {
					# NB: copy the link data, don't just use the reference!
					my $data = $self->link_data( $i->{id} );
					for ( keys %$data ) {
						$i->{$_} = $data->{$_};
					}
					$match++ if $fn->( $i );
				}
			}
		}
	}
	return $match;
}

=head3 search_menu

Search for a page ID in a menu, and return the section of the menu that comprises the page and any children it may have.

@param  $id     page id

@return $rslt   data structure representing the page and its children (if appropriate)

=cut

sub search_menu {
	my $self = shift;
	my $id = shift // $self->choke({ err => 'missing', subject => 'page ID' });
	my $menus = $self->get_menu_items();
	my $rslt = $self->_get_subtree( $menus, $id );
	if ( $rslt ) {
		$self->populate_links( $rslt );
	}
	return $rslt;
}

=head3 find_parent_menu

Find out which top-level menu a page is under. Requires a page ID (and for
that page to be in the menu!)

@param  $id    - page ID (see Links.pm for valid page IDs)

@return $menu  - data structure to represent the menu that contains the page
                 returns nothing if there is no match

=cut

sub find_parent_menu {
	my $self = shift;
	my $id = shift // $self->choke({ err => 'missing', subject => 'page ID' });
#	say 'Looking for ' . $id;
	my $menus = $self->get_menu_items();
	for my $m ( @$menus ) {
		my $rslt = $self->_get_subtree( [ $m ], $id );
		if ( $rslt ) {
			$self->populate_links( $m );
			return $m;
		}
	}
	return undef;
}

=head3 _get_group

Find out which menu group a page belongs to. This may be known in advance, e.g.
by pages coming from the dispatcher, where the relevant group is in the mapping
table $mapping. If unknown, the page ID is examined for potential matches.

@param   $menu_grp - the current group (if defined)
@param   $page_id  - page ID

@return  $group

=cut

sub _get_group {
	my $self = shift;
	my $menu_grp = shift;
	my $page_id = shift;

#	say 'menu_grp: >>' . ( $menu_grp // 'undefined' ) . '<<';

	my $mapping = {
		FindGenomes    => 'menu/FindGenomes',
		FindGenes      => 'menu/FindGenes',
		FindFunctions  => 'menu/FindFunctions',
		CompareGenomes => 'menu/CompareGenomes',
		AnaCart        => 'menu/MyIMG',
		MyIMG          => 'menu/MyIMG',
		Methylomics    => 'menu/omics',
		about          => 'menu/UsingIMG',
		'/proportal'   => 'proportal',
		proportal      => 'proportal',
	};

	if ( defined $menu_grp && $mapping->{ $menu_grp } ) {
#		say 'We definitely have this one!';
		return $mapping->{ $menu_grp };
	}
#	else {
#		if ( defined $page_id && $page_id =~ m!menu/! ) {
#			return find_parent_menu( $page_id );
#		}
#	}
#	say 'Not mapped or a menu item. Hmmmm!';
	return;
#	return home();

}


sub _get_subtree {
	my $self = shift;
	my $struct = shift;

#	say 'struct: ' . Dumper $struct;

	my $menu_page = shift;
	if ( ref $struct && 'ARRAY' eq ref $struct ) {
		for ( @$struct ) {
			say 'Looking at ' . $_;
			if ( ! ref $_ ) {
				if ( $menu_page eq $_ ) {
#					say __SUB__ . ': found the thing I was looking for!';
					# need to populate these links!
					return $_;
				}
			}
			else {
				if ( $_->{id} && $menu_page eq $_->{id} ) {
#					say __SUB__ . ': found the thing I was looking for!';
					return $_;
				}
				my $results = $self->_get_subtree( $_->{submenu}, $menu_page ) if $_->{submenu};
				return $results if $results;
			}
		}
	}
	return undef;
}



=head3 get_menu_items {

Returns a data structure representing the menu. This structure should be provided by a site-specific role via the method _get_menu_items

=cut

# requires '_get_menu_items';

sub get_menu_items {

	my $self = shift;

	if ( ! $self->can( '_get_menu_items' ) ) {
		die ref ( $self ) . ' is missing required method _get_menu_items';
	}

	return $self->_get_menu_items( @_ );

}


=head3 init

Initialise local URL-generating variables

@param   $config  - configuration hash (e.g. from WebConfig or DancerApp->config

sub init {
	my $config = shift // confess "init requires a configuration hash for URL generation";

	if (! ref $config || ref $config ne 'HASH' || ! $config->{main_cgi_url} ) {
		confess "init requires a configuration hash for URL generation";
	}
	for my $v ( qw( main_cgi_url server base_url ) ) {
		$url->{$v} = $config->{$v} if defined $config->{$v};
	}
	$url->{init_run} = 1;
	return;
}

=cut



1;
