extends Node2D

@onready var camera = $Camera2D

var animals = [
	{
		'name': 'snake',
		'joints_radius': [0, 75, 100, 100, 75, 60, 60, 60, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42, 40, 40, 40, 40, 40, 40, 38, 38],
		'joint_distance': 100,
		'color': Color.CRIMSON,
	},
	{
		'name': 'fish',
		'joints_radius': [0, 30, 50, 60, 80, 80, 80, 70, 55, 35, 15],
		'joint_distance': 80,
		'color': Color.CORNFLOWER_BLUE,
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
	
	
