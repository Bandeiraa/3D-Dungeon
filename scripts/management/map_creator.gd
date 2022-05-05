extends TileMap
class_name MapCreator

func _ready() -> void:
	generate_random_tile()
	
	
func generate_random_tile() -> void:
	set_cellv(Vector2(0, 1), 0)
	get_tree().call_group("world", "generate_map")
	yield(get_tree().create_timer(5.0), "timeout")
	set_cellv(Vector2(0, 2), 0)
	get_tree().call_group("world", "generate_map")
