extends Control
signal regenerateTrail

func _on_regenerate_trail_pressed() -> void:
	regenerateTrail.emit()
