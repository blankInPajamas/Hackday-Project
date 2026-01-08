extends CharacterBody2D

@onready var keyboard_letters: Sprite2D = $KeyboardLetters
@onready var overlap_area: Area2D = $Area2D

# ASSUMPTION: The character Aamir is interacting with is named "Aamir"
const TARGET_BODY_NAME: String = "Aamir"

# New flag to track if the target body (Aamir) is currently inside the Area2D
var target_in_range: bool = false 

func _ready() -> void:
	# 1. Ensure the interaction prompt starts hidden.
	keyboard_letters.visible = false
	
	# 2. Connect BOTH signals in the _ready function.
	overlap_area.body_entered.connect(_on_overlap_area_body_entered)
	overlap_area.body_exited.connect(_on_overlap_area_body_exited)


# --- Input Handling ---

# This function checks for input events that haven't been handled by GUI elements.
func _unhandled_input(event: InputEvent) -> void:
	# Check if the 'F' key was pressed AND the target is currently in range
	if event.is_action_pressed("interact") and target_in_range:
		# Consume the event so it doesn't propagate further
		get_viewport().set_input_as_handled()
		
		# Call the interaction function
		_execute_interaction()


# --- Interaction Logic ---

func _execute_interaction() -> void:
	# YOUR INTERACTION LOGIC GOES HERE
	print("--- INTERACTED: F was pressed while " + TARGET_BODY_NAME + " was in range! ---")
	Dialogic.start("res://timelines/dys_image.dtl")
	get_tree().change_scene_to_file("res://scenes/introduction.tscn")
# --- Overlap Handlers ---

func _on_overlap_area_body_entered(body: Node2D) -> void:
	if body.name == TARGET_BODY_NAME:
		# Target entered: set flag to true and show prompt
		target_in_range = true
		keyboard_letters.visible = true
		print("Aamir: Now in range of " + TARGET_BODY_NAME + ". Showing prompt.")


func _on_overlap_area_body_exited(body: Node2D) -> void:
	if body.name == TARGET_BODY_NAME:
		# Target exited: set flag to false and hide prompt
		target_in_range = false
		keyboard_letters.visible = false
		print("Aamir: " + TARGET_BODY_NAME + " has left the interaction zone. Hiding prompt.")
