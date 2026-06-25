class_name Rollover
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	const STEPS: int = 16
	var pts := PackedVector2Array()
	for i: int in range(STEPS):
		var angle: float = TAU * float(i) / float(STEPS)
		pts.append(center + Vector2(cos(angle) * 16.0, sin(angle) * 8.0) * scale_f)
	canvas.draw_colored_polygon(pts, color)


func _draw() -> void:
	const STEPS: int = 16
	var pts := PackedVector2Array()
	for i: int in range(STEPS):
		var angle: float = TAU * float(i) / float(STEPS)
		pts.append(Vector2(cos(angle) * 16.0, sin(angle) * 8.0))
	draw_colored_polygon(pts, color)
