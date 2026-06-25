class_name Tunnel
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var len: float = 28.0 * scale_f
	var hw: float = 10.0 * scale_f
	var lw: float = 2.0 * scale_f
	canvas.draw_line(center + Vector2(-len, -hw), center + Vector2(len, -hw), color, lw)
	canvas.draw_line(center + Vector2(-len, hw), center + Vector2(len, hw), color, lw)
	canvas.draw_line(center + Vector2(-len, -hw), center + Vector2(-len, hw), color, lw)
	canvas.draw_line(center + Vector2(len, -hw), center + Vector2(len, hw), color, lw)


func _draw() -> void:
	draw_line(Vector2(-30.0, -10.0), Vector2(30.0, -10.0), color, 2.0)
	draw_line(Vector2(-30.0, 10.0), Vector2(30.0, 10.0), color, 2.0)
	draw_line(Vector2(-30.0, -10.0), Vector2(-30.0, 10.0), color, 2.0)
	draw_line(Vector2(30.0, -10.0), Vector2(30.0, 10.0), color, 2.0)
