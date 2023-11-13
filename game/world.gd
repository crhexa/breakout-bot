extends Node

@onready var kill_area = $Environment/Walls/South
@onready var environment = $Environment
@onready var label = $Interface/Points

@export var ball_start = Vector2(566, 438)

var ball : RigidBody2D
var ball_pscn : PackedScene

var points : int = 0
var deaths : int = 0


func _ready():
	Signals.game_restart.connect(_on_game_restart)
	ball_pscn = preload("res://game/ball.tscn")
	initialize()


func _on_game_restart():
	deaths += 1
	update_interface()
	initialize()


func initialize():
	if is_instance_valid(ball):
		for child in ball.get_children():
			child.queue_free()
		environment.call_deferred("remove_child", ball)
		ball.queue_free()
	
	ball = ball_pscn.instantiate()
	environment.call_deferred("add_child", ball)
	ball.initialize(ball_start, kill_area.get_rid())


func score():
	points += 1
	update_interface()
	
	
func update_interface():
	label.set_text("Points: %d \nDeaths: %d" % [points, deaths])
	
