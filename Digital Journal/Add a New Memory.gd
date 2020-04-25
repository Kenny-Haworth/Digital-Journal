extends Node2D

onready var Journal = get_parent()

#the vertical container to add new horizontal containers to
onready var vertical_container = get_node("Tags Scroll Container/Tags VBox")
#the horizontal_container container box for adding new boxes
var horizontal_container = preload("res://Add a New Memory/Tags HBox.tscn")

#the current box to add tags to
var Tags_Box
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
	
	#spawn a new tags box the first time a tag is entered, or if the current box is to wide
	if (vertical_container.get_child_count() == 0) or (new_tag.get_minimum_size().x + Tags_Box.get_minimum_size().x > 830):
		Tags_Box = horizontal_container.instance()
		vertical_container.add_child(Tags_Box)
	
	Tags_Box.add_child(new_tag)
	Tags_Text.text = "" #remove tag text from label box

#save the new memory to file, delete the filled in boxes, tags, and media, and take the user back to the home screen
func _on_Save_pressed():
	_save_memory()
	
	Name.text = ""
	Date.text = ""
	Location.text = ""
	Description.text = ""
	Tags_Text.text = ""
	
	#delete tags
	for child in vertical_container.get_children():
		child.free()
	
	#delete media
	Media.clear()
	
	Journal.on_save_memory_pressed()
	
#saves the new memory to file and generates thumbnails to save to file
func _save_memory():
	var json_string = Journal.parse_data_to_json(Name, Date, Location, Description, vertical_container, Media)
	
	var saveFile = File.new()
	saveFile.open("user://saved_memories.txt", File.READ_WRITE)
	saveFile.seek_end()
	
	saveFile.store_line(json_string)
	saveFile.close()
