extends Node

const KNIGHT_START_POS := Vector2i(176, 373) #176, 376
const CAM_START_POS := Vector2i(576,324)

var speed : float
var score : int
const START_SPEED : float = 8.0
const MAX_SPEED : int = 20
var screen_size : Vector2i
var game_running : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()

func new_game():
	#reset var
	game_running = false
	score = 0
	show_score()
	
	#reset nodes
	$Knight.position = KNIGHT_START_POS
	$Knight.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,376)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		#moves knight, camera, and ground
		$Knight.position.x += START_SPEED
		$Camera2D.position.x += START_SPEED
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		score += START_SPEED
		#print(score/40)
		show_score()
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
func show_score():
	$HUD.get_node("ScoreLabel").text = "Score: " + str(score/40)
