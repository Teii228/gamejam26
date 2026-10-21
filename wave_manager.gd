extends Node

signal wave_started(wave_number: int)
signal wave_finished(wave_number: int)
signal all_waves_completed

@export var enemy_scene: PackedScene
@export var path: Path2D
@export var wave_label: Label
@export var wave_button: Button
@export var enemies_per_spawn: int = 3      # hur många som spawnas varje gång timern tickar
@export var spawn_spacing: float = 30.0     # avstånd längs banan mellan dem (så de inte ligger ovanpå varandra)

## Varje siffra = antal fiender i den wavan. [5, 8, 12] = 3 waves.
@export var enemies_per_wave: Array[int] = [5, 8, 12, 15, 20]

@export var spawn_interval: float = 1.0       # sekunder mellan varje fiende
@export var time_between_waves: float = 5.0   # automatisk paus innan nästa wave

var current_wave: int = 0        # 0 = spelet har inte startat
var enemies_alive: int = 0
var enemies_left_to_spawn: int = 0

var _spawn_timer: Timer
var _wave_timer: Timer


func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.timeout.connect(_spawn_enemy)
	add_child(_spawn_timer)

	_wave_timer = Timer.new()
	_wave_timer.one_shot = true
	_wave_timer.wait_time = time_between_waves
	_wave_timer.timeout.connect(start_next_wave)
	add_child(_wave_timer)

	if wave_button:
		wave_button.pressed.connect(start_next_wave)

	_update_ui()


func start_next_wave() -> void:
	if current_wave >= enemies_per_wave.size():
		return

	_wave_timer.stop()  # avbryt väntan om vi skippar

	enemies_left_to_spawn += enemies_per_wave[current_wave]
	current_wave += 1
	wave_started.emit(current_wave)
	print("Wave ", current_wave, " startar")

	if _spawn_timer.is_stopped():
		_spawn_timer.wait_time = spawn_interval
		_spawn_timer.start()

	_update_ui()


func _spawn_enemy() -> void:
	if enemies_left_to_spawn <= 0:
		_spawn_timer.stop()
		return

	var count: int = min(enemies_per_spawn, enemies_left_to_spawn)

	for i in count:
		var enemy = enemy_scene.instantiate()
		path.add_child(enemy)

		# Sprid ut dem lite längs banan så de inte hamnar på samma punkt
		if "progress" in enemy:
			enemy.progress = i * spawn_spacing

		enemies_alive += 1
		enemies_left_to_spawn -= 1
		enemy.tree_exited.connect(_on_enemy_gone)

	if enemies_left_to_spawn <= 0:
		_spawn_timer.stop()

	var enemy = enemy_scene.instantiate()
	path.add_child(enemy)
	enemies_alive += 1
	enemies_left_to_spawn -= 1
	enemy.tree_exited.connect(_on_enemy_gone)

	if enemies_left_to_spawn <= 0:
		_spawn_timer.stop()


func _on_enemy_gone() -> void:
	enemies_alive -= 1
	_check_wave_finished()


func _check_wave_finished() -> void:
	if current_wave == 0 or enemies_left_to_spawn > 0 or enemies_alive > 0:
		return

	wave_finished.emit(current_wave)
	print("Wave ", current_wave, " klar!")

	if current_wave >= enemies_per_wave.size():
		all_waves_completed.emit()
		print("Alla waves klara! Du vann!")
		_update_ui()
	else:
		_wave_timer.start()  # nästa wave startar automatiskt efter pausen


func _update_ui() -> void:
	var total := enemies_per_wave.size()

	if wave_label:
		wave_label.text = "Wave " + str(current_wave) + " / " + str(total)

	if wave_button:
		if current_wave == 0:
			wave_button.text = "Starta spelet"
			wave_button.disabled = false
		elif current_wave < total:
			wave_button.text = "Skippa till wave " + str(current_wave + 1)
			wave_button.disabled = false
		else:
			wave_button.text = "Sista waven!"
			wave_button.disabled = true
