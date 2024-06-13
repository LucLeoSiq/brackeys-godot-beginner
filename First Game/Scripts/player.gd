extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const JUMP_BUFFER_TIME = 0.2 # Time in seconds to buffer jump input

@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var jump_buffer_timer = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle jump buffer timerS
	elif Input.is_action_just_pressed("jump") and !is_on_floor():
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0

	# Get the input direction> -1, 0 , 1 
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0: 
		animated_sprite_2d.flip_h = false
	if direction < 0: 
		animated_sprite_2d.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
	# Apply Movement 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
