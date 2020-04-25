extends Node2D

onready var Home = get_node("Home")
onready var Add_a_New_Memory = get_node("Add a New Memory")
onready var Edit = get_node("Edit")

#maximizes the window on startup to avoid size issues with different screens
func _ready():
	OS.set_window_maximized(true)

#takes the user to adding a new memory screen
func _on_Add_New_Memory_pressed():
	Home.visible = false
	Add_a_New_Memory.visible = true

#takes the user back to the home screen
func on_Back_to_Memories_pressed():
	Home.visible = true
	Add_a_New_Memory.visible = false
	Edit.visible = false

#takes the user back to the home screen and updates the list
func on_save_memory_pressed():
	Home.visible = true
	Add_a_New_Memory.visible = false
	Edit.visible = false
	Home.populate_list(true)

#take the user to the edit memory screen
func _on_Edit_Memory_pressed():
	Home.visible = false
	Edit.visible = true
	
	#pass the info of the selected node
	Edit.edit_memory(Home.get_selected_memory())

#returns a json string using the data from the given nodes and saves thumbnails of all associated media
func parse_data_to_json(Name, Date, Location, Description, vertical_container, Media) -> String:
	var saveDictionary = {
		Name = "",
		Date = "",
		Location = "",
		Description = "",
		Tags = [],
		Media = []
	}
	
	saveDictionary.Name = Name.text
	saveDictionary.Date = Date.text
	saveDictionary.Location = Location.text
	saveDictionary.Description = Description.text
	
	#get the media paths to save and additionally save a thumbnail of each image for faster loading
	var some_media: Array = Media.get_file_paths()
	var other_media = []
	
	for media in some_media:
		other_media.append(media)
		var image = Image.new()
		image.load(media)
		image.resize(46, 40)
		
		#colons and backslashes are not allowed on windows OS
		var converted_file_path_name = media.replace(":", "!")
		converted_file_path_name = converted_file_path_name.replace("\\", "&")
		
		#if the thumbnails folder does not exist, create it
		var thumbnail_dir = Directory.new()
		if not thumbnail_dir.dir_exists("user://Thumbnails"):
			thumbnail_dir.open("user://")
			thumbnail_dir.make_dir("Thumbnails")
		
		var err = image.save_png("user://Thumbnails/" + converted_file_path_name + ".png")
		if err != 0:
			print("Error saving image!")
			print("Media path:", media)
			print("Converted path:", converted_file_path_name)
			print("Error code:", err)
	
	saveDictionary.Media = other_media
	
	var Tags = []
	for hbox in vertical_container.get_children():
		for tag in hbox.get_children():
			Tags.append(tag.text)
	saveDictionary.Tags = Tags
	
	var json_string = JSON.print(saveDictionary)
	return json_string

#given the entire memory, deletes all thumbnails associated with this memory
#first checks to make sure the thumbnail is not needed for any other memories
func delete_all_thumbnails(line_to_delete: String):
	var json = JSON.parse(line_to_delete)
	
	if typeof(json.result) == TYPE_DICTIONARY:
		var cur_dict = json.result
		var media_list = cur_dict["Media"]
		
		for media in media_list:
			delete_thumbnail(media)

#given a single media path, deletes the thumbnail associated with this path
#first checks to make sure the theumbnail is not needed for any other memories
func delete_thumbnail(media: String):
	
	#if the thumbnail is needed for any other memory besides this one, do not delete it
	if not _media_in_other_memories(media):
		var converted_file_path_name = media.replace(":", "!")
		converted_file_path_name = converted_file_path_name.replace("\\", "&")
		var dir = Directory.new()
		dir.remove("user://Thumbnails/" + converted_file_path_name + ".png")

#returns true if this media is in other memories, false otherwise
func _media_in_other_memories(media: String) -> bool:
	var saveFile = File.new()
	saveFile.open("user://saved_memories.txt", File.READ)
	
	#check against all other media saved in other memories
	while not saveFile.eof_reached():
		var line = saveFile.get_line()
		
		if line == "":
			continue
		
		var saved_json = JSON.parse(line)

		if typeof(saved_json.result) == TYPE_DICTIONARY:
			var saved_dict = saved_json.result
			var saved_media_list = saved_dict["Media"]

			for saved_media in saved_media_list:
				if media == saved_media:
					saveFile.close()
					return true
	
	saveFile.close()
	return false
