extends Control

enum Mode { EDITOR, PLAY }

var current_mode: Mode = Mode.EDITOR

@onready var _parts_panel: VBoxContainer = $Layout/PartsPanel


func _ready() -> void:
	current_mode = Mode.EDITOR
	_parts_panel.part_type_selected.connect(_on_part_type_selected)
	_parts_panel.tool_selected.connect(_on_tool_selected)


func switch_to_play() -> void:
	current_mode = Mode.PLAY
	# TODO Phase 9: hide editor UI, instantiate game.tscn, call activate_physics()


func switch_to_editor() -> void:
	current_mode = Mode.EDITOR
	# TODO Phase 9: free ball, call deactivate_physics(), restore editor UI


func _on_part_type_selected(type: String) -> void:
	print("part_type_selected: ", type)


func _on_tool_selected(tool_name: String) -> void:
	print("tool_selected: ", tool_name)
