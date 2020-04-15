extends Node2D

#takes the user to adding a new memory screen
func _on_Add_New_Memory_pressed():
	$Home.visible = false
	get_node("Add a New Memory").visible = true

#takes the user back to the home screen
func on_Back_to_Memories_pressed():
	$Home.visible = true
	get_node("Add a New Memory").visible = false

#takes the user back to the home screen and updates the list
func on_save_memory_pressed():
	$Home.visible = true
	get_node("Add a New Memory").visible = false
	get_node("Home").populate_list()
