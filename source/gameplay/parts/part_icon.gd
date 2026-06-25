class_name PartIcon
extends Control

var part_type: String = ""


func _draw() -> void:
	if part_type.is_empty():
		return
	var center := size / 2.0
	var scale_f: float = 0.9
	match part_type:
		"bumper":
			Bumper.draw_icon(self, center, scale_f, Color.WHITE)
		"slingshot":
			Slingshot.draw_icon(self, center, scale_f, Color.CYAN)
		"drop_target":
			DropTarget.draw_icon(self, center, scale_f, Color.YELLOW)
		"half_bumper":
			HalfBumper.draw_icon(self, center, scale_f, Color.WHITE)
		"spinner":
			Spinner.draw_icon(self, center, scale_f, Color.GREEN)
		"tunnel":
			Tunnel.draw_icon(self, center, scale_f, Color(0.6, 0.6, 0.6, 1.0))
		"collector":
			Collector.draw_icon(self, center, scale_f, Color.ORANGE)
		"flipper_left":
			Flipper.draw_icon(self, center, scale_f, Color.CYAN, false)
		"flipper_right":
			Flipper.draw_icon(self, center, scale_f, Color.CYAN, true)
		"plunger":
			Plunger.draw_icon(self, center, scale_f, Color.WHITE)
		"rollover":
			Rollover.draw_icon(self, center, scale_f, Color.YELLOW)
		"rollover_edge":
			RolloverEdge.draw_icon(self, center, scale_f, Color.YELLOW)
		"polygon":
			PolygonWall.draw_icon(self, center, scale_f, Color.WHITE)
