class_name Eyes
extends Node2D

var eye_size: int
var color: Color

func _draw():
	draw_circle(Vector2.ZERO, eye_size, color)
