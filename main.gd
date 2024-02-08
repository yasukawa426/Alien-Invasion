extends Node

#a cena do mob q criamos
@export var mob_scene: PackedScene

#velocidade minima do mob
@export var mob_minimum_velocity: float = 150.0

#velocidade maxima do mob
@export var mob_maximum_velocity: float = 250.0

#pontuação
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# é chamada quando o jogador é acertado, emitindo "hit()"
func game_over():
	#para o timer de q conta score e o que spawna mobs
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	
	$HUD.show_game_over()

# reseta o jogo
func new_game():
	score = 0

	#removes todos os mobs do grupo mob da cena
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.update_score(score)
	$HUD.show_message($HUD.ready_message)
	
	
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
#quando o timer de start chegar a 0	
func _on_start_timer_timeout():
	#começa os outros timers
	$MobTimer.start()
	$ScoreTimer.start()

# quanto o timer de score chegar a 0
func _on_score_timer_timeout():
	#aumenta um ponto
	score += 1
	$HUD.update_score(score)

# quanto o timer de bom chegar a 0
func _on_mob_timer_timeout():
	#vamos criar um novo mob
	var mob = mob_scene.instantiate()
	
	# escolheremos uma posição aleatoria no MobPath
	var mob_spawn_location = $MobPath/MobSpawnLocation
	#pegamos uma posição aleatoria atraves do caminho
	mob_spawn_location.progress_ratio = randf()
	
	#mudaremos a rotação para ser perpendicular a direção do caminho.
	var direction = mob_spawn_location.rotation + PI / 2
	# alteramos um pouco a rotação de forma aleatoria.
	direction += randf_range(-PI/4 , PI/4)
	
	# Escolhemos a velocidade do mob
	var velocity = Vector2(randf_range(mob_minimum_velocity, mob_maximum_velocity), 0.0)

	# atualizamos o valor de posição, rotação e velocidade no mob
	mob.position = mob_spawn_location.position
	mob.rotation = direction
	mob.linear_velocity = velocity.rotated(direction) # e alteramos no bom
	
	# por fim, adicionamos à cena
	add_child(mob)
	

