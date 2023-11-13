extends Node

@onready var ball = $Ball

@export var ball_start = Vector2(566, 438)


func _ready():
	initialize()

func initialize():
	ball.initialize(ball_start)
