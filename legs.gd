class_name Legs
extends Node2D

var shoulder_position: Vector2
var paw_position: Vector2
var joint_index: int
var color: Color
var stroke_size: int
var joints_radius = [10, 10, 10]
var joint_distance = 10
var stretch_ratio = 4
var joints = []
var line: Line2D
var stroke: Line2D
var should_draw_joints: bool = true:
	set(value):
		should_draw_joints = value
		_setup_visibility()

func _ready():
	_setup_joints()
	_setup_body_stroke()
	_setup_body()

func _process(_delta):
	_move_legs()
	_draw_line()
	_draw_stroke()

func _move_legs():
	joints[0].position = shoulder_position
	joints[2].position = paw_position

func _draw_line():
	line.points = _points()

func _draw_stroke():
	stroke.points = _points()

func _points() -> Array:
	var points = []
	
	for i in joints.size():
		points.append(joints[i].position)
	
	points.remove_at(0)
	
	return points

func _setup_body():
	line = Line2D.new()
	line.default_color = color
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.width = joints_radius.max() * 2
	
	add_child(line)

func _setup_body_stroke():
	stroke = Line2D.new()
	stroke.default_color = Color.WHITE
	stroke.begin_cap_mode = Line2D.LINE_CAP_ROUND
	stroke.end_cap_mode = Line2D.LINE_CAP_ROUND
	stroke.width = (joints_radius.max() * 2) + stroke_size
	
	add_child(stroke)

func _setup_joints():
	var shoulder = Joint.new()
	shoulder.anchor = true
	shoulder.should_draw = should_draw_joints
	shoulder.joint_distance = joint_distance
	shoulder.radius = joints_radius[0]
	shoulder.position = shoulder_position
	
	joints.append(shoulder)
	
	joints_radius.remove_at(0)
	
	var elbow = Joint.new()
	elbow.anchor = false
	elbow.should_draw = should_draw_joints
	elbow.radius = joints_radius[0]
	elbow.joint_distance = joint_distance
	elbow.position = joints[0].position + Vector2(joints_radius[0], 0)
	elbow.previous_joint = joints[0]
	
	joints.append(elbow)

	var paw = Joint.new()
	paw.anchor = true
	paw.should_draw = should_draw_joints
	paw.radius = joints_radius[1]
	paw.joint_distance = joint_distance
	paw.position = paw_position
	paw.previous_joint = joints[1]
	
	joints.append(paw)
	
	joints[0].next_joint = elbow
	joints[1].next_joint = paw
	
	for joint in joints:
		add_child(joint)

func _setup_visibility():
	line.visible = !should_draw_joints
	stroke.visible = !should_draw_joints
	for joint in joints:
		joint.should_draw = should_draw_joints
