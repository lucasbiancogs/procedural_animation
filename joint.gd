class_name Joint
extends Node2D

var should_draw = true
var should_move = false
var radius = 100
var joint_distance = 100

var previous_joint: Joint
var next_joint: Joint

var max_angle = PI / 4

func _process(_delta):
	if should_move:
		position = get_global_mouse_position()
	else:
		_follow_chain()

func _follow_chain():
	var previous_normal = _previous_joint_direction().normalized()
	var _normal: Vector2
	
	if next_joint == null:
		_normal = previous_normal
	else:
		var next_normal = _next_joint_direction().normalized()
		var angle = previous_normal.angle_to(next_normal)
	
		if angle > 0:
			_normal = previous_normal if angle > max_angle else Vector2.from_angle(max_angle)
		else:
			_normal = previous_normal if angle < -max_angle else Vector2.from_angle(-max_angle)
		
	position = previous_joint.position + (_normal * joint_distance)

func get_right() -> Vector2:
	return _get_point(3 * PI / 2) + position

func get_left() -> Vector2:
	return _get_point(PI / 2) + position

func get_left_eye(eye_radius: float) -> Vector2:
	return (_get_point(PI / 2).normalized() * (radius - eye_radius)) + position

func get_right_eye(eye_radius: float) -> Vector2:
	return (_get_point(3 * PI / 2).normalized() * (radius - eye_radius)) + position

func get_top() -> Vector2:
	return _get_point(PI) + position
	
func get_bottom() -> Vector2:
	return _get_point(0) + position

func get_point(rad) -> Vector2:
	return _get_point(rad) + position

func _previous_joint_direction() -> Vector2:
	var pos_a = previous_joint.position
	var pos_b = position

	return pos_a - pos_b if should_move else pos_b - pos_a

func _next_joint_direction() -> Vector2:
	var pos_a = next_joint.position
	var pos_b = position

	return pos_a - pos_b if should_move else pos_b - pos_a

func _get_point(rad) -> Vector2:
	return Vector2(radius * cos(rad + _previous_joint_direction().angle()), radius * sin(rad + _previous_joint_direction().angle()))

func _draw():
	if should_draw:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 100, Color.WHITE, 10)
