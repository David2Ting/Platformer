extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collide_with_player(player):
	player.velocity.y -= 500
	player.move_and_slide(player.velocity)
	$AnimatedSprite.play("spring")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
