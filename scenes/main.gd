extends Node

const KNIGHT_START_POS := Vector2i(176, 373) #176, 376
const CAM_START_POS := Vector2i(576,324)

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 20
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game():
	$Knight.position = KNIGHT_START_POS
	$Knight.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,376)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#moves knight, camera, and ground
	$Knight.position.x += START_SPEED
	$Camera2D.position.x += START_SPEED
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
