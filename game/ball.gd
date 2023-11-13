extends RigidBody2D

@export var speed : float = 350.0
@export_range(0, 1.5) var spread : float = 1


func initialize(start_position : Vector2):
	var ball_direction : float = -1 * randf_range(spread, PI - spread)
	
	position = start_position
	linear_velocity = Vector2(speed, 0).rotated(ball_direction)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	print("bounce")
	return # TODO: bounce with constant speed
