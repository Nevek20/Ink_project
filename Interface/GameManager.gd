extends Node

#var currentCheckpoint = Checkpoint
var player: PLayer

@onready var vida : int = 100

func receberDano(quantidade : int):
	vida -= quantidade
	if vida <= 0:
		#respawnPlayer()
		pass

func respawnPlayer():
	vida = 100
	#if currentCheckpoint != null:
		#player.position = currentChekpoint.global_position

