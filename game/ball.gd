extends RigidBody2D

@export var speed : float = 450.0
@export_range(0, 1.5) var spread : float = 1

var killer : RID


func initialize(start_position : Vector2, killer_rid : RID):
	var ball_direction : float = -1 * randf_range(spread, PI - spread)
	
	killer = killer_rid
	position = start_position
	linear_velocity = Vector2(speed, 0).rotated(ball_direction)


func _on_body_shape_exited(body_rid, _body, _body_shape_index, _local_shape_index):
	if body_rid != killer:
		var direction = linear_velocity.angle()
		linear_velocity = Vector2(speed, 0).rotated(direction)

