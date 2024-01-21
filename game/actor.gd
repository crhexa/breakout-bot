extends AIController2D

var _world : Node
var move_action : float


func initialize(world : Node):
	_world = world
	
	
func get_obs() -> Dictionary:
	return {"obs" : _world.extract_features()}

func get_reward() -> float:	
	return _world.extract_reward()
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 1,
			"action_type": "continuous"
		}
	}
	
func set_action(action) -> void:	
	move_action = clampf(action["move_action"][0], -1.0, 1.0)
	
