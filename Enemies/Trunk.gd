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
var is_shooting = false


var bullet = preload("res://Enemies/TrunkBullet.tscn")

func _ready():
		pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
		if not detected_player:
			velocity.x = speed * direction
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
			direction = direction * -1
			$RayCast2D.position.x *= -1
			$PlayerDetect.position.x *= -1
			$PlayerDetect.cast_to.x *= -1
		if $RayCast2D.is_colliding() == false:
			direction = direction * - 1
			$RayCast2D.position.x *= -1
			$PlayerDetect.position.x *= -1
			$PlayerDetect.cast_to.x *= -1
			
		if $PlayerDetect.is_colliding() and $PlayerDetect.get_collider().name == 'Player':
			detected_player = true
			if not is_shooting:
				is_shooting = true
				shoot()
		else:
			detected_player = false

func shoot():
	$AnimatedSprite.play("shoot")
	yield($AnimatedSprite,"animation_finished")
	var new_bullet = bullet.instance()
	add_child(new_bullet)
	new_bullet.position = $PlayerDetect.position
	new_bullet.direction = direction
	is_shooting = false

func die():
	is_alive = false
	$AnimatedSprite.play("hit")
	$CollisionShape2D.disabled = true
	yield($AnimatedSprite,"animation_finished")
	queue_free()
