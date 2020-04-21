extends Node2D

#to add memories to the container
onready var Memories_Container = get_node("Memories Container/VBoxContainer")

#to spawn a dynamic number of memories
var Memory_Preview = preload("res://Home/Memory_Preview.tscn")

#the number of days for each of the 12 months
const days_per_month = [31,28,31,30,31,30,31,31,30,31,30,31]

#an array of memories to be used for search queries. Contains all memories
var array_of_memories = []

#a memory to be used for search queries
var Memory = load("res://Home/Memory.gd")

func _ready():
	populate_list()

#adds all memories to the viewing list by reading from the saved memories file
#and saves all memories to an array of memories
func populate_list():
	
	#clear the current list of memories first
	_clear_home_screen_memories()
	array_of_memories.clear()
	
	#open the save file
	var loadFile = File.new()
	
	#create the file if it does not exist
	if not loadFile.file_exists("user://saved_memories.txt"):
		loadFile.open("user://saved_memories.txt", File.WRITE)
	
	loadFile.open("user://saved_memories.txt", File.READ)
	
	#load each memory in and save it to the array of memories
	while not loadFile.eof_reached():
		_add_memory_to_home_screen(loadFile.get_line(), true)
	
	loadFile.close()

#clears the current list of memories
func _clear_home_screen_memories():
	for child in Memories_Container.get_children():
		child.queue_free()

#converts the given string into a memory and adds it to the home screen
#additionally, adds the memory to the array of memories used for search queries if initialization is true
func _add_memory_to_home_screen(line: String, initialization: bool):
	
	#skip blank lines - Godot adds one in at the end of the file
	if line == "":
		return
	
	var json = JSON.parse(line)
	var new_memory
	
	#this if statement needs to be here for some reason. It was copied from the Godot
	#docs - for whatever reason without it, the json.result is of nil type
	if typeof(json.result) == TYPE_DICTIONARY:
		var cur_dict = json.result
		
		new_memory = Memory_Preview.instance()
		
		var date: String = cur_dict["Date"]
		var month
		var day
		var year
		
		#change the date from xx/xx/xxxx to month day, year
		if date.find("/") != -1:
			var month_day_year = date.split("/")
			month = month_day_year[0]
			day = month_day_year[1]
			year = month_day_year[2]
			
			match month:
				"1", "01": date = "January " + day + ", " + year
				"2", "02": date = "February " + day + ", " + year
				"3", "03": date = "March " + day + ", " + year
				"4", "04": date = "April " + day + ", " + year
				"5", "05": date = "May " + day + ", " + year
				"6", "06": date = "June " + day + ", " + year
				"7", "07": date = "July " + day + ", " + year
				"8", "08": date = "August " + day + ", " + year
				"9", "09": date = "September " + day + ", " + year
				"10": date = "October " + day + ", " + year
				"11": date = "November " + day + ", " + year
				"12": date = "December " + day + ", " + year
		
		#the string is already month day, year, extract the individual parts
		else:
			var date_copy = date
			date_copy = date_copy.replace(",", "")
			var date_array = date_copy.split(" ")
			
			month = date_array[0]
			day = date_array[1]
			year = date_array[2]
			
			#change month into a string corresponding to the number
			match month:
				"January": month = "1"
				"February": month = "2"
				"March": month = "3"
				"April": month = "4"
				"May": month = "5"
				"June": month = "6"
				"July": month = "7"
				"August": month = "8"
				"September": month = "9"
				"October": month = "10"
				"November": month = "11"
				"December": month = "12"
		
		#convert each type to int
		month = month.to_int()
		day = day.to_int()
		year = year.to_int()
		
		#use the extracted parts and the current date to determine how long ago this day occurred
		var days_difference = 0
		var current_date = OS.get_date()
		var years_difference = current_date["year"]-year
		
		#identify when the date is in the future and inform the user it is an invalid date
		if (years_difference == 0 and month > current_date["month"]) or (years_difference == 0 and month == current_date["month"] and day > current_date["day"]):
			years_difference = -1

		#there are 4 cases for calculating how long ago a date occurred
		if years_difference > 1:
			days_difference = (years_difference-1) * 365
			days_difference += _days_to_end_of_year(month, day) + _days_from_beginning_of_year(current_date["month"], current_date["day"])
		elif years_difference == 1:
			days_difference = _days_to_end_of_year(month, day) + _days_from_beginning_of_year(current_date["month"], current_date["day"])
		elif years_difference == 0:
			 days_difference = _days_to_end_of_year(month, day) + _days_from_beginning_of_year(current_date["month"], current_date["day"]) - 365
		else:
			#the date is in the future
			days_difference = -1
		
		days_difference = _convert_days_to_long_units(days_difference, month)
		
		new_memory.get_node("Name").text = cur_dict["Name"]
		new_memory.get_node("Location").text = cur_dict["Location"]
		new_memory.get_node("Description").text = cur_dict["Description"]
		new_memory.get_node("Date").text = date
		new_memory.get_node("How Long Ago").text = str(days_difference)
		
		#add valid media to the memory preview
		#TODO this is an incredible slow code block, load only image previews. Downscale each image/use thumbnails
		var media_preview = new_memory.get_node("Media")
		var media_list = cur_dict["Media"]

		for media in media_list:
			#load the thumbnail instead of the actual media on the home screen
			var converted_file_path_name = media.replace(":", "!")
			converted_file_path_name = converted_file_path_name.replace("\\", "&")
			converted_file_path_name = "user://Thumbnails/" + converted_file_path_name
			
			var image = Image.new()
			image.load(converted_file_path_name)
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			
			media_preview.add_item("", texture, true)
			media_preview.set_item_tooltip(media_preview.get_item_count() - 1, media)
		#TODO this is an incredibly slow code block
		
		#add this memory to the array of all memories
		if initialization:
			array_of_memories.append(Memory.new(cur_dict["Name"], date, cur_dict["Location"], cur_dict["Tags"]))
	
	Memories_Container.add_child(new_memory)

#updates the current memories to be shown based upon the entered text
func _on_Search_Bar_text_changed(query):
	
	#if there is no text entered (AKA the user backspaced to nothing), load the whole list in
	if query == "":
		populate_list()
		return
	
	#ignore punctuation and leading and trailing spaces entered by the user
	query = query.replace(",", "")
	query = query.replace(".", "")
	query = query.trim_prefix(" ")
	query = query.trim_suffix(" ")
	
	#clear the current list of memories first
	_clear_home_screen_memories()
	
	#open the save file
	var loadFile = File.new()
	loadFile.open("user://saved_memories.txt", File.READ)
	
	#for each memory, match the given text and only load the memory in if it matches
	var counter = 0
	while not loadFile.eof_reached():
		var line = loadFile.get_line()
		
		#skip the blank line at the end of the file
		if line == "":
			continue
		
		var query_array = query.split(" ")
		var valid = true #to keep track if all given terms of the query were found
		
		for text in query_array:
			if text == " ":
				continue
				
			if not array_of_memories[counter].contains(text):
				valid = false
				break
		
		if valid:
			_add_memory_to_home_screen(line, false)
		
		counter += 1
	
	loadFile.close()

#returns the number of days from this month and day to the end of the year
func _days_to_end_of_year(month: int, day: int) -> int:
	var days = 0
	var months_to_add = 12 - month
	
	for i in range(months_to_add):
		days += days_per_month[i+month]
	
	return days + (days_per_month[month-1]-day)

#returns the number of days from the beginning of the year to this day and month
func _days_from_beginning_of_year(month: int, day: int) -> int:
	var days = 0
	
	for i in range(month-1):
		days += days_per_month[i]
	
	return days+day

#converts a number of days to a string such as x years, x months, x weeks, x days
#the starting month is also needed, as months have a variable number of days
func _convert_days_to_long_units(days: int, starting_month: int) -> String:
	if days == 0:
		return "Today!"
	elif days == -1:
		return "Future date detected"
	
	var answer = ""
	
	#calculate the number of years
	var years = days/365
	
	#append the string of years
	if years >= 2:
		answer += str(years) + " years "
	elif years == 1:
		answer += str(years) + " year "
	
	#calculate the number of months
	var days_left = days % 365
	var number_of_months = 0
	var counter = 0
	
	while days_left - days_per_month[starting_month+counter-1] >= 0:
		days_left -= days_per_month[starting_month+counter-1] #92
		number_of_months += 1
		counter += 1
		
		if counter+starting_month > 12:
			counter -= 12
	
	#append the string of months
	if number_of_months >= 2:
		answer += str(number_of_months) + " months "
	elif number_of_months == 1:
		answer += str(number_of_months) + " month "
	
	#calculate the number of weeks
	var weeks = days_left/7
	
	#append the string of weeks
	if weeks >= 2:
		answer += str(weeks) + " weeks "
	elif weeks == 1:
		answer += str(weeks) + " week "
	
	#calculate the number of days
	days_left = days_left % 7
	
	#append the string of days
	if days_left >= 2:
		answer += str(days_left) + " days "
	elif days_left == 1:
		answer += str(days_left) + " day "
	
	#remove leading and trailing spaces
	answer = answer.trim_prefix(" ")
	answer = answer.trim_suffix(" ")
	
	#format the string properly with commas
	if "years" in answer:
		answer = answer.replace("years", "years,")
	else:
		answer = answer.replace("year", "year,")
	
	if "months" in answer:
		answer = answer.replace("months", "months,")
	else:
		answer = answer.replace("month", "month,")
	
	if "weeks" in answer:
		answer = answer.replace("weeks", "weeks,")
	else:
		answer = answer.replace("week", "week,")
		
	if answer.ends_with(","):
		answer.erase(answer.length()-1, 1)
	
	return answer
