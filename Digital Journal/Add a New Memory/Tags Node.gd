extends Button

#delete the existing tag when it is clicked on
func _on_Tags_Node_pressed():
	queue_free()
