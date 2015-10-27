############################################################################
#	IMG::App.pm
#
#	Core IMG application to run pre-flight checks, check the user, initiate
#	the session, parse params, and dispatch the appropriate app.
#
#	$Id: App.pm 34542 2015-10-20 20:56:35Z aireland $
############################################################################
package IMG::App;

use IMG::Util::Base 'Class';

our $VERSION = 0.01;

extends 'IMG::App::Core';       # config
                                # http_params, cgi, psgi_env (to be deprecated)

with
	'IMG::App::Role::HttpClient',     # http_ua
	'IMG::App::Role::Session',        # session
	'IMG::App::Role::PreFlight',      # remote_addr, user_agent (both to be deprecated)
	'IMG::App::Role::DbConnection',    # db_connection_h
	'IMG::App::Role::JGISessionClient',
#   'IMG::App::Cache',          # to write!
#	'IMG::App::Logger',         # to write!
	'IMG::App::Role::User',           # user
	'IMG::App::Role::UserChecks',
	'IMG::App::Role::FileManager',
    'IMG::App::Role::LinkManager',
    'IMG::App::Role::MenuManager',
	'IMG::App::Role::Schema';              # schema_h

sub BUILDARGS {
	my $class = shift;
	my $args = ( @_ && scalar( @_ ) > 1 ) ? { @_ } : shift || {};
	return $args;
}


=cut
sub taxon_stuff {
	my $self = shift;
	# for adding to genome cart from browser list
	if ( param('setTaxonFilter') ) {
		my @taxon_filter_oid = param('taxon_filter_oid');
		if ( 0 == scalar(@taxon_filter_oid) ) {
			@taxon_filter_oid = param('taxon_oid');
		}
		if ( 0 < scalar(@taxon_filter_oid) ) {
			my %uniq;
			undef @uniq{ @taxon_filter_oid };
			my $taxon_filter_oid_str = join ",", sort keys %uniq;

	#		setTaxonSelections($taxon_filter_oid_str);
			GenomeCart::addToGenomeCart( [ keys %uniq ] );
			$self->session->write('blank_taxon_filter_oid_str' => 0);

#=cut
			require GenomeList;
			GenomeList::clearCache();

			# this must before  the "} elsif (exists $validSections{ $section}) { "
			# s.t. the genome cart is display after the usr presses add to genome cart
			#
			# add to genome cart - ken

			require GenomeCart;
			$pageTitle = "Genome Cart";
			setSessionParam( "lastCart", "genomeCart" );
			printAppHeader("AnaCart");
			GenomeCart::dispatch();
#=cut
		}
	}

	if ( param("deleteAllCartGenes") ) {
		$self->session->write('gene_cart_oid_str' => '');
	}
}
=cut


1;
