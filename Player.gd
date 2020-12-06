extends KinematicBody2D

const speed = 100
var velocity = Vector2()
const gravity = 15 # Acceleration of gravity
const jump_power = -200 # Power of jump
const floor_direction = Vector2(0,-1) # Direction normal to floor

# Variables for variable jumping
var jump_count = 0
var max_jump_count = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Handle left and right movement
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$Sprite.play("run")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$Sprite.play("run")
		$Sprite.flip_h = true
	else:
		velocity.x = 0
		if is_on_floor():
			$Sprite.play("default")
	
	# Handle Jumping
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power
		elif jump_count < max_jump_count: #If jump is held for longer, increase jump size
			jump_count += 1
			velocity.y = jump_power
	
	if Input.is_action_just_released("jump") or is_on_ceiling(): # When you release jump, ensure you cannot jump again
		jump_count = max_jump_count
		
	if is_on_floor(): # Whenever on floor, reset jump_count
		jump_count = 0
	else:
		if velocity.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")

	velocity.y += gravity # Add the acceleration of gravity
	velocity = move_and_slide(velocity, floor_direction) # Do movement
