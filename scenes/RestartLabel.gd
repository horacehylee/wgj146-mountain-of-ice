extends Label

onready var global_vars = $"/root/Global"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggered && global_vars.dead:
		visible = true
		triggered = true
		
func _input(event):
	if triggered && global_vars.dead && Input.is_action_pressed("restart"):
		global_vars.reset()
		get_tree().reload_current_scene()
