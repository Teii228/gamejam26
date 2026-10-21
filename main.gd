extends Node2D

@export var max_base_hp: float = 100.0
var current_base_hp: float

# Dra in din ProgressBar hit från trädet med Ctrl nedtryckt:
@onready var base_health_bar: ProgressBar = $UI/ProgressBar

func _ready() -> void:
	current_base_hp = max_base_hp
	if base_health_bar:
		base_health_bar.max_value = max_base_hp
		base_health_bar.value = current_base_hp

func take_base_damage(amount: float) -> void:
	current_base_hp -= amount
	print("Basen tog skada! Kvarvarande HP: ", current_base_hp)

	if base_health_bar:
		base_health_bar.value = current_base_hp

	if current_base_hp <= 0:
		print("Game Over!")
