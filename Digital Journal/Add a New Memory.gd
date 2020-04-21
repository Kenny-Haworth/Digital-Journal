extends Node2D

#the current box to add tags to
var Tags_Box
#the vertical container to add new horizontal containers to
onready var vertical_container = get_node("Tags Scroll Container/Tags VBox")
#the horizontal_container container box for adding new boxes
var horizontal_container = preload("res://Add a New Memory/Tags HBox.tscn")

#the tag text label
onready var Tags_Text = get_node("Tags")
#the actual tag to add
var Tag = preload("res://Add a New Memory/Tags Node.tscn")

#the text within each object to save the memory
onready var Name = get_node("Name")
onready var Date = get_node("Date")
onready var Location = get_node("Location")
onready var Description = get_node("Description")

#for getting the media
onready var Media = get_node("Media")

#add a new tag
func _on_Tags_text_entered(new_text):
	var new_tag = Tag.instance()
	new_tag.text = new_text
	
	#to be done only the first time a tag is entered
	if vertical_container.get_child_count() == 0:
		Tags_Box = horizontal_container.instance()
		vertical_container.add_child(Tags_Box)
	
	if (new_tag.rect_size.x + Tags_Box.rect_size.x > 830): #830 max width
		Tags_Box = horizontal_container.instance()
		vertical_container.add_child(Tags_Box)
	
	Tags_Box.add_child(new_tag)
	Tags_Text.text = "" #remove tag from label box

#save the new memory to file, delete the filled in boxes and tags, and take the user back to the home screen
func _on_Save_pressed():
	_save_memory()
	
	Name.text = ""
	Date.text = ""
	Location.text = ""
	Description.text = ""
	Tags_Text.text = ""
	
	#delete tags
	for child in vertical_container.get_children():
		child.queue_free()
	
	#delete media
	Media.clear()
	
	get_parent().on_save_memory_pressed()
	
#saves the new memory to file and generates thumbnails to save to file
func _save_memory():
	var saveFile = File.new()
	saveFile.open("user://saved_memories.txt", File.READ_WRITE)
	saveFile.seek_end()
	
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
		var err = image.save_png("user://Thumbnails/" + converted_file_path_name)
		if err != 0:
			print("Error saving image!")
			print("Media path:", media)
			print("Converted path:", converted_file_path_name)
			print("Error code:", err)
	
	saveDictionary.Media = other_media
	Media.clear_file_paths()
	
	var Tags = []
	for hbox in vertical_container.get_children():
		for tag in hbox.get_children():
			Tags.append(tag.text)
	saveDictionary.Tags = Tags
	
	var json_string = JSON.print(saveDictionary)
	saveFile.store_line(json_string)
	saveFile.close()
