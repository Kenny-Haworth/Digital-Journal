extends Panel

#for enabling buttons on the home screen
onready var Home = get_node("/root/Journal/Home")

#for unchecking other checked boxes
onready var Memories_Container = get_parent()
onready var Checkbox = get_node("CheckBox")

#for saving which line of the text file this memory is associated with
var line_number

#ensures checkboxes are mutually exclusive and properly enable or disable corresponding buttons
func _on_CheckBox_toggled(button_pressed):
	#if a checkbox is pressed, ensure all other checkboxes become unpressed
	#additionally, enable the view, edit, and delete memory buttons
	if button_pressed:
		Home.enable_buttons()
		_uncheck_other_memories()
	
	#if a checkbox is unpressed (and there are no checkboxes currently pressed), disable the view, edit, and delete memory buttons
	else:
		for memory in Memories_Container.get_children():
			if memory.Checkbox.pressed:
				return
		
		Home.disable_buttons()

#unchecks all other memory previews that may have been checked except for the current memory
func _uncheck_other_memories():
	for memory in Memories_Container.get_children():
		if memory != self:
			memory.Checkbox.pressed = false

#saves the line of the text file this memory is associated with
func set_line_number(num):
	line_number = num
