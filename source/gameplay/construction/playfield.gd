extends Control

const BORDER_COLOR: Color = Color(1.0, 0.0, 1.0)
const BORDER_WIDTH: float = 3.0
const BACKGROUND_COLOR: Color = Color(0.0, 0.0, 0.0)


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
