extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const weight = 1
onready var init_y = rect_position.y
var pressed = false
const speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_y = 0
	if pressed:
		target_y = init_y
	rect_position.y = lerp(rect_position.y, target_y, weight * delta)
	if pressed and abs(target_y - rect_position.y) < 10:
		queue_free()

func _input(event):
	if event.is_action_pressed("move_left") || event.is_action_pressed("move_right") || event.is_action_pressed("jump"):
		pressed = true
