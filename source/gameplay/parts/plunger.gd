class_name Plunger
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var lw: float = 10.0 * scale_f
	var lane_h: float = 28.0 * scale_f
	var spring_r: float = lw / 2.0
	var top: float = center.y - lane_h / 2.0
	canvas.draw_rect(Rect2(center.x - lw / 2.0, top, lw, lane_h), color)
	const STEPS: int = 10
	var spring_pts := PackedVector2Array()
	for i: int in range(STEPS + 1):
		var angle: float = PI * float(i) / float(STEPS)
		spring_pts.append(center + Vector2(cos(angle), sin(angle)) * spring_r + Vector2(0.0, lane_h / 2.0))
	canvas.draw_colored_polygon(spring_pts, color)


func _draw() -> void:
	draw_rect(Rect2(-5.0, -30.0, 10.0, 30.0), color)
	const STEPS: int = 10
	var pts := PackedVector2Array()
	for i: int in range(STEPS + 1):
		var angle: float = PI * float(i) / float(STEPS)
		pts.append(Vector2(cos(angle) * 5.0, sin(angle) * 5.0))
	draw_colored_polygon(pts, color)
