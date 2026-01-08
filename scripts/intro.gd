extends Node2D


@onready var title: Label = $Control/Title # Ensure the Label is correctly named and parented
# The correct, final title (Use ALL CAPS for visual impact)
const FINAL_TITLE: String = "TAARE ZAMEEN PAR"
# The starting jumbled phrase (Same length as FINAL_TITLE, including spaces)
const STARTING_JUMBLE: String = "REAATEENZAFJJD" 
# Duration of the rapid jumbling effect
const JUMBLE_DURATION: float = 0.5 
# How long the starting jumble displays before the rapid effect begins
const INITIAL_DISPLAY_DURATION: float = 0.5 
# How often the text changes during the jumble phase (rapid flashes)
const SWAP_INTERVAL: float = 0.05
# How long the final title displays before the game theoretically starts
const FINAL_DISPLAY_DURATION: float = 3.0

# Timer to control the sequence
var jumble_timer: Timer


# --- Helper Function (Godot 3.x Compatibility Fix) ---

# Converts a string to an array of characters, needed for Godot 3.x
func _string_to_char_array(text: String) -> Array:
	var arr = []
	# Loop through each character and append it to the array
	for i in range(text.length()):
		arr.append(text[i])
	return arr


# --- Initialization ---

func _ready() -> void:
	# 1. Setup the scene and display the initial jumbled text
	title.text = STARTING_JUMBLE
	
	# 2. Setup and start the main timer for sequencing
	jumble_timer = Timer.new()
	add_child(jumble_timer)
	jumble_timer.one_shot = true
	
	# Wait for the initial display duration
	jumble_timer.start(INITIAL_DISPLAY_DURATION)
	await jumble_timer.timeout
	
	# 3. Begin the active jumbling effect
	_start_jumble_effect()


# --- Jumbling Functions ---

func _start_jumble_effect() -> void:
	# --- Part 1: Start Rapid Swapping ---
	jumble_timer.wait_time = SWAP_INTERVAL
	jumble_timer.one_shot = false
	jumble_timer.start()
	
	# Connect the rapid swapping to the timer timeout signal
	jumble_timer.timeout.connect(_swap_text)
	
	# --- Part 2: Wait for the total JUMBLE_DURATION ---
	
	# Use a separate temporary timer to track the total duration
	var end_timer = Timer.new()
	add_child(end_timer)
	end_timer.one_shot = true
	end_timer.start(JUMBLE_DURATION)
	await end_timer.timeout
	
	# --- Part 3: Stop and Resolve ---
	
	# Stop the rapid swapping
	jumble_timer.stop()
	jumble_timer.timeout.disconnect(_swap_text) 
	end_timer.queue_free()
	
	_resolve_title()


func _swap_text() -> void:
	# Get the correct title's characters as an array
	var char_array: Array = _string_to_char_array(FINAL_TITLE)
	
	# Perform a few random swaps to create the illusion of jumbling
	# The more you swap, the more chaotic the jumble looks
	for i in range(2): 
		var idx1 = randi_range(0, char_array.size() - 1)
		var idx2 = randi_range(0, char_array.size() - 1)
		
		# Ensure we don't swap characters we are trying to keep in place (e.g., spaces)
		if char_array[idx1] != " " and char_array[idx2] != " ":
			# Swap logic
			var temp = char_array[idx1]
			char_array[idx1] = char_array[idx2]
			char_array[idx2] = temp
		
	# Join the shuffled array back into a string and update the label
	title.text = "".join(char_array)


# --- Final Resolution ---

func _resolve_title() -> void:
	# 1. SNAP to the correct, final title
	title.text = FINAL_TITLE
	
	# TODO: Add the 'A-ha!' sound effect here
	# Example: $SoundPlayer.play("res://sounds/chime.wav")
	
	# 2. Wait for the final display duration
	jumble_timer.wait_time = FINAL_DISPLAY_DURATION 
	jumble_timer.one_shot = true
	jumble_timer.start()
	await jumble_timer.timeout
	
	# 3. Transition to the main game
	print("Transitioning to main game...")
	# Replace this line with your actual scene change logic
	# get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	jumble_timer.queue_free()


func _on_start_btn_pressed() -> void:
	Dialogic.start("res://timelines/greetings.dtl")
	get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/map001.tscn")
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
