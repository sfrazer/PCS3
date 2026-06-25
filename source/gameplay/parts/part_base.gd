class_name PartBase
extends Node2D

signal scored(value: int)
signal target_hit(part_id: int)

@export var color: Color = Color.WHITE
@export var score_value: int = 100

var part_id: int = 0


func _draw() -> void:
	pass


func activate_physics() -> void:
	pass


func deactivate_physics() -> void:
	pass


func to_dict() -> Dictionary:
	return {}


func from_dict(_data: Dictionary) -> void:
	pass
