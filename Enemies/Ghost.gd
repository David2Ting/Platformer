extends KinematicBody2D

var speed = 50
var velocity = Vector2()

var direction = -1 # Handles the direction the enemy is moving in
var is_alive = true
var player_pos = Vector2()
var player_direction = Vector2()
func _ready():
		pass # Replace with function body.

func _physics_process(delta):
	if is_alive:
		$AnimatedSprite.play("run")
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

		player_pos = get_node("/root/World/Player").global_position

		player_direction = player_pos-self.global_position
		if player_direction and abs(player_direction.length())<150:
			if player_direction.x > 0:
				direction = 1
			else:
				direction = -1
			velocity = player_direction.normalized()*speed
		else:
			velocity = Vector2()
		velocity = move_and_slide(velocity)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision:
				if collision.collider.name == 'Player':
					collision.collider.die()


func die():
	is_alive = false
	$AnimatedSprite.play("hit")
	$CollisionShape2D.disabled = true
	yield($AnimatedSprite,"animation_finished")
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.die()
	pass # Replace with function body.
