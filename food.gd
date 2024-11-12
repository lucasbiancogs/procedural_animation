extends Node2D

@onready var area_2d = $Area2D
@onready var procedural_animation = $".."

func _ready():
	area_2d.input_event.connect(_on_input)

func _on_input(_viewport, event, _shape_idx):
	if event is InputEventMouseMotion:
		queue_free()
		procedural_animation.next_animal()
