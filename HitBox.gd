extends Area2D

@export var damage = 10;

func move_hitbox(direction_string):
	
	if(direction_string == "left"):
		self.position.x = 0;
		self.position.y = 0;
		self.rotation_degrees = 360;
		
	if(direction_string == "right"):
		self.position.x = 30;
		self.position.y = 0;
		self.rotation_degrees = 360;
		
	if(direction_string == "down"):
		self.position.x = 0;
		self.position.y = 30;
		self.rotation_degrees = 90;
		
	if(direction_string == "up"):
		self.position.x = -1.5;
		self.position.y = -0.5;
		self.rotation_degrees = 90;
	

func set_hitbox_state(state):
	if(state == 1):
		$CollisionShape2D.disabled = false;
	else:
		$CollisionShape2D.disabled = true;
