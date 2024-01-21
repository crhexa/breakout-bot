extends RigidBody2D

@export var speed : float = 450.0
@export_range(0, 1.5) var spread : float = 1

var killer : RID
var paddle : RID
var world : Node


func initialize(start_position : Vector2, killer_rid : RID, paddle_rid : RID, _world : Node):
	var ball_direction : float = -1 * randf_range(spread, PI - spread) # -1.18 
	if OS.is_debug_build():
		ball_direction = -1.18
	
	killer = killer_rid
	paddle = paddle_rid
	world = _world
	position = start_position
	linear_velocity = Vector2(speed, 0).rotated(ball_direction)


func _on_body_shape_exited(body_rid, body, _body_shape_index, _local_shape_index):
	if body_rid != killer:
		var direction : float = linear_velocity.angle()
		var negative : bool = direction < 0
		
		direction = abs(direction)
		var upper = (0.5 * direction) + ((PI-0.5) * 0.5)
		var lower = (0.5 * direction) + 0.25

		direction = min(max(direction, lower), upper)
		if negative:
			direction *= -1
		
		linear_velocity = Vector2(speed, 0).rotated(direction)

		if body.has_method("lose_health"):
			body.lose_health()
			
		if body_rid == paddle:
			world.score()
	

