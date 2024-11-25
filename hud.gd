extends Control
@onready var start_game: VBoxContainer = $StartGame
@onready var in_game_hud: Control = $InGameHUD

func game_started():
	start_game.visible = false
	in_game_hud.visible = true
