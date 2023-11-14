extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var inner = $Outer/MarginContainer/Inner
@onready var outer = $Outer

@export var colors = PackedColorArray(
	[Color("#6efa75"),Color("#95e953"),Color("#b0d835"),Color("#c4c51c"),Color("#d4b20f"),
	 Color("#e09e16"),Color("#e78a25"),Color("#ea7735"),Color("#e86344"),Color("#e25252")])

var health : int = 1
var width : int = 1


func _ready():
	if health > 0:
		inner.set_color(colors[min(health-1, 10)])
	
	if width > 0:
		set_width()


func lose_health():
	health -= 1
	if health < 1:
		disappear()
	else:
		inner.set_color(colors[health-1])
	Signals.brick_hit.emit()
		
		
func disappear():
	collision.set_deferred("disabled", true)
	outer.set_visible(false)


func set_width():
	var current_size : Vector2 = outer.get_size()
	var current_pos : Vector2 = collision.get_position()
	
	collision.apply_scale(Vector2(width, 1))
	collision.set_position(Vector2(current_pos.x * width, current_pos.y))
	outer.set_size(Vector2(current_size.x * width, current_size.y))
