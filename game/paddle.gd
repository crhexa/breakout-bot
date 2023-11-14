extends AnimatableBody2D

@onready var collision = $CollisionShape2D
@onready var rectangle = $ColorRect

@export var x_velocity : float = 600.0
@export var controllable : bool = true

var v : Vector2
var y : float
var input_left : bool = false
var input_right : bool = false


func _ready():
	v = Vector2(x_velocity, 0)
	y = position.y


func _process(_delta):
	if controllable:
		input_left = Input.is_action_pressed("move_left")
		input_right = Input.is_action_pressed("move_right")


func _physics_process(delta):
	if input_left:
		if input_right:
			return
		
		move_and_collide(delta * v * -1)
		
	elif input_right:
		move_and_collide(delta * v)
		
	position.y = y
		

# Called by the AI
func move_left():
	input_left = true
	input_right = false

func move_right():
	input_right = true
	input_left = false
