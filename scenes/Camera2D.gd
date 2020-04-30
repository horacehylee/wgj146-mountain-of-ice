extends Camera2D

onready var player = $"../player"
const weight = 0.5
const y_bounds = 99

onready var global_vars = $"/root/Global"
onready var level = $"../Level"

onready var highest_y = position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if global_vars.dead:
		return
	
	var target_y_pos = player.position.y
	if target_y_pos > y_bounds:
		target_y_pos = y_bounds
#	if position.y < target_y_pos:
#		target_y_pos = position.y
	position.y = lerp(position.y, target_y_pos, weight)
	
	highest_y = min(highest_y, target_y_pos)
	
	var generated = level.generate(highest_y - global_vars.world_height / 2)
	if generated:
		level.destroy(highest_y + global_vars.world_height / 2)
	
	if player.position.y > highest_y + global_vars.world_height / 2 + 10:
		player.died()
	
	
