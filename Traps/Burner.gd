extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_activating = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collide_with_player(player):
	if not is_activating:
		is_activating = true
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.play("fire")
		$"Fire/CollisionShape2D".disabled=false
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.play("default")
		is_activating = false
		$"Fire/CollisionShape2D".disabled=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Fire_body_entered(body):
	if body.name == 'Player':
		body.die()
	pass # Replace with function body.
