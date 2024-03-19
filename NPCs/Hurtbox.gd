extends Area2D


var health = 100;

func take_damage(incoming_damage):
	print('Ouch!');
	# var parentHealth = health; # get_parent().health;
	
	# get_parent().set_ = (parentHealth - incoming_damage);
	
#	health = health - incoming_damage;
#
#	print(health);
	if(owner.has_method("take_damage")):
		owner.take_damage(incoming_damage);
