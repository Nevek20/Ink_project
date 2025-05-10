extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

func activate():
	GameManager.currentCheckpoint = self
	activated = true
	

func _on_area_2d_area_entered(area):
	print("Ativei")
	if area.get_parent() is PLayer && !activated:
		activate()
