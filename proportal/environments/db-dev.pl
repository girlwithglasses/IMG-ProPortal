{
	db => {
		cycog => {
			driver => 'SQLite',
#			database => '/global/homes/w/wwwimg/svn/webUI/proportal/share/cycog.db',
			database => '/global/homes/a/aireland/webUI/proportal/share/cycog.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
	}
}
