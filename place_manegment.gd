extends Node2D

@export var tower_scene: PackedScene
@export var grid_size: float = 64.0

@onready var towers = $"../towers"

var placing_tower = false


# Hanterar tangenttryckningar och musklick
func _unhandled_input(event):
	# Tryck på 1 för att välja ett torn
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_1:
				placing_tower = true

	# Vänsterklick för att placera tornet
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and placing_tower:
				place_tower()


# Omvandlar en världsposition till en rutkoordinat
func world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(pos.x / grid_size),
		floori(pos.y / grid_size)
	)


# Hämtar mitten av en ruta
func cell_to_world(cell: Vector2i) -> Vector2:
	return (
		Vector2(cell) + Vector2(0.5, 0.5)
	) * grid_size


# Kontrollerar om en ruta redan innehåller ett torn
func is_cell_occupied(cell: Vector2i) -> bool:
	for tower in towers.get_children():
		var tower_cell = world_to_cell(
			tower.global_position
		)

		if tower_cell == cell:
			return true

	return false


# Kontrollerar om det finns en tile på väglagret
func is_on_path(world_pos: Vector2) -> bool:
	var path_layer = $"../Path"

	var local_pos = path_layer.to_local(world_pos)
	var tile_pos = path_layer.local_to_map(local_pos)

	return path_layer.get_cell_source_id(tile_pos) != -1


# Försöker placera tornet
func place_tower():
	var mouse_pos = get_global_mouse_position()
	var cell = world_to_cell(mouse_pos)
	var tower_position = cell_to_world(cell)

	# Kontrollera om rutan ligger på vägen
	if is_on_path(tower_position):
		print("Du kan inte placera torn på vägen!")
		return

	# Kontrollera om rutan redan är upptagen
	if is_cell_occupied(cell):
		print("Rutan är redan upptagen!")
		return

	# Skapa och placera tornet
	var tower = tower_scene.instantiate()
	towers.add_child(tower)

	tower.global_position = tower_position

	# Avsluta placeringsläget
	placing_tower = false
	
