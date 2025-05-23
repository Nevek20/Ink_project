extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum {idle}



func _on_area_2d_area_entered(area: Area2D) -> void:
	animated_sprite_2d.play("idle")
	pass # Replace with function body.
