class_name Flipper
extends PartBase

@export var is_right: bool = false


static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color, right: bool = false) -> void:
	var flip_x: float = -1.0 if right else 1.0
	var pts := PackedVector2Array([
		center + Vector2(-30.0 * flip_x, 8.0) * scale_f,
		center + Vector2(30.0 * flip_x, 3.0) * scale_f,
		center + Vector2(30.0 * flip_x, -3.0) * scale_f,
		center + Vector2(-30.0 * flip_x, -8.0) * scale_f,
	])
	canvas.draw_colored_polygon(pts, color)
	canvas.draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), color.lightened(0.25), 1.0)


func _draw() -> void:
	if is_right:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
	var pts := PackedVector2Array([
		Vector2(0.0, 8.0),
		Vector2(60.0, 3.0),
		Vector2(60.0, -3.0),
		Vector2(0.0, -8.0),
	])
	draw_colored_polygon(pts, color)
	draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), color.lightened(0.25), 1.0)
