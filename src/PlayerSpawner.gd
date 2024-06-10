extends MultiplayerSpawner

@export var player_scene : PackedScene

func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawnPlayer)
		multiplayer.peer_disconnected.connect(removePlayer)
	
	
	pass
	
var players = {}

func spawnPlayer(data):
	var p : Node2D = player_scene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	return p

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
	
