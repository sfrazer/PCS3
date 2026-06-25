extends VBoxContainer

signal part_type_selected(type: String)
signal tool_selected(tool_name: String)

const PART_DESCRIPTIONS: Dictionary = {
	"bumper": "Pop bumper — bounces ball in all directions. Scores on each hit.",
	"slingshot": "Slingshot — applies directional kick. Scores on each hit.",
	"drop_target": "Drop target — falls when hit, resets each ball.",
	"half_bumper": "Half bumper — bounces only on one face. Scores on hit.",
	"spinner": "Spinner — rotates as ball passes through. Scores per rotation.",
	"tunnel": "Tunnel — ball passes through channel. Scores on entry and exit.",
	"collector": "Collector — deflects ball left or right. Scores on contact.",
	"flipper_left": "Left flipper — player-controlled. Press Z to activate.",
	"flipper_right": "Right flipper — player-controlled. Press / to activate.",
	"plunger": "Plunger — hold Space to compress, release to fire the ball.",
	"rollover": "Rollover — flat switch ball rolls over. Scores on contact.",
	"rollover_edge": "Rollover edge — angled edge rollover switch.",
	"polygon": "Polygon — custom wall or guide shape. Draw with Polygon tool.",
}

@onready var _parts_grid: GridContainer = $PartsScrollArea/PartsGrid
@onready var _info_label: Label = $InfoPanel/InfoLabel
@onready var _icon_commands: GridContainer = $IconCommands


func _ready() -> void:
	_connect_part_buttons()
	_connect_icon_buttons()


func _connect_part_buttons() -> void:
	for child: Node in _parts_grid.get_children():
		if not child is Button:
			continue
		var button := child as Button
		var type: String = button.name
		button.text = ""
		var icon := PartIcon.new()
		icon.part_type = type
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		button.add_child(icon)
		button.mouse_entered.connect(func() -> void: _on_part_hovered(type))
		button.pressed.connect(func() -> void: part_type_selected.emit(type))


func _connect_icon_buttons() -> void:
	for child: Node in _icon_commands.get_children():
		if not child is Button:
			continue
		var button := child as Button
		var tool_name: String = button.name
		button.pressed.connect(func() -> void: tool_selected.emit(tool_name))


func _on_part_hovered(type: String) -> void:
	_info_label.text = PART_DESCRIPTIONS.get(type, type)
