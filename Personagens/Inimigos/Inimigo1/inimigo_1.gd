extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var patrol_point : Node

const Gravidade = 1000
@export var Velocidade = 700
@export var pulo = -275
@export var pulo_h = 100
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int

enum state { idle, correndo, perseguindo, pulando}

var current_state : state
var direction : Vector2 = Vector2.LEFT

func ready():
	if patrol_point != null:
		number_of_points = patrol_point.get_children().size()
		for point in patrol_point.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else: 
		print("Sem pontos")
	
	current_state = state.idle

func _physics_process(delta):
	gravidade(delta)
	inimigo_parado(delta)
	inimigo_andando(delta)
	
	move_and_slide()

func gravidade(delta):
	if !is_on_floor():
		velocity.y += Gravidade * delta

func inimigo_parado(delta):
	velocity.x = move_toward(velocity.x, 0, Velocidade)
	current_state = state.idle

func inimigo_andando(delta):
	velocity.x = direction.x * Velocidade * delta
	current_state = state.correndo

func animação(delta):
	if current_state == state.idle:
		animated_sprite_2d.play("Idle")
