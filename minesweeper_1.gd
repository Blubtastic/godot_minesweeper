extends Button

var main_scene: PackedScene = preload("res://main.tscn")

func _pressed():
	get_tree().change_scene_to_packed(main_scene)
