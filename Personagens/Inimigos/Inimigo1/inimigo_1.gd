extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var patrol_point : Node

const Gravidade = 1000
@export var Velocidade = 700
@export var pulo = -275
@export var pulo_h = 100
var number_of_points : int
var point_positions : Array[Vector2]
var current_point_position : int

enum state { idle, correndo, perseguindo, pulando}

var current_state : state
var direction : Vector2 = Vector2.LEFT

func _ready():
	if patrol_point != null:
		number_of_points = 0
		point_positions.clear()
		for point in patrol_point.get_children():
			if point is Marker2D:
				point_positions.append(point.global_position)
				number_of_points += 1
		if number_of_points > 0:
			current_point_position = 0
		else: 
			print("Sem pontos funcionais")
	else:
		print("Sem pontos")

	current_state = state.idle

var tolerancia = 5.0 # tolerancia em qtd de px pra mudar

func _physics_process(delta):
	gravidade(delta)

	if point_positions.size() > 0:
		var posicao_alvo = point_positions[current_point_position]
		var distancia = global_position.distance_to(posicao_alvo)
		if distancia < tolerancia:
			current_state = state.idle
		else:
			current_state = state.correndo
			
	match current_state:
		state.idle:
			inimigo_parado(delta)
		state.correndo:
			inimigo_andando(delta)
			
	animação(delta)
	move_and_slide()

# a gravidade do inimiho
func gravidade(delta):
	if !is_on_floor():
		velocity.y += Gravidade * delta
	else:
		velocity.y = 0	

# responsavel pra ver se o inimigo ta parado
func inimigo_parado(delta):
	velocity.x = move_toward(velocity.x, 0.0, Velocidade * delta)
	current_state = state.idle

# responsavel pra ver se o inimigo ta andando
func inimigo_andando(delta):
	# se n tiver Patrol Point definido, ele fica parado
	if point_positions.size() == 0:
			return

	# pega a posição do Patrol Point e faz os calculos
	var posicao_alvo = point_positions[current_point_position]
	var direcao = (posicao_alvo - global_position).normalized()

	velocity.x = direcao.x * Velocidade
	# vai inverter o sprite pro lado q ta andando (foda, eu sei) // se a direção horizontal for negativa ele vai inverter
	animated_sprite_2d.flip_h = direcao.x < 0

	if global_position.distance_to(posicao_alvo) < 10:
		current_point_position = (current_point_position + 1) % point_positions.size()
	current_state = state.correndo

# pronto, ta funcionando o inimigo 1, deem uma lidinha no codigo e tentem replicar se precisarem!! qlqr coisa to aq pra ensinar oq eu escrevi

# puxa a animação do inimigo para o jogo
func animação(delta):
	if current_state == state.idle:
		animated_sprite_2d.play("Idle")
