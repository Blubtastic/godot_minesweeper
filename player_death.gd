extends Node3D
@onready var alive_player: CharacterBody3D = $AlivePlayer
@onready var dead_player: RigidBody3D = $AlivePlayer/DeadPlayer
@onready var dead_player_hitbox: CollisionShape3D = $AlivePlayer/DeadPlayer/CollisionShape3D
@onready var alive_player_hitbox: CollisionShape3D = $AlivePlayer/CollisionShape3D
@onready var alive_player_mesh: MeshInstance3D = $AlivePlayer/MeshInstance3D
@onready var alive_player_area: Area3D = $AlivePlayer/Area3D

func died():
	alive_player_hitbox.visible = false
	alive_player_mesh.visible = false
	alive_player_area.visible = false
	alive_player.is_controllable = false
	dead_player.visible = true
	dead_player.freeze = false
	dead_player_hitbox.disabled = false
