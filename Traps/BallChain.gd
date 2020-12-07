extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, "Spin", "Pendulum") var type
export(float) var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(type)
	$AnimationPlayer.playback_speed = speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
