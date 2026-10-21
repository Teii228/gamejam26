extends Node2D

@export var ground: TileMapLayer
@export var path: TileMapLayer
@export var towers: Node2D

@export var tower_scene: PackedScene
@export var tower_texture: Texture2D

var placing_tower := false
var ghost: Sprite2D
var occupied_cells: Dictionary = {}


func _ready() -> void:
	# Registrera torn som redan finns på kartan.
	for tower in towers.get_children():
		var cell: Vector2i = ground.local_to_map(
			ground.to_local(tower.global_position)
		)
		occupied_cells[cell] = true


func start_placing() -> void:
	cancel_placing()

	placing_tower = true

	ghost = Sprite2D.new()
	ghost.texture = tower_texture
	ghost.modulate = Color(0.2, 1.0, 0.2, 0.5)
	ghost.z_index = 100

	add_child(ghost)


func cancel_placing() -> void:
	placing_tower = false

	if is_instance_valid(ghost):
		ghost.queue_free()

	ghost = null


func _process(_delta: float) -> void:
	if not placing_tower or not is_instance_valid(ghost):
		return

	var cell := get_mouse_cell()

	# Flytta spöktorn till rutans mitt.
	ghost.global_position = ground.to_global(
		ground.map_to_local(cell)
	)

	if can_place_tower(cell):
		ghost.modulate = Color(0.2, 1.0, 0.2, 0.5)
	else:
		ghost.modulate = Color(1.0, 0.2, 0.2, 0.5)


func get_mouse_cell() -> Vector2i:
	var mouse_local := ground.to_local(
		get_global_mouse_position()
	)
	return ground.local_to_map(mouse_local)


func can_place_tower(cell: Vector2i) -> bool:
	# Det måste finnas en markruta.
	if ground.get_cell_source_id(cell) == -1:
		return false

	# Vägen måste vara fri från torn.
	if path.get_cell_source_id(cell) != -1:
		return false

	# Endast ett torn per ruta.
	if occupied_cells.has(cell):
		return false

	return true


func place_tower(cell: Vector2i) -> void:
	if not can_place_tower(cell):
		return

	var tower := tower_scene.instantiate() as Node2D
	towers.add_child(tower)

	tower.global_position = ground.to_global(
		ground.map_to_local(cell)
	)

	occupied_cells[cell] = true


func _unhandled_input(event: InputEvent) -> void:
	# Tryck T för att börja placera ett torn.
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_1:
				start_placing()

			elif event.keycode == KEY_ESCAPE:
				cancel_placing()

	if not placing_tower:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_tower(get_mouse_cell())

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placing()
