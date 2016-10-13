{
	schema => {
		img_core => { module => 'DataModel::IMG_Core', db => 'imgsqlite' },
		img_gold => { module => 'DataModel::IMG_Gold', db => 'imgsqlite' },
		missing  => { module => 'I::Made::This::Up', db => 'test' },
		absent   => { module => 'DataModel::IMG_Test', db => 'absent' },
	}
}
