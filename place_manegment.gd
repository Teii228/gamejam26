
extends Node2D

@export var tower_scene: PackedScene

@onready var towers = $"../towers"

var placing_tower = false


func _unhandled_input(event):
	# Tryck på 1 för att aktivera placeringsläget
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_1:
				placing_tower = true

	# Vänsterklick för att placera tornet
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and placing_tower:
				place_tower()


func place_tower():
	var tower = tower_scene.instantiate()

	towers.add_child(tower)
	tower.global_position = get_global_mouse_position()

	placing_tower = false
