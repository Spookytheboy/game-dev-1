extends CharacterBody2D

@export var speed = 400
@export var health = 100;
@export var damage = 6;
@export var attack_speed = 1;

var character_state = 'idle';
var last_direction = '';

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if(Input.is_action_pressed("left")):
		last_direction = "left";
		character_state = "moving";
		# play movement animation
		$AnimatedSprite2D.play(last_direction);
		
	elif(Input.is_action_pressed("right")):
		last_direction = "right";
		character_state = "moving";
		# play movement animation
		$AnimatedSprite2D.play(last_direction);
		
		$AnimatedSprite2D/HitBox.move_hitbox("left");
		
	elif(Input.is_action_pressed("up")):
		last_direction = "up";
		character_state = "moving";
		# play movement animation
		$AnimatedSprite2D.play(last_direction);
		
	elif(Input.is_action_pressed("down")):
		last_direction = "down";
		character_state = "moving";
		# play movement animation
		$AnimatedSprite2D.play(last_direction);
	
	elif(Input.is_action_pressed("attack")):
		character_state = "attacking";
		attack();
	
	else:
		character_state = "idle";
		$AnimatedSprite2D.stop();
		
	# move hitbox to match character forward direction
	$AnimatedSprite2D/HitBox.move_hitbox(last_direction);
	
	# disable attack speed timer if not in attacking state
	if(character_state != "attacking"):
		$AttackTimer.stop();
	

func attack():
	
	# play attack animation in the direction
	$AnimatedSprite2D.play("attack_" + last_direction);
	
	if($AttackTimer.time_left == 0):
		
		# start an attack timer based on attack speed
		print("Starting new attack");
		$HitSound.play();
		# send first attack 
		$AnimatedSprite2D/HitBox.set_hitbox_state(1);
		$AttackTimer.wait_time = attack_speed;
		$AttackTimer.one_shot = 0;
		$AttackTimer.start();
		
	else:
		$AnimatedSprite2D/HitBox.set_hitbox_state(0);

func _physics_process(delta):
	
	var screensize = get_viewport_rect().size;
	
	get_input();
	move_and_slide();
	
	if(character_state == "attacking"):
		$AnimatedSprite2D/HitBox.set_hitbox_state(1);
		# character_state = "idle";
	else:
		$AnimatedSprite2D/HitBox.set_hitbox_state(0);
		
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
#	if(Input.is_action_pressed("attack")):
#		var damage = $AttackRange/CollisionShape2D.damage;
#		print('character is attacking for '+damage+' damage');



func _on_hit_box_area_entered(area):
	print(character_state);
	
	if(character_state == "attacking"):
		if(area.has_method("take_damage")):
			area.take_damage(damage);


func _on_attack_timer_timeout():
	$AnimatedSprite2D/HitBox.set_hitbox_state(1);
	print('Attack timer timeout');
