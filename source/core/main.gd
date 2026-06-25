extends Control

signal mode_changed(mode: String)

enum Mode { EDITOR, PLAY }

var current_mode: Mode = Mode.EDITOR


func _ready() -> void:
	_enter_editor_mode()


func switch_to_play() -> void:
	current_mode = Mode.PLAY
	mode_changed.emit("play")


func switch_to_editor() -> void:
	current_mode = Mode.EDITOR
	mode_changed.emit("editor")


func _enter_editor_mode() -> void:
	current_mode = Mode.EDITOR
