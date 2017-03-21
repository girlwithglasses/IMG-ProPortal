{
	schema => {
		img_core => {
#			db => "img_core_gem2",
			db => "imgsqlite",
			module => "DataModel::IMG_Core"
		},
		img_gold => {
			db => "imgsqlite",
			module => "DataModel::IMG_Gold"
		}
	}
}
