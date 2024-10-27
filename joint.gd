class_name Joint
extends Node2D

var should_draw = true
var should_move = false
var radius = 100
var joint_distance = 100

var chained_joint: Joint

func _process(_delta):
	if should_move:
		position = get_global_mouse_position()
	else:
		_follow_chain()

func _follow_chain():
	var normal = _direction().normalized()

	position = chained_joint.position + (normal * chained_joint.joint_distance)

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

func _direction() -> Vector2:
	var pos_a = chained_joint.position
	var pos_b = position

	return pos_a - pos_b if should_move else pos_b - pos_a

func _get_point(rad) -> Vector2:
	return Vector2(radius * cos(rad + _direction().angle()), radius * sin(rad + _direction().angle()))

func _draw():
	if should_draw:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 100, Color.WHITE, 10)
