extends Node2D

const platform_scene = preload("res://scenes/platform.tscn")
onready var platforms = $"platforms"
onready var init_start: Position2D = $"init_start"
onready var init_end: Position2D = $"init_end"

const x_lo_bounds = 24
const x_hi_bounds = 88

const platform_from = 10
const platform_to = 30
const platform_width = 16

const init_platform_start = 172
const init_platform_end = 0

var entities = []
onready var next_generate_y = init_start.position.y
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for y in range(init_start.position.y, init_end.position.y, -1):
		generate(y)

func generate(y: float):
	if y > next_generate_y:
		return false
	
	var level_entity = LevelEntity.new(platforms, y, rng)
	entities.push_front(level_entity)
	next_generate_y -= rng.randf_range(platform_from, platform_to)
	return true

func destroy(y: float):
	while entities.size() > 0:
		var last_entity: LevelEntity = entities[-1]
		if last_entity.y < y:
			break
		entities.pop_back()
		last_entity._destroy()

class LevelEntity:
	var parent: Node2D
	var y: float
	var rng: RandomNumberGenerator
	var entities = []
	
	func _init(parent, y, rng):
		self.parent = parent
		self.y = y
		self.rng = rng
		_populate()
	
	func _populate():
		var xstart = rng.randf_range(x_lo_bounds, x_hi_bounds - platform_width)
		var xend = xstart + rng.randi_range(0, int((x_hi_bounds - xstart) / platform_width)) * platform_width
		for i in range(xstart, xend + 1, platform_width):
			var entity: Node2D = platform_scene.instance()
			entity.position.x = i
			entity.position.y = self.y
			entities.push_back(entity)
			self.parent.add_child(entity)
	
	func _destroy():
		for e in entities:
			e.queue_free()
		entities = []
		parent = null
