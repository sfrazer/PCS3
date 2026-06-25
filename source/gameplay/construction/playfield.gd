extends Control

signal part_clicked(part: Node2D)
signal empty_clicked(position: Vector2)

const BORDER_COLOR: Color = Color(1.0, 0.0, 1.0)
const BORDER_WIDTH: float = 3.0
const BACKGROUND_COLOR: Color = Color(0.0, 0.0, 0.0)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _draw() -> void:
	_draw_background()
	_draw_border()


func _draw_background() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), BACKGROUND_COLOR)


func _draw_border() -> void:
	var inset: float = BORDER_WIDTH / 2.0
	var r: Rect2 = Rect2(
		Vector2(inset, inset),
		size - Vector2(BORDER_WIDTH, BORDER_WIDTH)
	)
	draw_rect(r, BORDER_COLOR, false, BORDER_WIDTH)


func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mb := event as InputEventMouseButton
	if not mb.pressed:
		return
	if mb.button_index == MOUSE_BUTTON_LEFT:
		var hit := _part_at(mb.position)
		if hit:
			part_clicked.emit(hit)
		else:
			empty_clicked.emit(mb.position)
	elif mb.button_index == MOUSE_BUTTON_RIGHT:
		var hit := _part_at(mb.position)
		if hit:
			part_clicked.emit(hit)


func _part_at(pos: Vector2) -> Node2D:
	for child in get_children():
		if child is Node2D:
			var local: Vector2 = child.to_local(pos + global_position)
			if local.length() < 40.0:
				return child as Node2D
	return null
