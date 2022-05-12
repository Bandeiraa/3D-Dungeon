extends Spatial
class_name Cell

onready var tween: Tween = get_node("Tween")

onready var north_face: MeshInstance = get_node("NorthFace")
onready var south_face: MeshInstance = get_node("SouthFace")
onready var east_face: MeshInstance = get_node("EastFace")
onready var west_face: MeshInstance = get_node("WestFace")

onready var bottom_face: MeshInstance = get_node("BottomFace")
onready var top_face: MeshInstance = get_node("TopFace")

onready var faces_list: Array = [
	north_face,
	south_face,
	east_face,
	west_face,
	bottom_face,
	top_face
]

var directions_list: Array = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.ZERO,
	Vector2.ONE
]

var y_level: int
var cell_id: int

var object_name: String = "Cell"

func _ready() -> void:
	define_cell_id()
	
	
func define_cell_id() -> void:
	match y_level:
		-2:
			cell_id = 0
			
		0:
			cell_id = 1
			
		2:
			cell_id = 2
			
			
func update_faces(cells: Array, tiles_list: Array) -> void:
	var cell_list: Array = tiles_list[cell_id]
	var my_grid_position = Vector2(translation.x/Globals.GRID_SIZE, translation.z/2)
	for index in faces_list.size():
		var cell: bool = cell_list.has(my_grid_position + directions_list[index])
		for object_cell_list in cells:
			for list in object_cell_list:
				var target_position: Vector2 = my_grid_position + directions_list[index]
				var list_position: Vector2 = list[0]
				var list_object = list[1]
				if list_position == target_position and list_object is Ladder:
					interpolate_tween(faces_list[index])
					
		if index >= 4:
			return
			
		if cell and is_instance_valid(faces_list[index]):
			
			interpolate_tween(faces_list[index])
			
			
func interpolate_tween(target_face: MeshInstance) -> void:
	var _modulate: bool = tween.interpolate_property(
		target_face,
		"scale",
		target_face.scale,
		Vector3.ZERO,
		0.5,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
	yield(tween, "tween_completed")
	target_face.queue_free()
