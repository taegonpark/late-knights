extends Node

#preload obstacles
var stump_scene = preload("res://scenes/stump.tscn")
var box_scene = preload("res://scenes/box.tscn")
var bat_scene = preload("res://scenes/bat.tscn")
var obstacle_types := [stump_scene, box_scene]
var obstacles : Array
var bat_heights := [200, 390]

#game variables
const KNIGHT_START_POS := Vector2i(176, 373) #176, 376
const CAM_START_POS := Vector2i(576,324)
var speed : float
var score : int
const START_SPEED : float = 9.0
const MAX_SPEED : int = 20
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	#reset var
	game_running = false
	score = 0
	show_score()
	get_tree().paused = false
	
	#delete all previous obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	#reset nodes
	$Knight.position = KNIGHT_START_POS
	$Knight.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,376)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if game_running:
		speed = START_SPEED + score / 4000
		#print(speed)
		if (speed > MAX_SPEED):
			speed = MAX_SPEED
		
		#generate obstacles
		generate_obs()
		
		#update score
		score += speed
		show_score()

		#update knight, camera, and ground position
		$Knight.position.x += speed
		$Camera2D.position.x += speed
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
		
		#remove off screen obstacles
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
			
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(100, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		var obs_height = obs.get_node("Sprite2D").texture.get_height()
		var obs_scale = obs.get_node("Sprite2D").scale
		var obs_x : int = screen_size.x + score + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 3) 
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
		#randomly spawns a bat
		if (randi() % 2 == 0):
			obs = bat_scene.instantiate()
			obs_x = screen_size.x + score + 100
			obs_y = bat_heights[randi() % bat_heights.size()]
			add_obs(obs, obs_x, obs_y)
			
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	#connect to obs signal
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Knight":
		#print("Collision")
		game_over()

func show_score():
	$HUD.get_node("ScoreLabel").text = "Score: " + str(score/40)

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.show()
