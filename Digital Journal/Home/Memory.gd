#this class contains all keywords a memory can be searched from
#this includes Name, Date, Location, and Tags
extends Node

#to hold all the keywords associated with this memory
var _keywords = []

#saves all keywords of this memory to a list of keywords
func _init(memory_name: String, date: String, location: String, tags: Array):
	
	#preprocess each String, removing any punctuations with the exception of spaces
	memory_name = memory_name.replace(",", "")
	memory_name = memory_name.replace(".", "")
	
	date = date.replace(",", "")
	date = date.replace(".", "")
	
	location = location.replace(",", "")
	location = location.replace(".", "")
	
	for i in range(tags.size()):
		tags[i] = tags[i].replace(",", "")
		tags[i] = tags[i].replace(".", "")
	
	#tokenize each String and add it to the array
	var memory_array = memory_name.split(" ")
	
	for i in range(memory_array.size()):
		_keywords.append(memory_array[i])
	
	#date
	var date_array = date.split(" ")
	
	for i in range(date_array.size()):
		_keywords.append(date_array[i])
	
	#locations
	var location_array = location.split(" ")
	
	for i in range(location_array.size()):
		_keywords.append(location_array[i])
	
	#tags
	for tag in tags:
		var tags_array = tag.split(" ")
		
		for i in range(tags_array.size()):
			_keywords.append(tags_array[i])

#returns true if this particular memory contains the given search query
func contains(query: String) -> bool:
	for i in range(_keywords.size()):
		if query.to_lower() in _keywords[i].to_lower():
			return true
	
	return false
