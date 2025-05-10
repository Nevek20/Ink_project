extends Control

@onready var hp_bar = $PanelContainer/HBoxContainer/VBoxContainer/HpBar

var health: int = 100

# Define a barra de vida de acordo com a vida do Player
func _ready():
	hp_bar.value = GameManager.vida
	hp_bar.max_value = 100

func _process(delta):
	hp_bar.value = GameManager.vida
