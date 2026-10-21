extends Control

@onready var start_button := $Button

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main_game.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
