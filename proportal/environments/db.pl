{	db => {
		imgsqlite => {
			driver => 'SQLite',
			database => '/global/homes/a/aireland/webUI/proportal/share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		img_gold => { # this is GOLD
			driver => 'Oracle',
			database => 'imgiprd',
			user => 'imgsg_dev',
			password => 'Tuesday',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		},
		img_core_gem1 => {
			driver => 'Oracle',
			database => 'gemini1_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		},
		img_core_gem2 => {
			driver => 'Oracle',
			database => 'gemini2_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		}
	}
}
