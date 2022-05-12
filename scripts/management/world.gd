extends Spatial
class_name Level

onready var map_manager: Node2D = get_node("MapManager")
onready var map: Spatial = get_node("Map")

var cells: Array = [
	[], #Y = -1
	[], #Y =  0
	[]  #Y =  1
]

var tiles_list: Array = [
	[], #Y = -1
	[], #Y =  0
	[]  #Y =  1
]

export(PackedScene) var Map

func _ready():
	apply_environment()
	generate_first_map()
	
	
func apply_environment() -> void:
	var environment = get_tree().root.world.fallback_environment
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color.black
	environment.ambient_light_color = Color("432d6d")
	environment.dof_blur_far_enabled = true
	environment.dof_blur_near_enabled = true
	
	
func generate_first_map() -> void:
	for tilemap in map_manager.get_children():
		var used_tiles = tilemap.get_used_cells()
		var tilemap_index: int = tilemap.get_index()
		for tile in used_tiles:
			var cell_id: int = tilemap.get_cellv(tile)
			create_cell(tile, tilemap_index, tilemap.y_level, cell_id)
			
		update_cells()
		
		
func generate_map() -> void:
	for tilemap in map_manager.get_children():
		var used_tiles = tilemap.get_used_cells()
		var tilemap_index: int = tilemap.get_index()
		for tile in used_tiles:
			if tiles_list[tilemap_index].find(tile) == -1:
				var cell_id: int = tilemap.get_cellv(tile)
				create_cell(tile, tilemap_index, tilemap.y_level, cell_id)
				
		update_cells()
		
		
func create_cell(tile: Vector2, tilemap_id: int, y_level: int, cell_id: int) -> void:
	var index_object = load(index_object(cell_id)).instance()
	if index_object is Ladder:
		index_object.rotation_degrees.y = 90 #Mutable logic
		
	index_object.y_level = y_level
	index_object.translation = Vector3(tile.x * Globals.GRID_SIZE, y_level, tile.y * Globals.GRID_SIZE)
	
	map.add_child(index_object)
	tiles_list[tilemap_id].append(tile)
	cells[tilemap_id].append([tile, index_object])
	
	
func update_cells() -> void:
	for cell in map.get_children():
		if cell is Cell:
			cell.update_faces(cells, tiles_list)
			
			
func index_object(cell_id: int) -> String:
	if cell_id == 1:
		return "res://scenes/env/ladder.tscn"
	else:
		return "res://scenes/env/cell.tscn"
