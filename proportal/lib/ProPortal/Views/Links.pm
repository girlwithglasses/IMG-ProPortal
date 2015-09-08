package ProPortal::Views::Links;

use IMG::Util::Base;
use Role::Tiny;

=head3 proportal_links

Construct links for ProPortal pages

Takes the list of active components or a default set of components

@param  $config         configuration hash for the application

@output $links          hash of link templates

=cut

sub proportal_links {

	my $config = shift // croak __PACKAGE__ . ' ' . (caller(0))[3] . " requires a configuration hash for URL generation";

#	say "config pp_app: " . $config->{pp_app};

	if (! ref $config || ref $config ne 'HASH' || ! $config->{pp_app} ) {
		croak __PACKAGE__ . ' ' . (caller(0))[3]
		. " requires a configuration hash for URL generation";
	}

	my $active = $config->{active_components} // [ qw( location clade data_type ) ];

	my %links;

	@links{ @$active } = map { $config->{pp_app} . $_ . "/" } @$active;

	return \%links;

}

=head3 img_links

Construct templates for internal (ProPortal) links

@param  $config         configuration for the application
@param  $style  (opt)   the link style to construct. Will use the old school
                        param=value form unless specified otherwise
                        currently-valid values: 'new'

@output $output         hash of link templates

=cut

# links required: news

sub img_links {
	my $config = shift // croak __PACKAGE__ . ' ' . (caller(0))[3] . " requires a configuration hash for URL generation";
	my $style = shift || 'old';

	if (! ref $config || ref $config ne 'HASH' || ! $config->{main_cgi_url} ) {
		croak __PACKAGE__ . ' ' . (caller(0))[3]
		. " requires a configuration hash for URL generation";
	}


	my $base = {
		old => $config->{main_cgi_url},
#		new => $config->{pp_app},
	};

	my $links = {
		taxon => {
			section => 'TaxonDetail',
			page => 'taxonDetail',
			taxon_oid => ''
		},
		genome_list => {
			section => 'ProPortal',
			page => 'genomeList',
			class => '',
		},
		genome_list_ecosystem => {
			section => 'ProPortal',
			page => 'genomeList',
			class => 'marine_metagenome',
			ecosystem_subtype => ''
		},
		genome_list_clade => {
			section => 'ProPortal',
			page => 'genomeList',
			metadata_col => 'p.clade',
			clade => ''
		},
	};


	my $params = [ qw( section page class taxon_oid ecosystem_subtype metadata_col clade ) ];

	my $link_gen = {
		# new skool /section/page/class style
		'new' => sub {
			my $l_hash = shift;
			return join "", map { "/" . ( $l_hash->{$_} || "" ) } grep { exists $l_hash->{$_} } @$params;
		},

		# this constructs URLs in the old skool arg1=val1&arg2=val2 style
		'old' => sub {
			my $l_hash = shift;
			return
				$base->{old} . "?" . join "&amp;",
					map { $_ . "=" . ( $l_hash->{$_} || "" ) }
					grep { exists $l_hash->{$_} } @$params;
		}
	};

	if (! $link_gen->{$style}) {
		$style = 'old';
	}

	my %output;

	@output{ keys %$links } = map {
		$link_gen->{ $style }->( $_ );
	} values %$links;

	return \%output;
}

=head3 external_links

External links

=cut

sub external_links {

	return {

		'sso_api_url' => 'https://signon.jgi-psf.org/api/sessions/',
		'sso_url' => 'https://signon.jgi-psf.org',
		'sso_user_info_url' => 'https://signon.jgi-psf.org/api/users/',

		doi => 'http://dx.doi.org/',
		pubmed => 'http://www.ncbi.nlm.nih.gov/pubmed/',
	}
}


1;
