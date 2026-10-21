extends Node2D

@export var damage: float = 20.0

var enemies_in_range: Array = []
var current_target: Node2D = null

func _ready() -> void:
	print("--- TORNET ÄR LADDAT OCH I GÅNG ---")

func _process(_delta: float) -> void:
	update_target()
	
	if is_instance_valid(current_target):
		look_at(current_target.global_position)

func update_target() -> void:
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	
	if enemies_in_range.size() > 0:
		current_target = enemies_in_range[0]
	else:
		current_target = null

func _get_enemy_node(body: Node2D) -> Node2D:
	if body.has_method("take_damage"):
		return body
	elif body.get_parent() and body.get_parent().has_method("take_damage"):
		return body.get_parent()
	return null

func _on_range_area_body_entered(body: Node2D) -> void:
	print("UGGLAN SER NÅGOT: ", body.name)
	var enemy = _get_enemy_node(body)
	if enemy:
		print("Det var en giltig fiende!")
		if not enemies_in_range.has(enemy):
			enemies_in_range.append(enemy)
	else:
		print("Något gick in i cirkeln, men den har ingen take_damage()-funktion!")

func _on_range_area_body_exited(body: Node2D) -> void:
	print("NÅGOT LÄMNADE CIRKELN: ", body.name)
	var enemy = _get_enemy_node(body)
	if enemy and enemies_in_range.has(enemy):
		enemies_in_range.erase(enemy)

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(current_target):
		print("PANG! Skjuter på: ", current_target.name)
		if current_target.has_method("take_damage"):
			current_target.take_damage(damage)
	else:
		print("Timern slår, men har inget mål ännu...")
