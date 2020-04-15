#a class for holding and showing media files on the host's OS when adding a new memory

extends ItemList

#a list of the paths of all media files
var file_paths = []

func _ready():
	var _err = get_tree().connect("files_dropped", self, "_files_dropped")

#show media that is dropped to in a nice format to the user
func _files_dropped(files, _screen):
	
	#don't allow files to be dragged and dropped if the Add a New Memory screen is not visible
	if not get_parent().visible:
		return
	
	for file in files:
		#do not allow duplicate media
		if file in file_paths:
			continue
		
		var image = Image.new()
		image.load(file)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		
		add_item("", texture, true)
		set_item_tooltip(get_item_count() - 1, file)
		file_paths.append(file)

func get_file_paths() -> Array:
	return file_paths

func clear_file_paths():
	file_paths.clear()
