extends Node2D

@onready var camera = $Camera2D

var animals = [
	{
		'name': 'snake',
		'joints_radius': [0, 75, 100, 100, 90, 80, 70, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 44, 42, 40, 40, 40, 40, 40, 40, 38, 38],
		'joint_distance': 100,
		'eye_index': 2,
		'color': Color.CRIMSON,
	},
	{
		'name': 'fish',
		'joints_radius': [0, 73, 89, 92, 90, 88, 82, 69, 65, 56, 43, 39, 37, 24, 20],
		'joint_distance': 75,
		'eye_index': 2,
		'color': Color.CORNFLOWER_BLUE,
	},
	{
		'name': 'lizard',
		'joints_radius': [0, 62, 68, 50, 70, 78, 81, 84, 74, 60, 38, 33, 20, 16, 14, 12, 12],
		'joint_distance': 80,
		'eye_index': 1,
		'color': Color.LIGHT_SEA_GREEN,
	},
]

var food = preload("res://food.tscn")

var _current_animal: Animal
var _current_animal_index = 0
var _new_egg_timer: Timer
var _new_animal_timer: Timer

func _ready():
	_setup_egg_timer()
	_setup_animal_timer()
	_new_animal()
	_new_egg()

func _new_animal():
	_current_animal = Animal.new()
	_current_animal.joints_radius = animals[_current_animal_index]['joints_radius'].duplicate()
	_current_animal.joint_distance = animals[_current_animal_index]['joint_distance']
	_current_animal.color = animals[_current_animal_index]['color']
	_current_animal.eye_index = animals[_current_animal_index]['eye_index']
	add_child(_current_animal)

func _setup_egg_timer():
	_new_egg_timer = Timer.new()
	_new_egg_timer.one_shot = true
	_new_egg_timer.wait_time = 5
	_new_egg_timer.timeout.connect(_on_new_egg_timeout)
	add_child(_new_egg_timer)

func _setup_animal_timer():
	_new_animal_timer = Timer.new()
	_new_animal_timer.one_shot = true
	_new_animal_timer.wait_time = 0.5
	
	_new_animal_timer.timeout.connect(_on_new_animal_timeout)
	add_child(_new_animal_timer)

func _new_egg():
	_new_egg_timer.start()

func _on_new_egg_timeout():
	var food_scene = food.instantiate()
	var x_range = get_viewport_rect().size.x / 2 - 100
	var y_range = get_viewport_rect().size.y / 2 - 100
	var _position = camera.position + Vector2(randf_range(-x_range, x_range), randf_range(-y_range, y_range))
	food_scene.position = _position
	_current_animal.food_position = _position
	add_child(food_scene)

func _on_new_animal_timeout():
	remove_child(_current_animal)
	
	if _current_animal_index == animals.size() - 1:
		_current_animal_index = 0
	else:
		_current_animal_index += 1
	
	_new_animal()
	_new_egg()

func next_animal():
	_new_animal_timer.start()
	
	
