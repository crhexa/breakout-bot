extends Node

@onready var kill_area = $Environment/Walls/South
@onready var environment = $Environment
@onready var paddle = $Environment/Paddle
@onready var paddle_start = $Environment/PaddleMarker
@onready var label = $Interface/Points

@export var ball_start = Vector2(566, 580)

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
	deaths += 1
	update_interface()
	initialize()


func _on_brick_hit():
	points += 1
	update_interface()


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
	
