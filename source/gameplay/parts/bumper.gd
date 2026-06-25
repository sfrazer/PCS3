class_name Bumper
extends PartBase

static func draw_icon(canvas: CanvasItem, center: Vector2, scale_f: float, color: Color) -> void:
	canvas.draw_circle(center, 20.0 * scale_f, color)
	canvas.draw_arc(center, 24.0 * scale_f, 0.0, TAU, 32, color, 2.0 * scale_f)
	canvas.draw_circle(center + Vector2(-6.0, -6.0) * scale_f, 4.0 * scale_f, Color.WHITE.lerp(color, 0.3))


func _draw() -> void:
	draw_circle(Vector2.ZERO, 20.0, color)
	draw_arc(Vector2.ZERO, 24.0, 0.0, TAU, 32, color, 2.0)
	draw_circle(Vector2(-6.0, -6.0), 4.0, Color.WHITE.lerp(color, 0.3))
