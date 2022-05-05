extends Spatial
class_name Level

const CELL: PackedScene = preload("res://scenes/env/cell.tscn")

onready var tilemap: TileMap = get_node("Management/MapCreator")

var cells: Array = []
var tiles_list: Array = []

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
	var used_tiles = tilemap.get_used_cells()
	for tile in used_tiles:
		create_cell(tile)
		
	update_cells(used_tiles)
	
	
func generate_map() -> void:
	var used_tiles = tilemap.get_used_cells()
	for tile in used_tiles:
		if tiles_list.find(tile) == -1:
			create_cell(tile)
			
	update_cells(used_tiles)
	
	
func create_cell(tile: Vector2) -> void:
	var cell: Cell = CELL.instance()
	add_child(cell)
	cell.translation = Vector3(tile.x*Globals.GRID_SIZE, 0, tile.y*Globals.GRID_SIZE)
	cells.append(cell)
	tiles_list.append(tile)
	
	
func update_cells(used_tiles: Array) -> void:
	for cell in cells:
		cell.update_faces(used_tiles)
