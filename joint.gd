class_name Joint
extends Node2D

var should_draw: bool = true:
	set(value):
		should_draw = value
		queue_redraw()

var should_move = false
var radius: int
var joint_distance: int

var previous_joint: Joint

func _process(_delta):
	if should_move:
		position = get_global_mouse_position()
	else:
		_follow_chain()

func _follow_chain():
	var previous_normal = _previous_joint_direction().normalized()
		
	position = previous_joint.position + (previous_normal * joint_distance)

func get_left_eye(eye_radius: float) -> Vector2:
	return (_get_point(PI / 2).normalized() * (radius - eye_radius)) + position

func get_right_eye(eye_radius: float) -> Vector2:
	return (_get_point(3 * PI / 2).normalized() * (radius - eye_radius)) + position

func get_point(rad) -> Vector2:
	return _get_point(rad) + position

func _previous_joint_direction() -> Vector2:
	var pos_a = previous_joint.position
	var pos_b = position

	return pos_a - pos_b if should_move else pos_b - pos_a

func _get_point(rad) -> Vector2:
	return Vector2(radius * cos(rad + _previous_joint_direction().angle()), radius * sin(rad + _previous_joint_direction().angle()))

func _draw():
	if should_draw:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 100, Color.WHITE, 10)
