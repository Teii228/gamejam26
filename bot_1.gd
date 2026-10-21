extends PathFollow2D

@export var speed: float = 0.1
@export var damage_to_base: float = 10.0

func _process(delta: float) -> void:
	# Flytta fienden framåt
	progress_ratio += delta * speed

	# När fienden når slutet av banan
	if progress_ratio >= 0.99:
		var current = get_tree().current_scene
		
		# Skicka skada till Level eller Map1
		if current.has_method("take_base_damage"):
			current.take_base_damage(damage_to_base)
		elif current.has_node("Map1") and current.get_node("Map1").has_method("take_base_damage"):
			current.get_node("Map1").take_base_damage(damage_to_base)
			
		queue_free() # Ta bort fienden när den når slutet
