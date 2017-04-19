{
	schema => {
		img_core => {
			db => "imgsqlite",
			module => "DataModel::IMG_Core"
		},
		img_gold => {
			db => "imgsqlite",
			module => "DataModel::IMG_Gold"
		},
		img_cycog => {
			db => "cycog",
			module => "DataModel::IMG_CyCOG"
		}
	}
}
