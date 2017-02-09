{	db => {
		imgsqlite => {
			driver => 'SQLite',
			database => '/global/homes/a/aireland/webUI/proportal/share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		}
	}
}
