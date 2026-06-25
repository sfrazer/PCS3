class_name Spinner
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var w: float = 40.0 * scale_f
	var h: float = 6.0 * scale_f
	canvas.draw_rect(Rect2(center + Vector2(-w / 2.0, -h / 2.0), Vector2(w, h)), color)
	canvas.draw_line(center + Vector2(0.0, -h / 2.0 - 4.0 * scale_f), center + Vector2(0.0, h / 2.0 + 4.0 * scale_f), color.darkened(0.3), 1.0)


func _draw() -> void:
	draw_rect(Rect2(-20.0, -3.0, 40.0, 6.0), color)
	draw_line(Vector2(0.0, -7.0), Vector2(0.0, 7.0), color.darkened(0.3), 1.0)
