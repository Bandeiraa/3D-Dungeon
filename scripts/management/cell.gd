extends Spatial
class_name Cell

onready var tween: Tween = get_node("Tween")

onready var north_face: MeshInstance = get_node("NorthFace")
onready var south_face: MeshInstance = get_node("SouthFace")
onready var east_face: MeshInstance = get_node("EastFace")
onready var west_face: MeshInstance = get_node("WestFace")

onready var faces_list: Array = [
	north_face,
	south_face,
	east_face,
	west_face
]

var directions_list: Array = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.LEFT
]

func update_faces(cell_list: Array) -> void:
	var my_grid_position = Vector2(translation.x/Globals.GRID_SIZE, translation.z/2)
	for index in faces_list.size():
		if cell_list.has(my_grid_position + directions_list[index]) and is_instance_valid(faces_list[index]):
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
