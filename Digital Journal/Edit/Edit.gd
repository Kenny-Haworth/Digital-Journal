extends Node2D

onready var Journal = get_parent()

#all fields for editing and saving the current memory
onready var Name = get_node("Name")
onready var Date = get_node("Date")
onready var Location = get_node("Location")
onready var Description = get_node("Description")
onready var Media = get_node("Media")

#for holding the media before it is edited for this memory
var old_file_paths
#for holding the entire string of this memory to replace after editing
var line

#the current box to add tags to
var Tags_Box
#the tag text label
onready var Tags_Text = get_node("Tags")
#the actual tag to add
var Tag = preload("res://Add a New Memory/Tags Node.tscn")

#the vertical container to add new horizontal containers to
onready var vertical_container = get_node("Tags Scroll Container/Tags VBox")
#the horizontal_container container box for adding new boxes
var horizontal_container = preload("res://Add a New Memory/Tags HBox.tscn")

#autofills all boxes and media given a particular memory
func edit_memory(memory: Panel):
	
	#extract the line in the text file that is this save memory
	var saveFile = File.new()
	saveFile.open("user://saved_memories.txt", File.READ_WRITE)
	
	for _i in range(memory.line_number):
		saveFile.get_line()
	
	line = saveFile.get_line()
	saveFile.close()
	
	#extract the line to a dictionary
	var json = JSON.parse(line)
	
	if typeof(json.result) == TYPE_DICTIONARY:
		var cur_dict = json.result
		Name.text = cur_dict["Name"]
		Date.text = cur_dict["Date"]
		Location.text = cur_dict["Location"]
		Description.text = cur_dict["Description"]
		
		#clear any tags or media that already exist
		for child in vertical_container.get_children():
			child.free()
		
		Media.clear()
		
		#set the tags and media
		var Tags_List = cur_dict["Tags"]
		
		for tag in Tags_List:
			_on_Tags_text_entered(tag)
		
		var Media_List: PoolStringArray = cur_dict["Media"]
		Media._files_dropped(Media_List, 0)
		
		#save the media (before editing) for later so it does not need to be reaccessed
		old_file_paths = cur_dict["Media"]

#add a new tag
func _on_Tags_text_entered(new_text):
	var new_tag = Tag.instance()
	new_tag.text = new_text

	#spawn a new tags box the first time a tag is entered, or if the current box is to wide
	if (vertical_container.get_child_count() == 0) or (new_tag.get_minimum_size().x + Tags_Box.get_minimum_size().x > 830):
		Tags_Box = horizontal_container.instance()
		vertical_container.add_child(Tags_Box)
	
	Tags_Box.add_child(new_tag)
	Tags_Text.text = "" #remove tag text from label box

#saves any and all changes made to this memory
func _on_Save_Changes_pressed():
	
	#get a dictionary line to save
	var json_string = Journal.parse_data_to_json(Name, Date, Location, Description, vertical_container, Media)
	
	#get the text file as a string to overwrite
	var saveFile = File.new()
	saveFile.open("user://saved_memories.txt", File.READ_WRITE)
	var file_as_text = saveFile.get_as_text()
	saveFile.close()
	
	#overwrite the memory's contents and write in the new file contents
	file_as_text = file_as_text.replace(line, json_string) #replace the memory
	file_as_text = file_as_text.rstrip("\n") #remove the extra new line at the end of the file
	
	#overwite the file
	saveFile.open("user://saved_memories.txt", File.WRITE)
	saveFile.store_line(file_as_text)
	saveFile.close()
	
	#if any thumbnails were deleted after editing, delete them from the thumbnails folder
	var current_file_paths = Media.get_file_paths()
	
	for old_media in old_file_paths:
		if not current_file_paths.has(old_media):
			Journal.delete_thumbnail(old_media)
	
	Journal.on_save_memory_pressed()
