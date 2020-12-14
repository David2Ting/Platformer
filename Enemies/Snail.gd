extends KinematicBody2D

var speed = 20
var velocity = Vector2()
const gravity = 15
const jump_power = -200
const floor_direction = Vector2(0,-1)
var on_ground = false

var direction = -1 # Handles the direction the enemy is moving in
var is_alive = true

func _ready():
		pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
		velocity.x = speed * direction
		$AnimatedSprite.play("run")
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
			yield(get_tree(), "physics_frame")
			direction = direction * -1
			$RayCast2D.position.x = -$RayCast2D.position.x
			
		if $RayCast2D.is_colliding() == false:
			direction = direction * - 1
			$RayCast2D.position.x = -$RayCast2D.position.x


func die():
	is_alive = false
	$AnimatedSprite.play("hit")
	$CollisionShape2D.disabled = true
	yield($AnimatedSprite,"animation_finished")
	queue_free()
