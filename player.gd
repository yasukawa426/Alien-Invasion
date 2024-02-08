extends Area2D

# velocidade que o player ira mover (pixel/sec)
@export var speed = 400

# Tamanho da janela do jogo.
var screen_size 

# O jogador emite esse sinal quando ele colide com algo (um inimigo ou projetil)
signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size #coloca o tamanho da janela na variavel.
	#hide() #esconde o player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Em cada frame checaremos o input, moveremos o jogador na direção do input e usaremos a animação adequada.
	
	# Primeiro, checar os inputs.
	var velocity = Vector2.ZERO # Vetor do movimento do jogador. Começa como (0, 0)
	
	# Se algum movimento está pressionado, alteramos o vetor de movimento de acordo e tocamos a animação
	# Se não, paramos a animação
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# "$" é uma abreviação de "get_node()" ,ou seja, o código escrito é o mesmo que "get_node("AnimatedSprite2D").play()"
		# Nesse caso, conseguimos pegar o node porque ele é filho do node atual que estamos mechendo.
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	#por fim, atualizamos a posição
	position += velocity * delta
	# clamp restringe o valor para um range, nesse caso o valor minimo é (0,0) e o maximo é o tamanho da tela.
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		
		# Caso necessario, viramos o sprite na outra direção.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


# Quando o nosso sinal body_entered vindo do area2d for emitido, essa função é executada
func _on_body_entered(_body):
	hide() # Escondemos o jogador
	hit.emit() # Emitimos o sinal de acertado
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true) # desabilitamos a colisão para nao emitir o sinal hit dnv.
	
# Reseta o jogador em new game
func start(pos):
	position = pos
	show() #mostra o jogador
	
	var collision: CollisionShape2D = $CollisionShape2D
	collision.disabled = false #habilita a colisão dnv
