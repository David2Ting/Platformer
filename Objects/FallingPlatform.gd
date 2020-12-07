extends KinematicBody2D

var velocity = Vector2()
const gravity = 15
var fallen = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var reset_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y += gravity * delta
	position += velocity

func collide_with_player(obj):
	if !fallen:
		fallen = true
		$AnimationPlayer.play("Shake")
		velocity = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	set_physics_process(true)
	$ResetTimer.start()
	pass # Replace with function body.


func _on_ResetTimer_timeout():
	set_physics_process(false)
	yield(get_tree(),"physics_frame")
	var original_collision = collision_layer
	collision_layer = 0
	global_position = reset_position
	print('reset')
	yield(get_tree(), "physics_frame")
	collision_layer = original_collision
	fallen = false
	pass # Replace with function body.
