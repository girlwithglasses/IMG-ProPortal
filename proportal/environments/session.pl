{
	session => {
		CGISession => {
#			name => 'CGISESSID_proportal',
			cookie_name => 'CGISESSID_proportal',
			cookie_duration => '1.5 hours',
#			cookie_domain => 'jgi-psf.org',
			driver_params => {
				Directory => '/tmp',
			},
		},
	},
}
