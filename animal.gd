class_name Animal
extends Node2D

var joints = []

var joints_radius: Array
var joint_distance: int
var eye_index: int
var color: Color
var food_position
var stroke_size = 10
var should_draw_joints = false
var should_draw_body = true

var line: Line2D
var stroke: Line2D
var eyes: Array

func _ready():
	_setup_joints()
	_setup_stroke()
	_setup_line()
	_setup_eyes()
	_setup_pupil()
	_setup_visibility()

func _process(_delta):
	_draw_eyes()
	_draw_pupil()
	_draw_line()
	_draw_stroke()

func _input(event):
	if event is InputEventKey:
			if event.key_label == KEY_SPACE:
					should_draw_joints = event.pressed
					should_draw_body = !event.pressed
					_setup_visibility()
			

func _draw_line():
	line.points = _points()

func _draw_stroke():
	stroke.points = _points()

func _draw_eyes():
	var left_eye = eyes[0]
	var right_eye = eyes[1]
	
	left_eye.position = joints[eye_index].get_left_eye(left_eye.eye_size + stroke_size)
	right_eye.position = joints[eye_index].get_right_eye(right_eye.eye_size + stroke_size)

func _draw_pupil():
	var left_pupil = eyes[2]
	var right_pupil = eyes[3]
	
	var left_pupil_center = joints[eye_index].get_left_eye(_get_eye_size() + stroke_size)
	var left_pupil_direction_to_food = to_global(left_pupil_center).direction_to(to_global(food_position)) if food_position != null else Vector2.ZERO
	
	left_pupil.position = left_pupil_center + (left_pupil_direction_to_food * _get_eye_size() / 2)
	
	var right_pupil_center = joints[eye_index].get_right_eye(_get_eye_size() + stroke_size)
	var right_pupil_direction_to_food = to_global(right_pupil_center).direction_to(to_global(food_position)) if food_position != null else Vector2.ZERO
	
	right_pupil.position = right_pupil_center + (right_pupil_direction_to_food * _get_eye_size() / 2)

func _points() -> Array:
	var points = []
	
	for i in joints.size():
		points.append(joints[i].position)
	
	points.remove_at(0)
	
	return points

func _get_eye_size() -> float: 
	return joints_radius[eye_index] / 5
	
func _setup_visibility():
	line.visible = should_draw_body
	stroke.visible = should_draw_body
	for eye in eyes:
		eye.visible = should_draw_body
	for joint in joints:
		joint.should_draw = should_draw_joints

func _setup_eyes():
	var left_eye = Eyes.new()
	var right_eye = Eyes.new()
	
	left_eye.eye_size = _get_eye_size()
	left_eye.color = Color.WHITE
	
	right_eye.eye_size = _get_eye_size()
	right_eye.color = Color.WHITE
	
	add_child(left_eye)
	add_child(right_eye)
	
	eyes.append(left_eye)
	eyes.append(right_eye)

func _setup_pupil():
	var left_pupil = Eyes.new()
	var right_pupil = Eyes.new()
	
	var pupil_size = 5
	
	left_pupil.eye_size = pupil_size
	left_pupil.color = Color.BLACK
	
	right_pupil.eye_size = pupil_size
	right_pupil.color = Color.BLACK
	
	add_child(left_pupil)
	add_child(right_pupil)
	
	eyes.append(left_pupil)
	eyes.append(right_pupil)

func _setup_line():
	line = Line2D.new()
	line.default_color = color
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.width = joints_radius.max() * 2
	line.width_curve = _get_width_curve(0)
	
	add_child(line)

func _setup_stroke():
	stroke = Line2D.new()
	stroke.default_color = Color.WHITE
	stroke.begin_cap_mode = Line2D.LINE_CAP_ROUND
	stroke.end_cap_mode = Line2D.LINE_CAP_ROUND
	stroke.width = (joints_radius.max() * 2) + stroke_size
	stroke.width_curve = _get_width_curve(stroke_size)
	
	add_child(stroke)

func _get_width_curve(offset: float):
	var width_curve = Curve.new()
	
	for i in joints_radius.size():
		var width_ratio = float(joints_radius[i] + offset) / float(joints_radius.max() + offset)
		var position = float(i) / joints_radius.size()
		width_curve.add_point(Vector2(position, width_ratio))

	return width_curve

func _setup_joints():
	var first_joint = Joint.new()
	first_joint.should_move = true
	first_joint.should_draw = should_draw_joints
	first_joint.joint_distance = joint_distance
	first_joint.radius = joints_radius[0]
	first_joint.position = Vector2(1500, 1000)
	
	joints.append(first_joint)
	
	joints_radius.remove_at(0)
	
	for i in joints_radius.size():
		var new_joint = Joint.new()
		new_joint.should_move = false
		new_joint.should_draw = should_draw_joints
		new_joint.radius = joints_radius[i]
		new_joint.joint_distance = joint_distance
		new_joint.position = joints[i].position + Vector2(joints_radius[i], 0)
		new_joint.previous_joint = joints[i]
		
		joints.append(new_joint)
	
	joints[0].previous_joint = joints[1]
	
	for joint in joints:
		add_child(joint)
	
