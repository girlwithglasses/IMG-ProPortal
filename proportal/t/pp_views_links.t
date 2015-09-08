#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use ProPortal;
use ProPortal::Controller::Base;

my $module = "ProPortal::Controller::Base";

use_ok( 'ProPortal::Views::Links' );

my $c = ProPortal::bootstrap;

isa_ok( $c, $module );

# test failure: we need arguments!
subtest 'no_args' => sub {

	like(
		exception { my $x = ProPortal::Views::Links::proportal_links; },
		qr{requires a configuration hash for URL generation},
		'Croaks without arguments'
	);

	like(
		exception { my $x = ProPortal::Views::Links::img_links; },
		qr{requires a configuration hash for URL generation},
		'Croaks without arguments'
	);


};


# testing link generation
subtest 'proportal_links' => sub {

	my $links = ProPortal::Views::Links::proportal_links( $c->config );
#	my $links = $c->proportal_links;

	ok( exists $links->{clade} && exists $links->{location} && exists $links->{data_type } );

	ok( $c->config->{pp_app} . 'clade/' eq $links->{clade} );

};


my $new_fmt = ProPortal::Views::Links::img_links( $c->config, 'new' );

ok( $new_fmt->{taxon} eq '/TaxonDetail/taxonDetail/', "$module _links: taxon, new style" );

ok( $new_fmt->{genome_list} eq '/ProPortal/genomeList/', "$module _links: genome list, new style" );

ok( $new_fmt->{genome_list_ecosystem} eq '/ProPortal/genomeList/marine_metagenome/', "$module _links: ecosyst, new style" );

my $old_fmt = ProPortal::Views::Links::img_links( $c->config );

ok( $old_fmt->{genome_list} eq $c->config->{main_cgi_url} . '?section=ProPortal&amp;page=genomeList&amp;class=', "$module _links: genome list, old style" );

$old_fmt = ProPortal::Views::Links::img_links( $c->config, 'invalid');

ok( $old_fmt->{taxon} eq  $c->config->{main_cgi_url} . '?section=TaxonDetail&amp;page=taxonDetail&amp;taxon_oid=', "$module _links: taxon details, old style" );

ok( $old_fmt->{genome_list_ecosystem} eq $c->config->{main_cgi_url} . '?section=ProPortal&amp;page=genomeList&amp;class=marine_metagenome&amp;ecosystem_subtype=', "$module _links: ecosys, old style");




done_testing();
