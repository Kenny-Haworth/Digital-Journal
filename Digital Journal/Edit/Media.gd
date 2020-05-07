#a class for holding and showing media files on the host's OS when adding a new memory

extends ItemList

func _ready():
	var _err = get_tree().connect("files_dropped", self, "_files_dropped")

#show media that is dropped to in a nice format to the user
func _files_dropped(files: PoolStringArray, _screen):
	
	#don't allow files to be dragged and dropped if the Add a New Memory screen or Edit screen are not visible
	if not get_parent().visible:
		return
	
	for file in files:
		
		#do not allow duplicate media
		if _is_duplicate_media(file):
			continue
		
		var image = Image.new()
		image.load(file)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		
		add_icon_item(texture, true)
		set_item_tooltip(get_item_count() - 1, file)

#returns true if this file is already included
func _is_duplicate_media(file):
	#do not allow duplicate media
	for i in range(get_item_count()):
		if file == get_item_tooltip(i):
			return true
	
	return false

func get_file_paths() -> Array:
	var file_paths = []
	
	for i in range(get_item_count()):
		file_paths.append(get_item_tooltip(i))
	
	return file_paths

#remove media if it double-clicked on
func _on_Media_item_activated(index):
	remove_item(index)
