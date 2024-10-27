extends Node2D

var joints = []

var joints_radius = [100, 100, 60, 60, 60, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42, 40, 40, 40, 40, 40, 40, 38, 38]
var joint_distance = 100
var should_draw_joints = false
var should_draw_polygon = true

var polygon: Polygon2D
var eyes: Array

func _ready():
	_setup_joints()
	_setup_polygon()
	_setup_eyes()

func _process(_delta):
	if should_draw_polygon:
		_draw_polygon()
		_draw_eyes()

func _draw_polygon():
	var points = _points()
	
	var curve = _smooth(points, 30)
		
	polygon.polygon = curve.get_baked_points()

func _draw_eyes():
	var left_eye = eyes[0]
	var right_eye = eyes[1]
	
	left_eye.position = joints[0].get_left_eye(20)
	right_eye.position = joints[0].get_right_eye(20)

func _setup_eyes():
	var left_eye = Eyes.new()
	var right_eye = Eyes.new()
	
	add_child(left_eye)
	add_child(right_eye)
	
	eyes.append(left_eye)
	eyes.append(right_eye)

func _smooth(input: PackedVector2Array, radius: float) -> Curve2D:
	var curve = Curve2D.new()

	#calculate first point
	var start_dir = input[0].direction_to(input[1])
	curve.add_point(input[0], - start_dir * radius, start_dir * radius)

	#calculate middle points
	for i in range(1, input.size() - 1):
		var dir = input[i-1].direction_to(input[i+1])
		curve.add_point(input[i], -dir * radius, dir * radius)

	#calculate last point
	var end_dir = input[-1].direction_to(input[-2])
	curve.add_point(input[-1], - end_dir * radius, end_dir * radius)

	return curve

func _points() -> Array:
	var points = []
	
	# left points
	for i in joints.size():
		if (i == 0):
			var left_top = joints[i].get_point((PI / 4) + PI)
			points.append(left_top)
			
			var top = joints[i].get_top()
			points.append(top)
			
			var right_top = joints[i].get_point( PI - (PI / 4))
			points.append(right_top)
			
		var left = joints[i].get_left()
		points.append(left)
	
	for i in joints.size():
		var index = joints.size() - i - 1
		
		if i == 0:
			var bottom = joints[index].get_bottom()
			points.append(bottom)
			
		var point = joints[joints.size() - i - 1].get_right()
		points.append(point)
	
	return points

func _setup_polygon():
	polygon = Polygon2D.new()
	polygon.color = Color.WHITE
	add_child(polygon)	

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
		new_joint.chained_joint = joints[i]
		joints.append(new_joint)
	
	joints[0].chained_joint = joints[1]
	
	for joint in joints:
		add_child(joint)
	
