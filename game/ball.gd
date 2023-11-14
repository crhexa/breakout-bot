extends RigidBody2D

@export var speed : float = 450.0
@export_range(0, 1.5) var spread : float = 1

var killer : RID


func initialize(start_position : Vector2, killer_rid : RID):
	var ball_direction : float = -1 * randf_range(spread, PI - spread)
	
	killer = killer_rid
	position = start_position
	linear_velocity = Vector2(speed, 0).rotated(ball_direction)


func _on_body_shape_exited(body_rid, body, _body_shape_index, _local_shape_index):
	if body_rid != killer:
		var direction = linear_velocity.angle()
		
		if direction > 0 && direction < 0.5:
			direction = 0.5
			print("change1")
		elif direction < 0 && direction > -0.5:
			direction = -0.5
			print("change2")
		elif direction > 2.5:
			direction = 2.5
			print("change3")
		elif direction < -2.5:
			direction = -2.5
			print("change4")
		print(direction)
		
		linear_velocity = Vector2(speed, 0).rotated(direction)

		if body.has_method("lose_health"):
			body.lose_health()
	

