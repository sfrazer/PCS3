class_name HalfBumper
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	const STEPS: int = 16
	var pts := PackedVector2Array()
	pts.append(center)
	for i: int in range(STEPS + 1):
		var angle: float = -PI / 2.0 + PI * float(i) / float(STEPS)
		pts.append(center + Vector2(cos(angle), sin(angle)) * 20.0 * scale_f)
	canvas.draw_colored_polygon(pts, color)
	canvas.draw_line(center + Vector2(0.0, -20.0) * scale_f, center + Vector2(0.0, 20.0) * scale_f, color.lightened(0.3), 2.0 * scale_f)


func _draw() -> void:
	const STEPS: int = 16
	var pts := PackedVector2Array()
	pts.append(Vector2.ZERO)
	for i: int in range(STEPS + 1):
		var angle: float = -PI / 2.0 + PI * float(i) / float(STEPS)
		pts.append(Vector2(cos(angle), sin(angle)) * 20.0)
	draw_colored_polygon(pts, color)
	draw_line(Vector2(0.0, -20.0), Vector2(0.0, 20.0), color.lightened(0.3), 2.0)
