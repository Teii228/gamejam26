extends PathFollow2D

@export var speed: float = 0.2
@export var damage_to_base: float = 10.0

func _process(delta: float) -> void:
	# Om den inte är barn till en Path2D ännu, gör ingenting denna frame
	if not get_parent() is Path2D:
		return

	progress_ratio += delta * speed

	if progress_ratio >= 0.99:
		var current = get_tree().current_scene
	
	# Kolla om funktionen finns på rotnoden ELLER på barnet Map1
		if current.has_method("take_base_damage"):
			current.take_base_damage(damage_to_base)
		elif current.has_node("Map1") and current.get_node("Map1").has_method("take_base_damage"):
			current.get_node("Map1").take_base_damage(damage_to_base)
		
		queue_free()
