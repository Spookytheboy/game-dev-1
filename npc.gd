extends CharacterBody2D

var direction = 'idle';
var speed = 1;
var currentState = 1;
var states = {
	1: "IDLE",
	2: "WANDERING"
}
var screen = Vector2.ZERO;
var isNpcCollidingWithBoundaries = '';
var directionCannotContinue = '';
var directionList;

var health = 100;

func _ready():
	print('npc ready');
	$Timer.wait_time = randi_range(0, 1);
	$Timer.start();
	
	screen = get_viewport_rect().size;
	
	health = 100;
	
	print(screen);

func _process(delta):
	
	isNpcCollidingWithBoundaries = checkIfNpcCollidingWIthBoundaries();
	
	if(direction == "left"):
		position.x -= speed;
		$AnimatedSprite2D.play("left");
		
	if(direction == "right"):
		position.x += speed;
		$AnimatedSprite2D.play("right");
		
	if(direction == "up"):
		position.y -= speed;
		$AnimatedSprite2D.play("up");
		
	if(direction == "down"):
		position.y += speed;
		$AnimatedSprite2D.play("down");
		
	# lock character to the screen dimensions for movement
	position.x = clamp(position.x, 0, screen.x);
	position.y = clamp(position.y, 0, screen.y);
	
	# update health bar with current health
	$ProgressBar.value = health;
	
	# if current health falls below zero, destroy
	if(health <= 0):
		self.queue_free();
	
	
func checkIfNpcCollidingWIthBoundaries():
	
	directionList = ["left", "right", "up", "down"];
	
	directionCannotContinue = '';
	
	# if stuck on bottom of screen
	if(position.y == screen.y):
		directionCannotContinue = "down";
		directionList = ["up"];
		
	# if stuck on right  of screen
	if(position.x == screen.x):
		directionCannotContinue = "right";
		directionList = ["left"];
		
	# if stuck on left of screen
	if(position.x == 0):
		directionCannotContinue = "left";
		directionList = ["right"];
		
	# if stuck on top of screen
	if(position.y == 0):
		directionCannotContinue = "up";
		directionList = ["down"];
		
	if(directionCannotContinue != ''):
		print("NPC stuck moving " + directionCannotContinue + ". Next movement cannot include this");
	
	return directionCannotContinue;
		
	
func npc_wander():
	
	# decide how long to wander
	$Timer.wait_time = randi_range(1, 2);
	
	# randomize directional movement
	direction = directionList.pick_random();

	
func npc_idle():
	
	# decide how long to idle
	$Timer.wait_time = randi_range(1, 3);
	
	direction = 'idle';
	$AnimatedSprite2D.stop();
	
	# print("Idle...");
	

func decideMovementState():
	
	# decide movement state
	var newState = randi_range(1, 2);
	currentState = newState;
	
	if(currentState == 1):
		npc_wander();
	elif(currentState == 2):
		npc_idle();


func _on_timer_timeout():
	# print("Timer has timed out");
	decideMovementState();

	

func take_damage(incoming_damage):
	health = (health - incoming_damage);
	print(health);
