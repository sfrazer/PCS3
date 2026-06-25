class_name DropTarget
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var w: float = 28.0 * scale_f
	var h: float = 18.0 * scale_f
	canvas.draw_rect(Rect2(center + Vector2(-w / 2.0, -h / 2.0), Vector2(w, h)), color)
	canvas.draw_line(center + Vector2(-w / 2.0, -h / 2.0), center + Vector2(w / 2.0, -h / 2.0), Color.WHITE, 2.0 * scale_f)


func _draw() -> void:
	draw_rect(Rect2(-14.0, -9.0, 28.0, 18.0), color)
	draw_line(Vector2(-14.0, -9.0), Vector2(14.0, -9.0), Color.WHITE, 2.0)
