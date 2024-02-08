extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#vamos escolher uma animação aleátoria para colocar no mob
	
	#pega os nomes daa animações  "["walk", "swim", "fly"]"
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	#escolhe uma aleatorioamente. randi() % n selects a random integer between 0 and n-1.
	#ficara play("nome da animação") Ex. play("walk")
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Assim q o mob sair da tela
func _on_visible_on_screen_notifier_2d_screen_exited():
	#deletamos o nodo dele
	queue_free()
