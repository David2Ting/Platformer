extends KinematicBody2D

const speed = 100
var velocity = Vector2()
const gravity = 15 # Acceleration of gravity
const jump_power = -200 # Power of jump
const floor_direction = Vector2(0,-1) # Direction normal to floor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Handle left and right movement
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
	else:
		velocity.x = 0
	
	# Handle Jumping
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power

	velocity.y += gravity # Add the acceleration of gravity
	velocity = move_and_slide(velocity, floor_direction) # Do movement
