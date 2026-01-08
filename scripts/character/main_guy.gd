extends CharacterBody2D

# --- Exported Variables (Tune in Inspector) ---

# Movement speed in pixels per second
@export var speed: float = 100.0

# --- Onready Variables ---

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Standard Godot Functions ---

func _physics_process(delta: float) -> void:
	# 1. Get Input Direction
	var input_direction: Vector2 = Input.get_vector(
		"walk_left", "walk_right", "walk_up", "walk_down"
	)

	# 2. Update Velocity
	velocity = input_direction * speed

	# 3. Handle Animation Logic
	_update_animation(input_direction)

	# 4. Move and Slide (Handles collision and movement)
	move_and_slide()

# --- Custom Animation Logic ---

func _update_animation(direction: Vector2) -> void:
	# Check if the character is moving (magnitude > 0)
	if direction.length_squared() > 0:
		# Character is moving
		
		# Determine the direction with the largest component
		if abs(direction.x) > abs(direction.y):
			# Horizontal movement is dominant
			if direction.x > 0:
				animated_sprite.play("walk_right")
			else:
				animated_sprite.play("walk_left")
		else:
			# Vertical movement is dominant or equal
			if direction.y > 0:
				animated_sprite.play("walk_down")
			else:
				animated_sprite.play("walk_up")
	else:
		# Character is not moving (Idle)
		
		# Check what the *last* played animation was to determine the facing direction for idle
		var current_animation = animated_sprite.get_animation()
		
		# We need an 'idle' version for each direction, but since you only have one "idle"
		# we'll default to playing just "idle" for simplicity, or try to infer:
		
		if current_animation.begins_with("walk_down"):
			animated_sprite.play("idle") # Assumes you might add directional idles later
		elif current_animation.begins_with("walk_up"):
			animated_sprite.play("idle")
		elif current_animation.begins_with("walk_left"):
			animated_sprite.play("idle")
		elif current_animation.begins_with("walk_right"):
			animated_sprite.play("idle")
		else:
			# Fallback to the generic "idle" animation
			animated_sprite.play("idle")


# --- Setup Notes (Before running the script) ---

# 1. Input Map: Go to Project -> Project Settings -> Input Map.
#    You must define the following four actions and assign keys:
#    * walk_up: (e.g., W, Up Arrow)
#    * walk_down: (e.g., S, Down Arrow)
#    * walk_left: (e.g., A, Left Arrow)
#    * walk_right: (e.g., D, Right Arrow)

# 2. Animations: Ensure your AnimatedSprite2D has the following animation names
#    exactly as written in the script:
#    * idle
#    * walk_down
#    * walk_left
#    * walk_right
#    * walk_up
#
#    Note: The 'idle' logic in the script is optimized to handle a single 'idle' 
#    animation but also provides comments for how to easily expand to 
#    'idle_down', 'idle_up', etc. later on for better looking idle states.
