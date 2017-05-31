{
	session => 'CGISession',
	engines => {
		session => {
			CGISession => {
	#			name => 'CGISESSID_proportal',
				cookie_name => 'CGISESSID_proportal',
				cookie_duration => '55 minutes',
	#			cookie_domain => 'jgi-psf.org',
				driver_params => {
					Directory => '/var/tmp',
				},
			},
		},
	}
}
