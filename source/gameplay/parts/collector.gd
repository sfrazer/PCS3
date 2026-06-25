class_name Collector
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var pts := PackedVector2Array([
		center + Vector2(-20.0, -16.0) * scale_f,
		center + Vector2(20.0, 0.0) * scale_f,
		center + Vector2(-20.0, 16.0) * scale_f,
		center + Vector2(-10.0, 0.0) * scale_f,
	])
	canvas.draw_colored_polygon(pts, color)
	canvas.draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), color.lightened(0.2), 1.0)


func _draw() -> void:
	var pts := PackedVector2Array([
		Vector2(-20.0, -16.0),
		Vector2(20.0, 0.0),
		Vector2(-20.0, 16.0),
		Vector2(-10.0, 0.0),
	])
	draw_colored_polygon(pts, color)
	draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), color.lightened(0.2), 1.0)
