############################################################################
#	IMG::App.pm
#
#	Core IMG application to run pre-flight checks, check the user, initiate
#	the session, parse params, and dispatch the appropriate app. This module
#	is basically the container for all the functionality
#
#	$Id: App.pm 37114 2017-05-30 14:14:14Z aireland $
############################################################################
package IMG::App;

use IMG::Util::Import 'Class';

our $VERSION = 0.1.0;

#use IMG::Model::Contact;

extends 'IMG::App::Core';       # config
                                # http_params, cgi, psgi_env (to be deprecated)
with
	'IMG::App::Role::HttpClient',      # http_ua
	'IMG::App::Role::Session',         # session -- already handled by Dancer session?
	'IMG::App::Role::PreFlight',       # remote_addr, user_agent (both to be deprecated)
	'IMG::App::Role::DbConnection',    # db_connection_h
	'IMG::App::Role::JGISessionClient',
	'IMG::App::Role::ErrorMessages',   # standard error messages
#	'IMG::App::Cache',                 # to write!
	'IMG::App::Role::Dispatcher',
	'IMG::App::Role::User',            # user
	'IMG::App::Role::UserChecks',
	'IMG::App::Role::FileManager',
	'IMG::App::Role::LinkManager',
	'IMG::App::Role::Schema',          # schema_h

	'IMG::App::Role::Templater' # template stuff
	;

#	'IMG::App::Role::MenuManager',     # menu manager: only needed for web output
#	'IMG::App::Role::Controller',      # web query controller


sub BUILDARGS {
	my $class = shift;
	my $args = ( @_ && scalar( @_ ) > 1 ) ? { @_ } : shift || {};

	# coerce from dancer
	if ( $args->{dancer_config} ) {
		log_debug { 'Coercing from dancer config!' };
		$args->{img_config} = delete $args->{dancer_config}{plugins}{Adapter}{img_app}{options}{config};
		delete $args->{dancer_config}{plugins};
		$args->{config} = { %{$args->{dancer_config}}, %{$args->{img_config}} };
	}

	if ( ! $args->{config} ) {
		log_error { 'No config found!' };
	}

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
