extends CharacterBody2D
class_name  PLayer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY = 1000
@export var SPEED : int = 250
@export var JUMP : int = -400
@export var JUMP_HORIZONTAL : int = 100

enum state { idle, run, jump, fall, grab}

var current_state : state

func _ready():
	current_state = state.idle
	
func _physics_process(delta):
	
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	check_ledge_grab(delta)
	
	player_animations()
	
	print("state: ", state.keys()[current_state])
	
	if state in [state.jump, state.fall]:
		check_ledge_grab(delta)
	
func player_falling(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		current_state = state.fall
		var direction = Input.get_axis("move_left", "move_right")
		animated_sprite_2d.flip_h = false if direction> 0 else true
		velocity.x += direction * JUMP_HORIZONTAL * delta
		
func check_ledge_grab(delta):
	if $WallCheck.is_colliding() and not $FloorCheck.is_colliding() and velocity.y == 0:
		current_state = state.grab
		$Grab_Trigger.disabled = current_state in [state.idle, state.run] or velocity.y < 0 or current_state != state.grab and $TopCheck.is_colliding()

func player_idle(delta):
	if is_on_floor() and current_state != state.grab:
		current_state = state.idle

func player_run(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0 and is_on_floor():
		current_state = state.run
		animated_sprite_2d.flip_h = false if direction> 0 else true
		
func player_jump(delta):
	if is_on_floor_only() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP
		current_state = state.jump
		
	if !is_on_floor() and current_state == state.jump:
		var direction = Input.get_axis("move_left", "move_right")
		animated_sprite_2d.flip_h = false if direction> 0 else true
		velocity.x += direction * JUMP_HORIZONTAL * delta
		

func player_animations():
	if current_state == state.idle:
		animated_sprite_2d.play("idle_animation")
	elif current_state == state.run:
		animated_sprite_2d.play("run_animation")
	elif current_state == state.jump:
		animated_sprite_2d.play("jump_animation_1")
	elif current_state == state.fall:
		animated_sprite_2d.play("jump_animation_2")
	elif current_state == state.grab:
		animated_sprite_2d.play("grab_animation")
