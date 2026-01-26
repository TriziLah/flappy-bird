extends Node2D

@export var pipe_scene : PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
const SCROLL_SPEED: int = 4
var screen_size: Vector2i
var ground_height: int
var pipes: Array
const PIPE_SPAWN_X_OFFSET := 50
const PIPE_RANGE := 200

func new_game():
	game_over = false
	game_running = false
	scroll = 0
	score = 0
	$bird.reset()
	pipes.clear()
	$pipeTimer.stop()
	
func _input(event: InputEvent) -> void:
	if game_over:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not game_running:
			game_start()
		else:
			$bird.flap()


func game_start():
	game_running = true
	$bird.flying = true
	$bird.flap()
	generate_pipes()
	$pipeTimer.start()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		
	if scroll >= screen_size.x:
		scroll = 0
		
	$ground.position.x = -scroll
	
	for pipe in pipes:
		pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout() -> void:
	generate_pipes() # Replace with function body.
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_SPAWN_X_OFFSET
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)


func bird_hit():
	pass
