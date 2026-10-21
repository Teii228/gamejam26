extends Node2D

@export var path_map: TileMapLayer

func is_path_cell(cell: Vector2i) -> bool:
	return path_map.get_cell_source_id(cell) != -1
