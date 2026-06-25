class_name PolygonWall
extends PartBase

@export var points: PackedVector2Array = PackedVector2Array([
	Vector2(-20.0, -20.0),
	Vector2(20.0, -20.0),
	Vector2(20.0, 20.0),
	Vector2(-20.0, 20.0),
])


static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	var pts := PackedVector2Array([
		center + Vector2(-18.0, -18.0) * scale_f,
		center + Vector2(18.0, -10.0) * scale_f,
		center + Vector2(18.0, 18.0) * scale_f,
		center + Vector2(-10.0, 18.0) * scale_f,
	])
	canvas.draw_colored_polygon(pts, color)
	canvas.draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), color.lightened(0.3), 1.5)


func _draw() -> void:
	if points.size() < 3:
		return
	draw_colored_polygon(points, color)
	var outline: PackedVector2Array = points + PackedVector2Array([points[0]])
	draw_polyline(outline, color.lightened(0.3), 1.5)
