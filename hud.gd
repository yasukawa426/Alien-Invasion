extends CanvasLayer

#notifica main que o botao foi apertado
signal start_game

#Mensagens
@export var initial_message: String = "Desvie dos aliens!"
@export var ready_message: String = "Se prepare!"
@export var game_over_message: String = "Fim de Jogo"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message(game_over_message)
	
	#Espera o messageTimer acabar
	await $MessageTimer.timeout

	#Volta pro texto inicial
	$Message.text = initial_message
	$Message.show()
	
	# Mostra o botão de iniciar dnv depois de 1 segundo.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func _on_start_button_pressed():
	$StartButton.hide()	
	start_game.emit() 
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_message_timer_timeout():
	$Message.hide()
