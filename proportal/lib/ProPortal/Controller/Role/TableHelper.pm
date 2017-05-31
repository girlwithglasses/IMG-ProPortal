package ProPortal::Controller::Role::TableHelper;

use IMG::Util::Import 'MooRole';

my $transforms = {

	gene_oid => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'gene', gene_oid => $x->{gene_oid} },
			text => $x->{gene_oid}
		};
	},

	gene_display_name => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'gene', gene_oid => $x->{gene_oid} },
			text => $x->{gene_display_name}
		};
	},

	scaffold_oid => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'scaffold', scaffold_oid => $x->{scaffold_oid} },
			text => $x->{scaffold_oid}
		};
	},

	scaffold_name => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'scaffold', scaffold_oid => $x->{scaffold_oid} },
			text => $x->{scaffold_name}
		};
	},

	taxon_oid => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
			text => $x->{taxon_oid}
		};
	},

	taxon_display_name => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			type => 'details',
			params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
			text => $x->{taxon_display_name}
		};
	},

	scaffold_dbxref => sub {
		my $x = shift;
		if ( $x->{db_source} && $x->{ext_accession} ) {
			return {
				macro => 'external_link',
				db => $x->{db_source},
				xref => $x->{ext_accession}
			};
		}
	},

# 	cycog_id => sub {
# 		my $x = shift;
# 		return {
# 			macro => 'generic_link',
# 			text => 'CyCOG:' . $x->{id} || $x->{xref},
# 			type => 'fn_details',
# 			params => { db => 'cycog', xref => $x->{id} || $x->{xref} }
# 		};
# 	},
# 	cycog_description => sub {
# 		my $x = shift;
# 		return {
# 			macro => 'generic_link',
# 			text => $x->{description},
# 			type => 'fn_details',
# 			params => { db => 'cycog', xref => $x->{id} }
# 		};
# 	},
	cycog_version => sub {
		my $x = shift;
		return {
			macro => 'generic_link',
			text => 'v' . $x->{version},
			type => 'details',
			params => { cycog_version => $x->{version} }
		};
	},
	pp_subset => sub {
		my $x = shift;
		return {
			macro => 'labeller',
			macro_args => $x->{pp_subset}
		};
	},
	dataset_type => sub {
		my $x = shift;
		return {
			macro => 'labeller',
			macro_args => $x->{dataset_type}
		};
	}
};


my $table = {

# Gene table
#
# cols checkbox, gene_oid, gene_didsplay_name, taxon

	gene => {
		thead => {
			enum => [ qw(
				cbox
				gene_oid
				gene_symbol
				gene_display_name
				product_name
				description
				scaffold_name
				taxon_display_name
				pp_subset
			)],
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					id => 'cbox_' . $x->{gene_oid},
					name => "gene_oid[]",
					value => $x->{gene_oid},
				};
			},
			gene_oid => $transforms->{gene_oid},
			gene_display_name => $transforms->{gene_display_name},
			scaffold_name => $transforms->{scaffold_name},
			taxon_display_name => $transforms->{taxon_display_name}
		}
	},

#	Taxon table
#
#	checkbox, taxon ID, taxon name, dataset type, proportal subset
	taxon => {
		thead => {
			enum => [qw( cbox taxon_oid taxon_display_name dataset_type pp_subset )],
		},
		transform => {
			cbox => sub {
				log_debug { 'running cbox with @_ = ' . Dumper Dumper \@_ };
				my $x = shift;
#				return $x;
				return {
					macro => 'checkbox',
					id => 'cbox_' . $x->{taxon_oid},
					name => 'taxon_oid[]',
					value => $x->{taxon_oid}
				};
			},
			taxon_oid => $transforms->{taxon_oid},
			taxon_display_name => $transforms->{taxon_display_name}
		},
	},



#	Function table
#
#	checkbox, function ID, function name, ...
	cycog => {
		thead => {
			enum => [ qw( cbox id description version cluster_size unique_taxa duplication_events ) ],
			enum_map => {
				id => 'CyCOG ID',
				version => 'CyCOG version',
			}
		},
		transform => {
# 			cbox => sub {
# 				my $x = shift;
# 				log_debug { $x };
# 				return {
# 					macro => 'checkbox',
# 					id => 'cbox_' . $x->{xref},
# 					name => "id[]",
# 					value => $x->{xref},
# 				};
# 			},
			id => $transforms->{cycog_id},
			description => $transforms->{cycog_description},
			version => $transforms->{cycog_version}
		}
	},

#	Scaffold table
#
#	checkbox, scaffold ID, scaffold name, taxon
	scaffold => {
		thead => {
			enum => [ 'cbox', 'scaffold_oid', 'scaffold_name', 'scaffold_dbxref', 'taxon' ],
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					id => 'cbox_' . $x->{scaffold_oid},
					name => "scaffold_oid[]",
					value => $x->{scaffold_oid},
				};
			},
			scaffold_oid => $transforms->{scaffold_oid},
			scaffold_name => $transforms->{scaffold_name},
			taxon => $transforms->{taxon_display_name},
			scaffold_dbxref => $transforms->{scaffold_dbxref}
		}
	},

};

sub get_table {
	my $self = shift;
	my $t_type = shift;
	return $table->{ $t_type } || $self->choke({
		err => 'missing',
		subject => $t_type
	});
}

1;
