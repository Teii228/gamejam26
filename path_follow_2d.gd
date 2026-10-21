extends PathFollow2D

@export var speed: float = 0.1
@export var damage_to_base: float = 10.0

# --- HÄLSO-SYSTEM (Utan UI) ---
@export var max_hp: float = 50.0
var current_hp: float

func _ready() -> void:
	current_hp = max_hp

func _process(delta: float) -> void:
	# Flytta fienden framåt
	progress_ratio += delta * speed

	# När fienden nått slutet av banan
	if progress_ratio >= 0.99:
		var current = get_tree().current_scene
		
		if current.has_method("take_base_damage"):
			current.take_base_damage(damage_to_base)
		elif current.has_node("Map1") and current.get_node("Map1").has_method("take_base_damage"):
			current.get_node("Map1").take_base_damage(damage_to_base)
			
		queue_free()

# --- FUNKTION FÖR ATT TA SKADA FRÅN TORN ---
func take_damage(amount: float) -> void:
	current_hp -= amount
	print("Fiende tog ", amount, " skada! Kvarvarande HP: ", current_hp)
	
	if current_hp <= 0:
		die()

func die() -> void:
	# Radera fienden när HP når 0
	queue_free()
