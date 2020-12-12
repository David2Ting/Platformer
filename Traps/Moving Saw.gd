extends Node2D
export var playback_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.playback_speed = playback_speed
	pass # Replace with function body.


