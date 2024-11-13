class_name Joint
extends Node2D

var should_draw: bool = true:
	set(value):
		should_draw = value
		queue_redraw()

var radius: int
var joint_distance: int
var anchor: bool

var previous_joint: Joint
var next_joint: Joint

func _process(_delta):
	if !anchor:
		_follow_chain()

func _follow_chain():
	if previous_joint != null:
		var previous_direction = (position - previous_joint.position).normalized()
		position = previous_joint.position + (previous_direction * joint_distance)

	if next_joint != null:
		var next_direction = (next_joint.position - position).normalized()
		var target_position = next_joint.position - (next_direction * joint_distance)
		position = position.lerp(target_position, 0.5)

func get_left_eye(eye_radius: float) -> Vector2:
	return (_get_point(PI / 2).normalized() * (radius - eye_radius)) + position

func get_right_eye(eye_radius: float) -> Vector2:
	return (_get_point(3 * PI / 2).normalized() * (radius - eye_radius)) + position

func get_right() -> Vector2:
	return _get_point(-PI / 2)

func get_top_right() -> Vector2:
	return _get_point(-3 * PI / 4)

func get_bottom_right() -> Vector2:
	return _get_point(-PI / 4)

func get_left() -> Vector2:
	return _get_point(PI / 2)
	
func get_top_left() -> Vector2:
	return _get_point(3 * PI / 4)

func get_bottom_left() -> Vector2:
	return _get_point(PI / 4)

func get_point(rad) -> Vector2:
	return _get_point(rad) + position

func _previous_joint_direction() -> Vector2:
	var pos_a = previous_joint.position
	var pos_b = position

	return pos_b - pos_a

func _next_joint_direction() -> Vector2:
	var pos_a = next_joint.position
	var pos_b = position

	return pos_b - pos_a

func _get_point(rad) -> Vector2:
	return Vector2(radius * cos(rad + _previous_joint_direction().angle()), radius * sin(rad + _previous_joint_direction().angle()))

func _draw():
	if should_draw:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 100, Color.WHITE, 10)
