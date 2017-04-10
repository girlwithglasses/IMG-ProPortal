package ProPortal::Controller::Role::TableHelper;

use IMG::Util::Import 'MooRole';

my $table = {

# Gene table
#
# cols checkbox, gene_oid, gene_didsplay_name, taxon

	gene => {
		thead => {
			enum => [ 'cbox', 'gene_oid', 'gene_display_name', 'taxon_oid' ],
			enum_map => {
				gene_oid => 'Gene ID',
				gene_display_name => 'Gene Name',
				taxon_oid => 'Taxon'
			}
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					name => "gene_oid[]",
					value => $x->{gene_oid},
					id => 'cbox_' . $x->{gene_oid}
				};
			},
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
			taxon_oid => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
					text => $x->{taxon_display_name}
				};
			}
		}
	},

#	Taxon table
#
#	checkbox, taxon ID, taxon name, dataset type, proportal subset
	taxon => {
		thead => {
			enum => [qw( cbox taxon_oid taxon_display_name dataset_type pp_subset )],
			enum_map => {
				taxon_oid => 'Taxon ID',
				taxon_display_name => 'Taxon display name',
				dataset_type => 'Dataset type',
				pp_subset => 'ProPortal subset'
			}
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
			}
		},
	},



#	Function table
#
#	checkbox, function ID, function name, ...
	cycog => {
		thead => {
			enum => [ 'cbox', 'cycog_oid', 'cycog_name', 'version' ],
			enum_map => {
				cycog_oid => 'CyCOG ID',
				cycog_name => 'CyCOG Name',
				version => 'CyCOG version'
			}
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					name => "cycog_oid[]",
					value => $x->{cycog_oid},
					id => 'cbox_' . $x->{cycog_oid}
				};
			},
			cycog_oid => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					text => $x->{cycog_oid},
					type => 'fn_details',
					params => { db => 'cycog', xref => $x->{cycog_oid} }
				};
			},
			cycog_name => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					text => $x->{name},
					type => 'fn_details',
					params => { db => 'cycog', xref => $x->{cycog_oid} }
				};
			},
		}
	},

#	Scaffold table
#
#	checkbox, scaffold ID, scaffold name, taxon
	scaffold => {
		thead => {
			enum => [ 'cbox', 'scaffold_oid', 'scaffold_name', 'taxon' ],
			enum_map => {
				scaffold_oid => 'Scaffold ID',
				scaffold_name => 'Scaffold Name',
				taxon => 'Taxon'
			}
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					name => "scaffold_oid[]",
					value => $x->{scaffold_oid},
					id => 'cbox_' . $x->{scaffold_oid}
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
			taxon => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
					text => $x->{taxon_display_name}
				};
			}
		}
	}

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