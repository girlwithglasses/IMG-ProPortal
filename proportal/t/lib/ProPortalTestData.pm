package ProPortalTestData;

use IMG::Util::Base 'Test';

use Acme::Damn;
use Scalar::Util qw[ blessed ];
use File::Temp qw[ tempfile ];
use TestUtils qw[ :all ];
use JSON qw[to_json from_json];
use parent qw[ Exporter ];

our @ISA = qw[ Exporter ];

our @EXPORT_OK = qw( get_test_data get_test_useragent );  # symbols to export on request

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

my $data;

$data = {
	get_jgi_user_json => {
		valid => {
			'ip' => '24.23.163.18',
			'user' => {
				'email' => 'fatman@blobby.com',
				'contact_id' => 6660003,
				'id' => 3000666,
				'email_address' => 'fatman@blobby.com',
				'login' => 'mr_blobby',
			},
			'id' => '164204433980c73e76e55c7add829d51'
		},
		valid2 => {
			'ip' => '24.23.163.18',
			'user' => {
				'email' => 'carmen@broderbund.org',
				'contact_id' => 6660002,
				'id' => 2000666,
				'email_address' => 'carmen@broderbund.org',
				'login' => 'carmen_sandiego',
			},
			'id' => '164204433980c73e76e55c7add829d51'
		},
		invalid => {
			'ip' => '24.23.163.18',
			'user' => {
				'email' => 'fatman@blobby.com',
				'contact_id' => 999,
				'id' => 666,
			},
			'id' => '164204433980c73e76e55c7add829d51'
		},
	},
	jbrowse => {
		'*' => {
			user => {
				contact_oid => 909,
				name => 'Mr. Blobby',
				email => 'fatman@blobby.com'
			},
			galaxy_user => 'fatman@blobby.com',
			private_taxon_oid => 3300005255,
			private_ok => 10101010,
			invalid_taxon_oid => 'abcdefg',
			valid_taxon_oid => 637000214,
			no_dna_seq => 637000211, # no DNA seq
			no_gff => 637000212, # we have the DNA sequence but no GFF file
			invalid_gff => 637000213, # invalid GFF
		}
	},
};

sub get_test_data {
	my ( $x, $y ) = @_;

	die 'Could not find $data->{' . $x . '}{' . $y . '}!' unless $data->{$x} && $data->{$x}{$y};

	return $data->{$x}{$y};

}

sub get_test_useragent {

	# set up a fake user agent
	my $requests = {
		get => {
			# invalid JSON response
			'https://example.com/invalid_json.json' => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/invalid_json.json",
					'Correct URL',
				);

				return {
					success => 1,
					content => '{"ip":"24.23.163.18","id":"164204433980c73e76e55c7add829d51","user":{"created_at":"2015-06-04T18:54:00Z","id":123456,"last_authenticated_at":"2015-08-18T23:12:22Z"'
				};
			},

			# no user data
			'https://example.com/no_user_data.json' => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/no_user_data.json",
					'Correct URL',
				);

				return {
					success => 0,
					status => 500,
					reason => 'error',
					content => 'fake',
				};
			},

			'https://example.com/resp_fmt_invalid.json' => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/resp_fmt_invalid.json",
					'Correct URL',
				);

				return {
					success => 1,
					content => to_json get_test_data( 'get_jgi_user_json', 'invalid' ),
				};
			},

			'https://example.com/valid.json' => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/valid.json",
					'Correct URL',
				);

				return {
					success => 1,
					content => to_json get_test_data( 'get_jgi_user_json', 'valid' ),
				};
			},
		},
		head => {
			"https://example.com/api/sessions/no_user_data.json" => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/api/sessions/no_user_data.json",
					'Correct URL',
				);

				return {
					success => 0,
					status => 500,
					reason => 'error',
					content => 'fake',
				};
			},

			"https://example.com/api/sessions/200.json" => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/api/sessions/200.json",
					'Correct URL',
				);

				return {
					success => 1,
					status  => 200,
				};
			},

			"https://example.com/api/sessions/204.json" => sub {
				my $url = shift;
				is(
					$url,
					"https://example.com/api/sessions/204.json",
					'Correct URL',
				);

				return {
					success => 1,
					status  => 204,
				};
			},

			"https://perl.com/api/sessions/204.json" => sub {
				my $url = shift;
				is(
					$url,
					"https://perl.com/api/sessions/204.json",
					'Correct URL',
				);

				return {
					success => 1,
					status  => 204,
				};
			},
		}
	};

	my $user_agent = MyUserAgent->new(
		head => sub {
			say 'args: ' . Dumper \@_;
			return $requests->{head}{ $_[0] }->(@_);
		},
		get => sub {
			return $requests->{get}{ $_[0] }->(@_);
		}
	);

	return $user_agent;
}


1;
