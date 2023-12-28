extends Control


enum BrickTiling {Default, Diamond, Antidiamond, Layers}
@export var config : BrickTiling
@export var tile_size : int = 16
@export var max_width : int = 3
@export_range(1, 10) var difficulty : int = 10

var brick_pscn : PackedScene
var bounds : Vector2i
var grid_tiles : Vector2i
var tile_number : int = 0


func _ready():
	#brick_pscn = preload("res://game/brick.tscn")
	#set_grid()
	#tile_default(difficulty)
	return
	

func set_grid():
	bounds = Vector2i(self.size)
	grid_tiles = bounds / tile_size


func add_brick(health : int, width : int, brick_scale : float = 1.0) -> StaticBody2D:
	var brick : StaticBody2D = brick_pscn.instantiate()
	if brick_scale != 1.0:
		brick.set_scale(Vector2(brick_scale, brick_scale))
	
	brick.width = width
	brick.health = health
	add_child(brick)
	tile_number += 1
	return brick
	
	
func tile_default(strength : int) -> void:
	var brick_offset : int = 0
	
	for row in range(grid_tiles.y):
		var health = min(max(1, strength-row), 10)
		
		if brick_offset > 0:
			add_brick(health, brick_offset).set_position(Vector2(0, row*tile_size))
		
		while (brick_offset + max_width) < grid_tiles.x:
			add_brick(health, max_width).set_position(Vector2(brick_offset*tile_size, row*tile_size))
			brick_offset += max_width
			
		var remaining = grid_tiles.x - brick_offset
		if remaining > 0:
			add_brick(health, remaining).set_position(Vector2(brick_offset*tile_size, row*tile_size))
			
		brick_offset = max_width - remaining
