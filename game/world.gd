extends Node

@onready var kill_area = $Environment/Walls/South
@onready var environment = $Environment
@onready var paddle = $Environment/Paddle
@onready var paddle_start = $Environment/PaddleMarker
@onready var label = $Interface/Points
@onready var flabel = $Interface/Features
@onready var actor = $Actor

@onready var left = $Environment/Walls/WallMarkerLeft
@onready var right = $Environment/Walls/WallMarkerRight

@export var ball_start = Vector2(566, 580)

var paddle_half : float = 56.0

var ball : RigidBody2D
var ball_pscn : PackedScene

var points : float = 0
var deaths : int = 0
var streak : int = 0

var timer : float = 1
var timer_ended : bool = false


func _ready():
	Signals.game_restart.connect(_on_game_restart)
	Signals.brick_hit.connect(_on_brick_hit)
	ball_pscn = preload("res://game/ball.tscn")
	initialize()
	actor.initialize(self)
	

func _physics_process(delta):
	if actor.needs_reset:
		actor.reset()
		return
	
	var paddle_center = Vector2(paddle.position.x + paddle_half, paddle.position.y)
	
	if timer_ended:
		points += delta * (25 / ball.position.distance_to(paddle_center))
		points += delta * (1 / abs(paddle_center.x - ball.position.x))
		update_interface()
		
	else:
		timer -= delta
		if timer < 0:
			timer_ended = true
	
	var action : float = actor.move_action
	if action > 0.1:
		paddle.move_right()
	
	elif action < -0.1:
		paddle.move_left()
		
	else:
		paddle.move_stop()


func _on_game_restart():
	deaths += 1
	points = 0.0
	streak = 0
	timer = 1
	timer_ended = false
	update_interface()
	initialize()
	actor.done = true
	actor.needs_reset = true


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
	ball.initialize(ball_start, kill_area.get_rid(), paddle.get_rid(), self)
	paddle.call_deferred("set_position", paddle_start.position)


func score():
	points += 1.0
	if streak > 0:
		points += log(float(streak))
	
	streak += 1
	update_interface()
	
	
func update_interface():
	label.set_text("Reward: %.2f \nStreak: %d\nDeaths: %d" % [points, streak, deaths])
	
	
func update_features(arr : Array[float]):
	flabel.set_text("ball_pos_x: %.2f\nball_pos_y: %.2f\nball_vel_x: %.2f\nball_vel_y %.2f\npaddle_x: %.2f" % arr)
	
	
func clamp_array(arr : Array[float]) -> Array[float]:
	for i in range(len(arr)):
		arr[i] = clampf(arr[i], -1, 1)
		if is_nan(arr[i]) or is_inf(arr[i]):
			printerr("Error: NAN or INF value in feature %d" % i)
				
	return arr
	

func extract_features() -> Array[float]:
	var ball_pos : Vector2 = (ball.position - left.position) / (right.position - left.position)
	var padd_pos : float = (paddle.position.x - left.position.x) / (right.position.x - 112.0 - left.position.x)
	ball_pos = (2 * ball_pos) - Vector2(1,1)
	padd_pos = (2 * padd_pos) - 1
	
	var features : Array[float] = clamp_array(
		[ball_pos.x, 
		 ball_pos.y, 
		 ball.linear_velocity.x / 450, 
		 ball.linear_velocity.y / 450, 
		 padd_pos] as Array[float])
	
	update_features(features)
	return features
	

func extract_reward() -> float:
	return points
