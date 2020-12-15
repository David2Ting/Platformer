extends KinematicBody2D

const speed = 100
var velocity = Vector2()
const gravity = 15 # Acceleration of gravity
const jump_power = -200 # Power of jump
const floor_direction = Vector2(0,-1) # Direction normal to floor

# Variables for variable jumping
var jump_count = 0
var max_jump_count = 10

# Variable score adding score
var score = 0

# Checking if player is alive
var is_alive = true

# Store reference to Menu
onready var menu = $"../UI/Menu"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
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

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision:
				if collision.collider.is_in_group("Trap"):
					die()
				if collision.collider.has_method("collide_with_player"):
					collision.collider.collide_with_player(self)

		check_jump_on_enemy(delta)

func check_jump_on_enemy(delta):
	# Function to check if the player is jumping on any enemies.
	if velocity.y > 0:
		for ray in $JumpCasts.get_children():
			ray.cast_to = Vector2(0,1) * velocity * delta + Vector2(0,1) # Set raycast to be 1 pixel larger than current down velocity
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider().is_in_group('Enemies'): # If the raycast is colliding with an Enemy, kill the enemy and jump.
				velocity.y = jump_power
				ray.get_collider().die()
				break

func win():
	is_alive = false
	$Sprite.play("hit")
	yield($Sprite,"animation_finished")
	menu.show()
	menu.get_node("Label").show()
	menu.get_node("Label").text = "Win\nScore: " + str(score)

func die():
	is_alive = false
	$Sprite.play("hit")
	yield($Sprite,"animation_finished")
	menu.show()
	menu.get_node("Label").show()
	menu.get_node("Label").text = "Game Over"

func reset_level():
	$"../AnimationPlayer".play("Fade Out")
	yield($"../AnimationPlayer","animation_finished")
	get_tree().reload_current_scene()
	
func increase_score():	
	score += 1

func _on_Finish_body_entered(body):
	# If player has entered the Finish Flag, trigger a level reset
	if body.name == "Player":
		win()
	pass # Replace with function body.


func _on_MenuButton_pressed():
	menu.show()
	pass # Replace with function body.


func _on_PlayButton_pressed():
	menu.hide()
	pass # Replace with function body.


func _on_ResetButton_pressed():
	reset_level()
	pass # Replace with function body.



func _on_level_pressed(level):
	print(level)
	pass # Replace with function body.
