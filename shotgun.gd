extends Node2D

@export var damage: float = 25.0
@export var attack_range: float = 200.0

var enemies_in_range: Array = []
var current_target: Node2D = null

func _ready() -> void:
	$ShootTimer.start()  # ta bort om du har Autostart på

func _process(_delta: float) -> void:
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	current_target = _find_first_enemy()

	if is_instance_valid(current_target):
		look_at(current_target.global_position)

func _find_first_enemy() -> Node2D:
	# Går igenom listan i ordning och tar första fienden som faktiskt är inom range
	for e in enemies_in_range:
		if global_position.distance_to(e.global_position) <= attack_range:
			return e
	return null

func _get_enemy(body: Node) -> Node:
	if body.has_method("take_damage"):
		return body
	var parent = body.get_parent()
	if parent and parent.has_method("take_damage"):
		return parent
	return null

func _on_range_area_body_entered(body: Node2D) -> void:
	var enemy = _get_enemy(body)
	if enemy and not enemies_in_range.has(enemy):
		enemies_in_range.append(enemy)

func _on_range_area_body_exited(body: Node2D) -> void:
	var enemy = _get_enemy(body)
	if enemy:
		enemies_in_range.erase(enemy)

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(current_target):
		current_target.take_damage(damage)
