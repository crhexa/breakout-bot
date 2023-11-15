extends Node

@export_file("*.py") var filepath : String

@onready var process : ProcessNode = $ProcessNode

var finished : bool = false



func _ready():
	var global_path = ProjectSettings.globalize_path(filepath)
	create(PackedStringArray([global_path]))


func create(args : PackedStringArray):
	print("Actor: running %s" % args[0].get_file())
	process.set_cmd("python")
	process.set_args(args)
	process.start()
	
	
func write(array : PackedFloat32Array) -> void:
	if not finished:
		process.write_stdin(array.to_byte_array())


func _on_process_node_stdout(data):
	print(data.get_string_from_ascii())


func _on_process_node_stderr(data):
	print(data.get_string_from_ascii())


func _on_process_node_finished(_data):
	finished = true
	print("Actor: process finished")


