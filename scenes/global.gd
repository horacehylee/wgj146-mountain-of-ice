extends Node2D

const world_border = 5

var dead = false

onready var world_width = get_viewport_rect().size.x
onready var world_height = get_viewport_rect().size.y

func reset():
	dead = false
