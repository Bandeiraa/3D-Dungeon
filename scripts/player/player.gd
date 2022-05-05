extends Spatial
class_name Player

onready var animation: AnimationPlayer = get_node("Animation")
onready var timer: Timer= get_node("Timer")
onready var tween: Tween= get_node("Tween")

onready var forward_ray: RayCast = get_node("RayForward")
onready var right_ray: RayCast = get_node("RayRight")
onready var back_ray: RayCast = get_node("RayBack")
onready var left_ray: RayCast = get_node("RayLeft")

func collision_check(ray: RayCast) -> bool:
	if ray != null:
		return ray.is_colliding()
		
	return false
	
	
func get_direction(ray: RayCast) -> Vector3:
	if not ray is RayCast: 
		return Vector3.ZERO
		
	return ray.get_collider().global_transform.origin - global_transform.origin
	
	
func move_player(direction: Vector3) -> void:
	animation.play("step")
	var _translation: bool = tween.interpolate_property(
		self, 
		"translation", 
		translation, 
		translation + direction,
		0.5, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
	yield(tween, "tween_completed")
	
	
func rotate_player(direction: float) -> void:
	var _rotation: bool = tween.interpolate_property(
		self, 
		"rotation", 
		rotation, 
		rotation + Vector3(0, direction, 0),
		0.5, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)
	
	var _start: bool = tween.start()
	yield(tween, "tween_completed")
	
	
func on_timer_timeout() -> void:
	if get_turn_direction() or collision_check(get_raycast()):
		timer.stop()
		
		if get_turn_direction():
			yield(rotate_player(PI/2 * get_turn_direction()), "completed")
		elif collision_check(get_raycast()):
			yield(move_player(get_direction(get_raycast())), "completed")
			
		timer.start()
		
		
func get_raycast() -> RayCast:
	var go_back: bool = Input.is_action_pressed("ui_down")
	var go_left: bool = Input.is_action_pressed("ui_left")
	var go_right: bool = Input.is_action_pressed("ui_right")
	var go_foward: bool = Input.is_action_pressed("ui_up")
	
	var actions: Dictionary = {
		go_back: back_ray,
		go_left: left_ray,
		go_right: right_ray,
		go_foward: forward_ray
	}
	
	var ray_direction: RayCast
	for key in actions.keys():
		if key:
			ray_direction = actions[key]
			return ray_direction
			
	return null
	
	
func get_turn_direction() -> float:
	return Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
