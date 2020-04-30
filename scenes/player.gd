extends KinematicBody2D

export(float) var gravity = 300
const up = Vector2(0, -1)

const x_speed = 100
const x_speed_air = 100
const x_speed_rebounded = 125

const jump_speed = -130
const width = 11
const rebounce_threshold = 20

onready var global_vars = $"/root/Global"
onready var sprite = $"Sprite"

var acceleration = Vector2()
var x_speed_temp = x_speed
var velocity = Vector2()
var rebounded = false

func died():
	print("dead")
	global_vars.dead = true

func _physics_process(delta):
	if global_vars.dead && position.y > 300:
		return
	
	var dir = 0
	if !global_vars.dead && Input.is_action_pressed("move_left"):
		dir = -1
		sprite.flip_h = true
	elif !global_vars.dead && Input.is_action_pressed("move_right"):
		dir = 1
		sprite.flip_h = false
	
	velocity.x = lerp(velocity.x, dir * _get_x_speed(), _get_x_weight())
	velocity.y += gravity * delta
	
	if is_on_floor():
		rebounded = false

	velocity = move_and_slide(velocity, up)
	
	if position.x < width / 2:
		position.x = width / 2
		if !rebounded and !is_on_floor() and velocity.y < rebounce_threshold:
			velocity.y = jump_speed
			velocity.x = -velocity.x
			rebounded = true
		else:
			velocity.x = 0
	elif position.x > get_viewport_rect().size.x - width / 2:
		position.x = get_viewport_rect().size.x - width / 2
		if !rebounded and !is_on_floor() and velocity.y < rebounce_threshold:
			velocity.y = jump_speed
			velocity.x = -velocity.x
			rebounded = true
		else:
			velocity.x = 0

func _get_x_speed():
	if rebounded:
		return x_speed_rebounded
	if is_on_floor():
		return x_speed
	else:
		return x_speed_air

func _get_x_weight():
	if rebounded:
		return 0.4
	if is_on_floor():
		return 0.05
	else:
		return 0.1

func _input(event):
	if !global_vars.dead && event.is_action_pressed("jump") && is_on_floor():
#		velocity.y = jump_speed + (abs(velocity.x) / 400) * jump_speed
		velocity.y = jump_speed
