extends KinematicBody2D

var speed = 50
var velocity = Vector2()
const gravity = 15
const jump_power = -200
const floor_direction = Vector2(0,-1)
var on_ground = false

var direction = -1 # Handles the direction the enemy is moving in
var is_alive = true
var detected_player = false
var is_charging = false
func _ready():
		pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
		if not detected_player and !is_charging:
			velocity.x = speed * direction
			$AnimatedSprite.play("run")
		elif is_charging:
			velocity.x = speed * 3 * direction
			$AnimatedSprite.play("run")
		else:
			velocity.x = 0

		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		
		
		velocity.y += gravity
		velocity = move_and_slide(velocity, floor_direction)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision:
				if collision.collider.name == 'Player':
					collision.collider.die()

		if is_on_wall():
			if is_charging:
				$AnimatedSprite.play("collide")
			is_charging = false
			direction = direction * -1
			$RayCast2D.position.x *= -1
			$PlayerDetect.position.x *= -1
			$PlayerDetect.cast_to.x *= -1
		if $RayCast2D.is_colliding() == false and !is_charging:
			direction = direction * - 1
			$RayCast2D.position.x *= -1
			$PlayerDetect.position.x *= -1
			$PlayerDetect.cast_to.x *= -1
			
		if $PlayerDetect.is_colliding() and $PlayerDetect.get_collider().name == 'Player':
			detected_player = true
			if not is_charging:
				is_charging = true
		else:
			detected_player = false
 
func die():
	is_alive = false
	$AnimatedSprite.play("hit")
	$CollisionShape2D.disabled = true
	yield($AnimatedSprite,"animation_finished")
	queue_free()
