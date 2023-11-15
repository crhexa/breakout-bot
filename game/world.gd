extends Node

@onready var kill_area = $Environment/Walls/South
@onready var environment = $Environment
@onready var paddle = $Environment/Paddle
@onready var paddle_start = $Environment/PaddleMarker
@onready var label = $Interface/Points
@onready var actor = $Actor

@export var ball_start = Vector2(566, 580)

var paddle_half : float = 112.0

var ball : RigidBody2D
var ball_pscn : PackedScene

var points : int = 0
var deaths : int = 0


func _ready():
	#Engine.set_time_scale(4)
	#Engine.set_max_physics_steps_per_frame(16)
	#Engine.set_physics_ticks_per_second(240)
	
	Signals.game_restart.connect(_on_game_restart)
	Signals.brick_hit.connect(_on_brick_hit)
	ball_pscn = preload("res://game/ball.tscn")
	initialize()


func _on_game_restart():
	actor.write(extract_features())
	deaths += 1
	update_interface()
	initialize()


func _on_brick_hit():
	score()


func initialize():
	if is_instance_valid(ball):
		for child in ball.get_children():
			child.queue_free()
		environment.call_deferred("remove_child", ball)
		ball.queue_free()
	
	ball = ball_pscn.instantiate()
	environment.call_deferred("add_child", ball)
	ball.initialize(ball_start, kill_area.get_rid())
	paddle.call_deferred("set_position", paddle_start.position)


func score():
	points += 1
	update_interface()
	
	
func update_interface():
	label.set_text("Points: %d \nDeaths: %d" % [points, deaths])
	

func extract_features() -> PackedFloat32Array:
	return PackedFloat32Array([ball.position.x, ball.position.y, ball.linear_velocity.x, ball.linear_velocity.y, paddle.position.x+paddle_half])
	
