extends KinematicBody2D

var speed = 5
var velocity = Vector2()
const jump_power = -200
const floor_direction = Vector2(0,-1)
var on_ground = false

var direction = -1 # Handles the direction the enemy is moving in
var is_alive = true
var is_hitting = false
func _ready():
		pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
		velocity.x += speed * direction
		if !is_hitting:
			$AnimatedSprite.play("default")
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

		
		velocity = move_and_slide(velocity, floor_direction)
		
		if is_on_wall():
			yield(get_tree(), "physics_frame")
			direction = direction * -1
			if !is_hitting:
				if direction == 1:
					$AnimatedSprite.play("right")
				else:
					$AnimatedSprite.play("left")
				is_hitting = true
				$Timer.start()
			yield($Timer,"timeout")
			is_hitting = false
			

func die():
	is_alive = false
	$AnimatedSprite.play("hit")
	$CollisionShape2D.disabled = true
	yield($AnimatedSprite,"animation_finished")
	queue_free()
