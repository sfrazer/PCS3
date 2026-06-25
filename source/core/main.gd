extends Control

enum Mode { EDITOR, PLAY }

var current_mode: Mode = Mode.EDITOR


func _ready() -> void:
	current_mode = Mode.EDITOR


func switch_to_play() -> void:
	current_mode = Mode.PLAY
	# TODO Phase 9: hide editor UI, instantiate game.tscn, call activate_physics()


func switch_to_editor() -> void:
	current_mode = Mode.EDITOR
	# TODO Phase 9: free ball, call deactivate_physics(), restore editor UI
