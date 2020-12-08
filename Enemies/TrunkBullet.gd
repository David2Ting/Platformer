extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction = 1
const speed = 150
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func die():
	queue_free()

func _physics_process(delta):
	if direction == 1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

	velocity.x = speed * direction - get_parent().velocity.x
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			if collision.collider.name == "Player":
				collision.collider.die()
			die()
	
