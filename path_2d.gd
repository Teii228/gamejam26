extends Path2D

@export var object_scene: PackedScene
@export var max_spawns: int = 1  # Hur många som ska spawnas totalt
@export var spawn_interval: float = 1.0 # Sekunder mellan varje spawn

var spawned_count: int = 0
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(spawn_objekt)
	add_child(timer)

func spawn_objekt() -> void:
		
	# Om vi nått maxantalet, stoppa timern
	if spawned_count >= max_spawns:
		timer.stop()
		return
		
	var nytt_objekt = object_scene.instantiate()
	add_child(nytt_objekt)
	
	spawned_count += 1
